function [Accuracy, D] = mainconf(Joint, GaborTrainIdx, lambda, tol2rho, PType, GaborFilterIdx, FilterAbs, Dataset, FilterType, ReconstructionMethod,  FeatureExtractionMethod,  Classifier, Splits, Output)

%%TODO - Should set default ones for some parameters.
%==========================================
%% ExampleConf:
% mainconf(1,[1:8],50,[1e-5, 1.9],'nothing',[1:8],'abs_px','Yale','Gabor40_real', 'ALM_XPDR', LDA', 'KNN', 10, 'Screen');
% mainconf(0,[1],50,[1e-5, 1.9],'nothing',[1],'abs_px','Yale','Gabor40_real', 'ALM_XPDR', LDA', 'KNN', 10, 'Screen');
%==========================================
%% GaborTrainIdx: 
%GaborIdx should be an Index Vector
%      1     2     3     4     5     6     7     8
%      9    10    11    12    13    14    15    16
%     17    18    19    20    21    22    23    24
%     25    26    27    28    29    30    31    32
%     33    34    35    36    37    38    39    40
%e.g. GaborIdx = [1:40]; means all 5*8 features;
%     GaborIdx = [1:8]; means the first scale, all 8 filters;
%     GaborIdx = [1,9,17,25,33]; gets the first scales
%==========================================
%% Joint
% bool: 0/1
% 1 means joint train one W; 
% 0 means train Wi separately;
%==========================================
%% lambda
% parameter to control the rank
% temporarily we use lambda as reducedDim 
% if PCA reconstruction is used
%==========================================
%% tol2rho
% a pair [tol2 rho] for ladmap
%==========================================
%% PType
% a srting, 'nothing' or 'abs' or 'realimag'
%==========================================
%% GaborFilterIdx
% The same as TrainGabor, set the filtering process.
% Currently we only use the same Idx for Filtering/Training
% Which means we assume if training with one setting, 
% you should keep it during the featureextraciton part
%==========================================
%% FilterAbs
% a srting, 'abs_px' or 'absp_x';
%==========================================
%% Dataset
% Data = 'Yale' ;                                 
% Data = 'ORL' ;                                
% Data = 'UMIST' ;                              
% Data = 'YaleB' ;                              
% Data = 'YaleB10' ;                            
% Data = 'AR' ;
%==========================================
%% Feature Filter Type
% LinearFilterType = 'Gabor40_real';
% LinearFilterType = 'SobelFilter';
% LinearFilterType = 'Gabor40';
% LinearFilterType = 'Nothing';
%==========================================
%% ReconstructionMethod
% ReconstructionMethod = 'Nothing';
% ReconstructionMethod = 'PCA';
% ReconstructionMethod = 'XPDR';
% ReconstructionMethod = 'LoadOld'
% ReconstructionMethod = 'ALM_XPDR';
% ReconstructionMethod = 'APG_XPDR';
%==========================================
%% Classifiers
% FeatureExtractionMethod = 'LDA' ;
% FeatureExtractionMethod = 'PCA' ;
% FeatureExtractionMethod = 'Nothing';
% FeatureExtractionMethod = 'Random' ;
% FeatureExtractionMethod = 'Identity' ;

%Classifier                = 'kNN' ;
%==========================================
%% Random splits
%  Splits = 10;
%==========================================
%% Output
%  Output = 'File' Output = 'Screen'

conf.GaborTrainIdx           = GaborTrainIdx;
conf.lambda                  = lambda;
conf.tol2rho                 = tol2rho;
conf.PType                   = PType;
conf.GaborFilterIdx          = GaborFilterIdx;
conf.FilterAbs               = FilterAbs;
conf.Dataset                 = Dataset;
conf.FilterType              = FilterType;
conf.FeatureExtractionMethod = FeatureExtractionMethod;
conf.ReconstructionMethod    = ReconstructionMethod;
conf.Classifier              = Classifier;
conf.Splits                  = Splits;
conf.Output					 = Output;

if Joint,
	[Accuracy, D] = joint_ppsl(conf);
else
	[Accuracy, D] = sep_ppsl(conf);
end





