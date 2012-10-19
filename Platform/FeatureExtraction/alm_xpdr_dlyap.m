function [W] = alm_xpdr_dlyap(X, P, lambda)

tol = 1e-8;
maxIter = 1e6;
[d n] = size(X);
[m d] = size(P);
rho = 1.1;
max_mu = 1e10;
mu = 1e-1;
XX = X*X';
PP = real(P'*P);
PX = P*X;
PPXX = real(PP*XX);

W = zeros(d,d);
Z = zeros(d,d);

Y = zeros(d,d);
%% Main

iter = 0;

disp(['initial,rank=' num2str(rank(W))]);
while iter<maxIter,
	iter = iter + 1;
    
	%update W
	temp = Z + Y/mu;
	[U,sigma,V] = svd(temp,'econ');
	sigma = diag(sigma);

	%Soft thresholding
	svp = length(find(sigma>1/mu));
    if svp>=1
        sigma = sigma(1:svp)-1/mu;
    else
        svp = 1;
        sigma = 0;
    end

    W = U(:, 1:svp)*diag(sigma)*V(:,1:svp)';

    %update Z
    A = real(-2*lambda/mu*PP);
    B =  real(XX);
    C =  real(Y/mu - 2*lambda/mu*PPXX - W);
    Z = dlyap(A,B,C);
    Z = -real(Z);
    
    leq1 = Z - W;
    leq2 = PX-P*W*X;
    stopC = norm(abs(leq1),'fro');
    trueErr = norm(leq2, 'fro');

    if iter==1 || mod(iter,1)==0 || stopC<tol
        disp(['iter ' num2str(iter) ',mu=' num2str(mu,'%2.1e') ...
            ',rank=' num2str(rank(W,1e-3*norm(W,2))) ',stopALM=' num2str(stopC,'%2.3e') 'trueErr=' num2str(trueErr, '%2.3e') ]);
    end

    if stopC<tol 
        disp('LRR done.');
        break;
    else
        Y = Y + mu*leq1;
        mu = min(max_mu,mu*rho);
    end
end;