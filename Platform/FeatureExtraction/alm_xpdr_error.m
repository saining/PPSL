function [W] = alm_xpdr_error(X, P, lambda)

tol = 1e-8;
maxIter = 1e6;
[d n] = size(X);
[m d] = size(P);
rho = 2;
max_mu = 1e10;
mu = 1e-6;
XX = X*X';
PP = P'*P;

W = zeros(d,d);
Z = zeros(d,d);
E = zeros(m,n);

Y1 = zeros(m,n);
Y2 = zeros(d,d);
%% Main
iter = 0;

disp(['initial,rank=' num2str(rank(W))]);
while iter<maxIter,
	iter = iter + 1;
	
    %update Z
	temp = W + Y2/mu;
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

    Z = U(:, 1:svp)*diag(sigma)*V(:,1:svp)';

    %update W
    A = -PP;
    B = XX;
    C = -( Y2/mu + P'*E*X' - (P'*Y1*X')/mu - PP*XX - Z ); 
    W = dlyap(A,B,C);

    %update E
    E = (Y1 - mu*P*W*X + mu*P*X)/(2*lambda + mu);

    leq1 = P*X - P*W*X - E;
    leq2 = W - Z;
    %stopC = max(max(max(abs(leq1))),max(max(abs(leq2))));

    norm_leq1 = norm(leq1,'fro');
    norm_leq2 = norm(leq2,'fro');
    stopC = max(norm_leq1, norm_leq2);

    if iter==1 || mod(iter,1)==0 || stopC<tol
        disp(['iter ' num2str(iter) ',mu=' num2str(mu,'%2.1e') ...
            ',rank=' num2str(rank(W,1e-3*norm(W,2))) ',stopALM=' num2str(stopC,'%2.3e')]);
    end
    
    if stopC<tol 
        disp('LRR done.');
        break;
    else
        Y1 = Y1 + mu*leq1;
        Y2 = Y2 + mu*leq2;
        mu = min(max_mu,mu*rho);
    end
end;