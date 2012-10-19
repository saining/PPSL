function [ProjectionMatrix, Rec_fea_Train, CoeffRank] = Reconstruction(ReconstructionMethod, fea_Train, conf)

        ReducedDim = conf.lambda;
        GaborIdx = conf.GaborTrainIdx;
        options.ReducedDim = ReducedDim;	
 		nSmp = size(fea_Train, 2);
		mean_fea_Train = repmat(mean(fea_Train, 2), 1, nSmp);

switch ReconstructionMethod
 	case 'PCA'
 		[eigvector, eigvalue] = PCA(fea_Train, options);
        CoeffRank = ReducedDim;

 	case 'XPDR'
		[eigvector, eigvalue] = XPDR(fea_Train, ReducedDim);
        CoeffRank = ReducedDim;
    case 'ALM_XPDR'
        filterType = 'Gabor40'; %arguments in fucntion ConstructFilterMatrix
        [filterMatrix, dumb] = ConstructFilterMatrix(filterType, fea_Train);
        filterMatrix = (filterMatrix(GaborIdx)); %filterMatrix is a cell
        filterMatrix = (cell2mat(filterMatrix));
        
        lambda = conf.lambda;
        PType = conf.PType;
        tol2 = conf.tol2rho(1);
        rho = conf.tol2rho(2);
        %filterMatrix = filterMatrix(1:1024,:);
        [W, E, CoeffRank] = ladmap_xpdr(fea_Train, filterMatrix, lambda, PType, tol2, rho);
        fprintf('%2.3f\n',CoeffRank);
    
    case 'APG_XPDR'
        filterType = 'Gabor40'; %arguments in fucntion ConstructFilterMatrix
        [filterMatrix, ~] = ConstructFilterMatrix(filterType, fea_Train);
        lambda = 1;
        tic
        %filterMatrix = filterMatrix(1:1024,:);
        [W, CoeffRank] = APG_xpdr(fea_Train, filterMatrix, lambda);
        fprintf('%2.3f\n',CoeffRank);
        toc
end
        if(strcmp(ReconstructionMethod,'ALM_XPDR'))  
            ProjectionMatrix = W;
            Rec_fea_Train = W*fea_Train;
        else
 		%reconstructed fea:
        ProjectionMatrix = eigvector*eigvector';
 		Rec_fea_Train = mean_fea_Train + eigvector*eigvector'*(fea_Train - mean_fea_Train);	
        %fea_Train = eigvector*eigvector'*(fea_Train - mean_fea_Train);	
        %Rec_fea_Train = eigvector*eigvector'*(fea_Train);	
        end;
end