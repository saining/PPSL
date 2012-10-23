function [Accuracy, D] = joint_ppsl(conf)
	% clear ;
	% close all;
	currentpath = cd ;
	AddedPath = genpath( currentpath ) ;
	addpath( AddedPath ) ;
	
	Data                    = conf.Dataset;
	ReconstructionMethod    = conf.ReconstructionMethod;
	FilterType              = conf.FilterType;
	FeatureExtractionMethod = conf.FeatureExtractionMethod;
	Classifier              = conf.Classifier;
	Splits                  = conf.Splits;
	
	GaborIdx                = conf.GaborTrainIdx;

	switch Data
    	case 'Yale'
	        % Yale data,15 classes, 11samples per class
	        Train = 5;                         
	        D = [74]; %Max 74
	        
	        if strcmp( FeatureExtractionMethod , 'LDA' )
	            D = [ 3 5 7 9 11 13 14 ] ;                     
	        end
	end
	length_D = length(D) ;

	Output = conf.Output;
	if strcmp(Output, 'File')
		%% Output Results
		 ResultsTxt = [ './Results/' Data '/' datestr(now,30) '_' num2str(Train) 'Train_' Classifier '_' FeatureExtractionMethod '_D=[' num2str(D) ']_s=' num2str(Splits) '.txt' ] ;
		 fid = fopen( ResultsTxt , 'wt' ) ; 
	else            
		 fid = 1 ;                                      
	end

	fprintf( fid , '\n\n**************************************   %s   *************************************\n' , datestr(now) );
	fprintf( fid , ['Function                   = ' mfilename(currentpath) '.m\n' ] ) ;
	fprintf( fid ,  'Data                       = %s\n' , Data ) ;
	fprintf( fid ,  'FeatureExtractionMethod    = %s\n' , FeatureExtractionMethod ) ;
	fprintf( fid ,  'Classifier                 = %s\n' , Classifier ) ;
	fprintf( fid ,  'Splits                     = %d\n\n' , Splits ) ;

	%% Import Data
	path_data = ['./Data/' Data '/' ] ;
	load( [path_data , Data] ) ;
	for i = 1 : size(fea,2)
	   fea(:,i) = fea(:,i) / norm( fea(:,i) ) ;
	end

	for ii = 1: length( Train )
	    i = Train( ii ) ;                           
	    fprintf( fid , 'Train_%d : \n' , i ) ;
% 	    if strcmp( FeatureExtractionMethod , 'XPDR' )
% 	        Accuracy = size(Splits, 1);
% 	    else
	        Accuracy = size( length(Splits) , length_D ) ;
%	    end
	    load( [path_data 'idxData' num2str(i)] ) ;
	    for ss = 1 : length(Splits)  ,  
            s = Splits(ss);
	        fea_Train = fea( : , idxTrain(s,:) ) ;
	        gnd_Train = gnd( idxTrain(s,:) ) ;
	        fea_Test = fea( : , idxTest(s,:) ) ;
	        gnd_Test = gnd( idxTest(s,:) ) ;
	        [fea_Train,gnd_Train,fea_Test,gnd_Test] = Arrange(fea_Train,gnd_Train,fea_Test,gnd_Test) ;
	        
	        if strcmp(ReconstructionMethod, 'Nothing')
	        	DoLoad = 1;
                AbsComplex = 1;
                
                if (DoLoad == 1)
                    respath = [ './Features/Test' num2str(s)]; 
                    load(respath);
                    Rec_fea_Test = ProjectionMatrix * fea_Test;
                    if AbsComplex == 1
                        Rec_fea_Test = (Rec_fea_Test);
                    end
                    
                else             
                    Rec_fea_Test = fea_Test;
	            end
                
	            disp('filtering!');
        	    if strcmp(FilterType, 'Nothing')
        	    	disp('No filtering');
        	    	Filtered_fea_Train = fea_Train;
					Filtered_fea_Test = Rec_fea_Test;	
	            else
	            	disp('filtering!');
	             	[Filtered_fea_Train] = LinearFilter(FilterType, fea_Train, GaborIdx);
	            	disp('Train filtered!');
	            	[Filtered_fea_Test] = LinearFilter(FilterType, Rec_fea_Test, GaborIdx);
	            	disp('Test filtered!');
                    [Filtered_ori_fea_Test] = LinearFilter(FilterType, fea_Test, GaborIdx);
	            	disp('Original Test filtered!');
                    fprintf('The difference: %.8f', norm(Filtered_ori_fea_Test - Filtered_fea_Test, 'fro'));
	        	end
	            
	            if strcmp(FeatureExtractionMethod, 'Nothing')
	                D = [size(Filtered_fea_Train, 1)];
	            end

	        elseif strcmp(ReconstructionMethod, 'LoadOld')
		        	
	        	Rec_fea_Test = [];
	        	if strcmp(FilterType, 'Nothing')
		        	disp('No filtering!');
					Filtered_fea_Train = fea_Train;
                else
                    disp('filtering!');
		            [Filtered_fea_Train] = LinearFilter(FilterType, fea_Train, GaborIdx);
		            disp('Train filtered!');
		        end

		        if strcmp(FeatureExtractionMethod, 'Nothing')
	                D = [length(GaborIdx)*1024]; %To make the train and test have the same dimension
	            end
		            
		        Filtered_fea_Test = [];
		        for p = 1:length(GaborIdx)
		            ResultsMat = [ './40Garbor/fea_Train' num2str(i) 'Train_' Data '_' 'ALM_XPDR' '_s=' num2str(s) 'ProjectionMatrix' num2str(p) ] ; 
		            load(ResultsMat);
		                temp = ProjectionMatrix * fea_Test;
		                %Showimage(temp, [32,32], [9,10]);

		                if strcmp(FilterType, 'Nothing')
		                	Filtered_temp_Test = temp;
		                else	
			                [Filtered_temp_Test] = LinearFilter(FilterType, temp, GaborIdx(p));
			           	end

			            Filtered_fea_Test = [Filtered_fea_Test; Filtered_temp_Test];
			            disp('Test filtered!');
		            end
	        else
		       	% Get the Reconstructed Image
	            ReducedDim = conf.lambda; % For PCA
	            % 0 means use full-rank;
	            tic;
	            [ProjectionMatrix, Rec_fea_Train, ReducedDim] = Reconstruction(ReconstructionMethod, fea_Train, conf);
				reconstructiontime = toc;
				[time1, time2]     = strtok(num2str(reconstructiontime),'.');
				time2              = time2(2:end);
	            %[fea_Train, ReducedDim] = Reconstruction(ReconstructionMethod, fea_Train, ReducedDim);
	            
	            %ResultsMat = [ '.\Features\fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_ReducedDim=' num2str(ReducedDim) '_s=' num2str(Splits) ] ; % '_D=[' num2str(D) ']_s=' '
	            %disp(ResultsMat);
	            %save( ResultsMat , 'Rec_fea_Train','ReducedDim' ) ;
	            respath = [ './Features/' datestr(now,30) '_Joint_fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_ReducedDim=' num2str(ReducedDim) '_s=' num2str(s) '_time=' time1 '_' time2 '_ProjectionMatrix' ]; 
	           	save( respath, 'ProjectionMatrix', 'ReducedDim' ) ;
                
	            %Compress the test image:
	            if strcmp(ReconstructionMethod, 'PCA')
                    nSmp = size(fea_Test, 2);
                    mean_fea_Test = repmat(mean(fea_Test, 2), 1, nSmp);
                    Rec_fea_Test =mean_fea_Test + ProjectionMatrix * (fea_Test-mean_fea_Test);
                else
                    Rec_fea_Test = ProjectionMatrix * fea_Test;
                end
                
	            if strcmp(FilterType, 'Nothing')
		            disp('No filtering!');
					Filtered_fea_Train = fea_Train;
					Filtered_fea_Test  = Rec_fea_Test;
                    D = [1024];
		        else
		            % Feature Extraction with Linear Filter
		            disp('filtering!');
		            [Filtered_fea_Train] = LinearFilter(FilterType, fea_Train, GaborIdx);
		            disp('Train filtered!');
		            [Filtered_fea_Test] = LinearFilter(FilterType, Rec_fea_Test, GaborIdx);
		            disp('Test filtered!');
%                     [Filtered_ori_fea_Test] = LinearFilter(FilterType, fea_Test, GaborIdx);
% 	            	disp('Original Test filtered!');
%                     fprintf('The difference: %.8f', norm(Filtered_ori_fea_Test - Filtered_fea_Test, 'fro'));
		        end
	        end

		    %Classification
	        
	        if strcmp(FeatureExtractionMethod, 'Nothing')
	            Yfea_Train = Filtered_fea_Train;
				Yfea_Test  = Filtered_fea_Test;
                D = [length(GaborIdx)*1024];
	        else
				[Yfea_Train , Yfea_Test redDim] = FeatureExtraction( FeatureExtractionMethod , Filtered_fea_Train , gnd_Train , Filtered_fea_Test );
	        end

	        for dd = 1 : length_D
	            d = D(dd) ;
                fprintf('Current Feature Dimension: %d',d);
	            tic
	            Accuracy(ss,dd) = eval( [ Classifier '( Yfea_Train(1:d,:) , gnd_Train , Yfea_Test(1:d,:) , gnd_Test )' ] ) ;
	            toc
        	end
	    end

% 	    ave_Acc = mean( Accuracy , 1 ) ;
% 	    [max_Acc,dd] = max( ave_Acc ) ;
% 	    max_Dim = D( dd ) ;
% 	    std_Acc = std( Accuracy(:,dd) ) ;
% 	    
% 	    fprintf( fid , 'Dim =\t\t' ) ;
% 	    for dd = 1 : length_D
% 	        fprintf( fid , '\t%5d' , D(dd) ) ;
% 	    end
% 	    fprintf( fid , '\n' ) ;
% 	    for ss = 1 : length(Splits),
%             s = Splits(ss);
% 	        fprintf( fid, 's = %2d\t%8s' , s , FeatureExtractionMethod ) ;
% 	        for dd = 1 : length_D
% 	            d = D(dd) ;
% 	            fprintf( fid , '\t%.2f ' , Accuracy(ss,dd)*100 ) ;
% 	        end
% 	        fprintf( fid , '\n' ) ;
% 	    end
% 	    fprintf( fid , 'ave_Acc %8s ' , FeatureExtractionMethod ) ;
% 	    for dd = 1 : length_D
% 	        d = D(dd) ;
% 	        fprintf( fid , '\t%.2f ' , ave_Acc(dd)*100 ) ;
% 	    end
% 	    fprintf( fid , '\n' ) ;
% 	    fprintf( fid , '%dTrain max_Acc+-std_Acc = %.2f+-%.2f , max_Dim = %d\n' , i , max_Acc*100 , std_Acc*100 , max_Dim  ) ;
% 	    fprintf( fid , '%dTrain data is done!\n',i) ;
	end











