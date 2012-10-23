function [Accuracy] = sep_ppsl(conf)
%Note that this file is delicated to produce Multiple Projection Matrices
%Currently, You should do the following steps to show the results:
%1. Run this program, note that conf.GaborIdx only have 1 value
%2. Copy the matrices file in 40Gabor folders to your corresponding folder
%3. Set the Reconstruction Method to be "LoadOld", Run Joint_PPSL program

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
	        Accuracy = size( Splits , length_D ) ;
%	    end
	    load( [path_data 'idxData' num2str(i)] ) ;
	    for ss = 1 : length(Splits),
            s = Splits(ss);
	        fea_Train = fea( : , idxTrain(s,:) ) ;
	        gnd_Train = gnd( idxTrain(s,:) ) ;
	        fea_Test = fea( : , idxTest(s,:) ) ;
	        gnd_Test = gnd( idxTest(s,:) ) ;
	        [fea_Train,gnd_Train,fea_Test,gnd_Test] = Arrange(fea_Train,gnd_Train,fea_Test,gnd_Test) ;
	        
	        if (length(GaborIdx) ~= 1)
	        	disp('Wrong!!!!!GaborIdx should only has one value');
	        end

	        [ProjectionMatrix, Rec_fea_Train, ReducedDim] = Reconstruction(ReconstructionMethod, fea_Train, conf);

	        ResultsMat = [ './Features/fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_s=' num2str(s) 'ProjectionMatrix' num2str(GaborIdx) ] ;	
	        save( ResultsMat , 'ProjectionMatrix','ReducedDim') ;
	    end
	end