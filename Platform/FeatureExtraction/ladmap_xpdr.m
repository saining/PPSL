function [W, E, Rank] = ladmap_xpdr(X, P, lambda, PType, tol2, rho)
% Linearized ADM

clear global;
global M;

%addpath PROPACK;

tol1 = 1e-4;

if nargin < 6
    disp('No rho specified!');
    rho = 1.9;
end
if nargin < 5
    disp('No tol2 specified!');
    tol2 = 1e-5; %same arg as ladmap_lrr
end
if nargin < 4
    disp('No PType specified!');
    PType = 'Nothing';
end
if nargin < 3
    disp('No lambda specified!');
    lambda = 20;
end

if strcmp(PType, 'abs')
    P = full(abs(P));
elseif strcmp(PType, 'realimag')
    P = full(P);
    P = [real(P);imag(P)];
else %nothing
    P = full(P);
end

[d n] = size(X);
[m d] = size(P);
normfX = norm(-P*X,'fro');

opt.tol = 1e-5;
opt.p0 = ones(d,1);

maxIter = 2;

max_mu = 1e10;
%OP1: A(W) = -PWX
%OP2: B(E) = -E
norm_OP1 = (norm(full(P),2))*(norm(X,2));
fprintf('norm of Op1:%.6f', norm_OP1);
%norm_OP2 = 1;

mu = min(d,n)*tol2;
eta = norm_OP1*norm_OP1*1.02;%omit the eta OP2

XX = X*X';
PP = P'*P;
PPXX = PP*XX;
PX = P*X;

%%Init
E = zeros(m,n);
W = zeros(d,d);
Y = zeros(m,n);

sv = 5;
svp = sv;

%%Main
convergenced = 0;
iter = 0;

while iter < maxIter
	iter = iter + 1;

	Ek = E;
	Wk = W;

    %update W
	%--call PROPACK--%
	M = Wk +(P'*(Y/mu-Ek)*X' - PP*Wk*XX  + PPXX)/eta;
	%[U,S,V] = lansvd(M, d, d, sv, 'L', opt);

    [U,sigma,V] = svd(M,'econ');
    sigma = diag(sigma);

    %Soft thresholding
    svp = length(find(sigma>1/(mu*eta)));
    if svp>=1
        sigma = sigma(1:svp)-1/(mu*eta);
    else
        svp = 1;
        sigma = 0;
    end

    W = U(:, 1:svp)*diag(sigma)*V(:,1:svp)';
    PWX = P*W*X;


	%update E
	%Linearize result is the same as Closed-form solution
	E = (Y - mu*PWX + mu*PX)/(2*lambda + mu);

	diffW = norm(Wk - W, 'fro');
	relChgW = diffW/normfX;
	relChgE = norm(E - Ek, 'fro')/normfX;
	relChg = max(relChgW, relChgE);

	dY = -PWX - E + PX;
	recErr = norm(dY, 'fro')/normfX;
    
    trueErr = norm(PX-PWX, 'fro');
    
    convergenced = recErr <tol1 && relChg < tol2;

    if iter==1 || mod(iter,1)==0 || convergenced
        disp(['iter ' num2str(iter) ',mu=' num2str(mu) ...
            ',rank(W)=' num2str(svp) ',relChg=' num2str(max(relChgW,relChgE))...
            ',recErr=' num2str(recErr) 'trueErr = ' num2str(trueErr)]);
    end

    if convergenced
    	break;
    else
    	Y = Y + mu*dY;

    	if mu*relChg < tol2
    		mu = min(max_mu, mu*rho);
    	end
    end    
end

Rank = rank(W);





