% clear ;
% close all;
currentpath = cd ;
AddedPath = genpath( currentpath ) ;
addpath( AddedPath ) ;
% fprintf('\n\n**************************************   %s   *************************************\n' , datestr(now) );
% fprintf( [ mfilename(currentpath) ' Begins.\n' ] ) ;
% fprintf( [ mfilename(currentpath) ' is going, please wait...\n' ] ) ;

%% 人脸数据选择
Data = 'Yale' ;                                 % Yale数据,15类，每类11个样本，共165个样本
% Data = 'ORL' ;                                  % ORL数据，40类，每类10个样本，共400个样本
% Data = 'UMIST' ;                                % UMIST数据，20类，每类约29个样本，共575个样本
% Data = 'YaleB' ;                                % YaleB数据，38类，每类约64个样本
% Data = 'YaleB10' ;                              % YaleB10数据，从YaleB中抽取前10类的样本，10类，每类约64个样本
% Data = 'AR' ;                                   % AR数据，100类，每类14个样本

%% 降维方法选择
% FeatureExtractionMethod = 'PCA' ;
% FeatureExtractionMethod = 'OP_SRC' ; % 'SRC_DP' ;   % 

% FeatureExtractionMethod = 'OP_LRC' ;
% FeatureExtractionMethod = 'XPDR';
% FeatureExtractionMethod = 'GaborPCA';
  FeatureExtractionMethod = 'LDA' ; 
% FeatureExtractionMethod = 'MMC' ;
% FeatureExtractionMethod = 'Random' ;
% FeatureExtractionMethod = 'OP_NFS' ;
% FeatureExtractionMethod = 'Identity' ;
% FeatureExtractionMethod = 'LPP' ;   % 没调通
% FeatureExtractionMethod = 'LRPP' ;
% FeatureExtractionMethod = 'SLRPP' ;
% FeatureExtractionMethod = 'SPP' ;
% FeatureExtractionMethod = 'MaxSubAngel' ;

%% Reconstruction Methods
%ReconstructionMethod = 'PCA';
ReconstructionMethod = 'XPDR';

%% Feature Filter
LinearFilterType = '2D-GaborFilter';

%% 分类器选择
% Classifier = 'SRC_lu_SPAMS' ;
% Classifier = 'KLRC' ;
% Classifier = 'SingularFeature' ;
% Classifier = 'WSRC_SPAMS' ;
Classifier = 'kNN' ;
% Classifier = 'NFS' ;
% Classifier = 'NFS_gui' ;
% Classifier = 'SRC_lu' ;
% Classifier = 'SRC_QC1' ;
% Classifier = 'SRCe' ;
% Classifier = 'OrthonormalL2' ;
% Classifier = 'LRRC' ;
% Classifier = 'DiffSingular' ;
% Classifier = 'WLRC' ;


%% Random splits
splits = 10;                                    

%% 降维方法维数设置
switch Data
    case 'Yale'
        % Yale data,15 classes, 11samples per class
        Train = 5 : 5 ;                         % 每类中训练样本个数，对于不同的Train维数要改变，因此这里暂时不适合对Train个数改变。
         D = [10 30 50 60 70 74 ] ;
%        D = [ 1: 74 ] ;                % PCA，6Train时最高维89
%         D = [ 5 10 15 20 25 30 40 50  60 70 80 85 89] ;                % PCA，6Train时最高维89
%         D = 60 ;
%         D = [50 100 200 300 500 700 1000] ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 3 5 7 9 11 13 14 ] ;                        % LDA，最高维14
%             D = 14 ;
        end
    case 'ORL'
        % ORL数据，40类，每类10个样本
        Train = 4 : 4 ;                         % 每类中训练样本个数
        D = [ 10 30 50 80 120 150 180 195] ;              % PCA，5Train时最高维199
%         D = 5 : 5 : 199
%         D = [ 120 140 160 180 199] ;              % PCA，5Train时最高维199
        D = 1:159 ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 5 10 20 25 30 35 39] ;                        % LDA，最高维39
        end
    case 'UMIST'
        % UMIST数据，20类，每类约29个样本，共575个样本
        Train = 12 : 12 ;                         % 每类中训练样本个数
        D = [ 30 60 80 100 110 ] ;              % PCA，6Train时最高维119
%         D = [ 120 140 160 180 199] ;
%         D = 5 : 5 : 237 ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 5:5:19] ;                        % LDA，最高维39
        end
        
    case 'YaleB'
        % YaleB数据，38类，每类约64个样本
        Train = 30 : 30 ;                       % 每类中训练样本个数
        D = [ 30 56 120 504] ;%             
                             % PCA，30Train时最高维1024
        D = [ 30 56 ] ; %可以从20开始就好
        if strcmp( FeatureExtractionMethod , 'LDA' )
%             D = [ 5 10 15 30 35 37] ;
            D = [ 5:5:37 ] ;                        % LDA，最高维37
%             D = 1 : 37 ;
        end
    case 'YaleB10'
        % YaleB10数据，YaleB数据的前10类，10类，每类约64个样本
        Train = 30 : 30 ;                       % 每类中训练样本个数
        D = [ 50 ] ;
%             
                             % PCA，30Train时最高维1024
%         D = 20:5:120 ; %可以从20开始就好
        if strcmp( FeatureExtractionMethod , 'LDA' )
            D = [ 7 8 9] ;
%             D = [ 5:5:37 ] ;                        % LDA，最高维37
        end
    case 'AR'
        % AR数据，100类，每类14个样本
        Train = 7 : 7 ;                         % 每类中训练样本个数
        D = [ 30 54 130 540] ;                  % PCA，7Train时最高维699
        D = [ 30 54  ] ;
        if strcmp( FeatureExtractionMethod , 'LDA' )
%             D = [ 30 56 99] ;                   % LDA，最高维99
            D = [ 10 20 30 40 50 60 70 80 90] ; 
        end
end
length_D = length(D) ;

%% 输出结果
% ResultsTxt = [ '.\Results\' Data '\' num2str(Train) 'Train_' Classifier '_' FeatureExtractionMethod '_D=[' num2str(D) ']_s=' num2str(splits) '.txt' ] ;
% fid = fopen( ResultsTxt , 'wt' ) ;              % 输出结果到文本文件
fid = 1 ;                                       % 输出结果到屏幕
fprintf( fid , '\n\n**************************************   %s   *************************************\n' , datestr(now) );
fprintf( fid , ['Function                   = ' mfilename(currentpath) '.m\n' ] ) ;
fprintf( fid ,  'Data                       = %s\n' , Data ) ;
fprintf( fid ,  'FeatureExtractionMethod    = %s\n' , FeatureExtractionMethod ) ;
fprintf( fid ,  'Classifier                 = %s\n' , Classifier ) ;
fprintf( fid ,  'splits                     = %d\n\n' , splits ) ;

%% 数据导入、归一化
path_data = ['.\Data\' Data '_lu\' ] ;
load( [path_data , Data] ) ;
for i = 1 : size(fea,2)
    fea(:,i) = fea(:,i) / norm( fea(:,i) ) ;
end


%% 降维、分类、输出结果
for ii = 1: length( Train )    
    i = Train( ii ) ;                           % i是每类中训练样本个数
    fprintf( fid , 'Train_%d : \n' , i ) ;
    if strcmp( FeatureExtractionMethod , 'XPDR' )
        Accuracy = size(splits, 1);
    else
        Accuracy = size( splits , length_D ) ;
    end
    load( [path_data 'idxData' num2str(i)] ) ; 
    for s = 1 : splits                          % 对不同的分割
        % 分为训练样本和测试样本
        fea_Train = fea( : , idxTrain(s,:) ) ;
        gnd_Train = gnd( idxTrain(s,:) ) ;
        fea_Test = fea( : , idxTest(s,:) ) ;
        gnd_Test = gnd( idxTest(s,:) ) ;
        [fea_Train,gnd_Train,fea_Test,gnd_Test] = Arrange(fea_Train,gnd_Train,fea_Test,gnd_Test) ;        
        
        % Get the Reconstructed Image
        ReducedDim = 50;
        fprintf('Reddim: %d %d th split\n', ReducedDim, s);
        % 0 means use full-rank;
        [fea_Train] = Reconstruction(ReconstructionMethod, fea_Train, ReducedDim);
        
        ResultsMat = [ '.\Features\fea_Train' num2str(i) 'Train_' Data '_' ReconstructionMethod '_ReducedDim=' num2str(ReducedDim) '_s=' num2str(splits) ] ; % '_D=[' num2str(D) ']_s=' '
        disp(ResultsMat);
        save( ResultsMat , 'fea_Train','ReducedDim' ) ;
    end
end