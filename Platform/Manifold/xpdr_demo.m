function xpdr_demo
%-------------------------------------------------------------
clear all;
clc

%%
% seed = 2010;
% fprintf('seed: %d\n', seed);
% if exist('RandStream','file')
%    RandStream.setDefaultStream(RandStream('mt19937ar','seed',seed));
% else
%    rand('state',seed); randn('state',seed^2);
% end
%%

nlist = 1024;
nlen = length(nlist);

perf = zeros(10,nlen);

for dn = 1:nlen
    n = nlist(dn);
    fprintf('matrix size: %d\n', nlist(dn));
    
    %----------------------------------------%
    m = 2*n; %linear operator's dimension
    P = randn(m, n);
    PP = P'*P;
    r = 1000; %data instance number
    X = randn(n,r);
    XX = X*X';
    
    drfactor = 0.3;
    k = ceil(drfactor*n);
    %----------------------------------------%
    
    U0 = randn(n,k);    U0 = orth(U0);
    
    opts.record= 1;
    opts.mxitr= 1000;
    opts.xtol= 1e-5;
    opts.gtol= 1e-5;
    opts.ftol = 1e-8;
    out.tau = 1e-3;
    %opts.nt = 1;
    
    %profile on;
    tic; [U, out]= OptStiefelGBB(U0, @funxpdr, opts, X, XX, P, PP); tsolve = toc;
    %profile viewer;
    
    % profile viewer;
    fprintf('ours: obj val %7.6e, cpu %f, #func eval %d, itr %d, |XT*X-I| %3.2e\n', ...
       out.fval, tsolve, out.nfe, out.itr, norm(U'*U - eye(k), 'fro'));
    out.feasi = norm(U'*U - eye(k), 'fro');
    
    
%    perf(:,dn) = [out.fval;  out.feasi; out.nrmG; out.nfe; tsolve];

end
% save('results/eig_rand_perf', 'perf', 'nlist');

function [F, G] = funxpdr(U, X, XX, P, PP)
    UU = U*U';
    q = P*X-P*UU*X;
    F = sum(sum(real(conj(q).*(q))))/2;
    G = XX*UU*PP*U + PP*UU*XX*U - (XX*PP + PP*XX)*U;
end


end
