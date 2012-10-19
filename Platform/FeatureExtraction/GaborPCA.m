function [eigvector, eigvalue] = GaborPCA(data, options)

if (~exist('options','var'))
    options = [];
end

	[eigvector, eigvalue] = PCA(data, options);
	
	
	gopt.f = 1;
	gopt.theta = 0;
	gopt.gamma = 1;
	gopt.eta = 1;
	gopt.size = [25 25];
	[~, gaborFea] = GaborFilter(data, gopt);

	[eigvector, eigvalue] = PCA(gaborFea, options);

end
