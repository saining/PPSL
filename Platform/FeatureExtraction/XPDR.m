function [eigvector, eigvalue] = XPDR(data,filterMatrix, reddim)

	seed = 2010;
	fprintf('seed: %d\n', seed);
	if exist('RandStream','file')
	   RandStream.setDefaultStream(RandStream('mt19937ar','seed',seed));
	else
	   rand('state',seed); randn('state',seed^2);
	end

	n = size(data, 1);
    P = full(abs(filterMatrix));
    %P = eye(size(P));

    PP = P'*P;
    r = size(data,2); %data instance number
    X = data;
    XX = X*X';
    
    %drfactor = 0.3;
    %k = ceil(drfactor*n);
    if (reddim == 0),
       k = n; 
    end

    k = reddim;
    %----------------------------------------%
    
    U0 = randn(n,k);    
    U0 = orth(U0);
    

    if (~exist('options','var'))
    options = [];
    end

    ReducedDim = 0;
    if isfield(options,'ReducedDim')
        ReducedDim = options.ReducedDim;
    end


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

	function [F, G] = funxpdr(U, X, XX, P, PP)
	    UU = U*U';
	    q = P*X-P*UU*X;
	    F = sum(sum(real(conj(q).*(q))))/2;
	    G = XX*UU*PP*U + PP*UU*XX*U - (XX*PP + PP*XX)*U;
	end

	eigvector = U;
    eigvalue = zeros(reddim,1);

end
