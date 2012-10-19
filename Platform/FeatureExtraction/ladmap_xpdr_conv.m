function [W, E, Rank] = ladmap_xpdr_conv(X, k, lambda, rho, DEBUG)
% Linearized ADM

clear global;
global M;

addpath PROPACK;

if (~exist('DEBUG','var'))
    DEBUG = 0;
end
if nargin < 4
    rho = 1.9;
end
if nargin < 3
    lambda = 0.1;
end

[m n] = size(X);
kX = conv2(X,k,'same');
normfX = norm(kX,'fro');

tol1    = 1e-4;
tol2    = 1e-5; %same arg as ladmap_lrr
%opt.tol = 1e-5;
%opt.p0  = ones(d,1);

maxIter = 1000;

max_mu  = 1e10;
%OP1: A(W) = -PWX
%OP2: B(E) = -E
[P, ~] = same_convmtx2(k, X);
tic
%norm_OP1 = (svds(P,1)*(norm(X,2)));
norm_OP1 = ((norm(X,2)));
toc
fprintf('norm of Op1:%.6f', norm_OP1);
%norm_OP2 = 1;

mu = min(m,n)*tol2;
eta = norm_OP1*norm_OP1*1.02;%omit the eta OP2

kt  = conj(-k);
kac = conv2(kt, k);
kacXX = conv2(X, kac, 'same')*X';

%%Init
E   = zeros(m,n);
W   = zeros(m,m);
Y   = zeros(m,n);

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
	%M = Wk - (conv2(Y, kt, 'same')*X'/mu + (conv2(Wk*X, kac, 'same') + conv2(Ek, kt, 'same'))*X' - kacXX)/eta;
	temp = Y + mu*(conv2(Wk*X, k, 'same')+ Ek - kX);
    temp = conv2(temp, kt, 'same');
    temp = temp*X'/eta*mu;
    M = Wk - temp;
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
    kWX = conv2(W*X, k, 'same');


	%update E
	%Linearize result is the same as Closed-form solution
	E = (Y - mu*kWX + mu*kX)/(2*lambda + mu);

	diffW = norm(Wk - W, 'fro');
	relChgW = diffW/normfX;
	relChgE = norm(E - Ek, 'fro')/normfX;
	relChg = max(relChgW, relChgE);

	dY = kWX + E - kX;
	recErr = norm(dY, 'fro')/normfX;
    
    trueErr = norm(kX-kWX, 'fro');
    
    convergenced = recErr <tol1 && relChg < tol2;

    if iter==1 || mod(iter,50)==0 || convergenced
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





