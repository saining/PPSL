function [ fea_Train , fea_Test , redDim ] = FeatureExtraction( method , fea_Train , gnd_Train , fea_Test )

% method        降维方法，可能的取值有{'PCA','LDA,'Random']，还有更多的有待添加，如LPP
% fea_Train     dim*num_Train 训练样本
% gnd_Train     1*num_Train(或num_Train*1)，与fea_Train对应的样本的标签
% parameter     更多的参数，如用在Random方法中的最高维数



% 降维
switch method
    case 'PCA'
        [ eigvector , eigvalue ] = PCA( fea_Train ) ;
    case 'LDA'
        options.PCARatio = 1 ;
        [ eigvector , eigvalue ] = LDA( gnd_Train , options , fea_Train ) ;
    case 'MMC'
        [ eigvector , eigvalue ] = MMC( fea_Train , gnd_Train ) ;
    case 'LPP'
        [ eigvector , eigvalue ] = LPP_method( fea_Train , gnd_Train ) ;      
    case 'Random'
        dim = size( fea_Train , 1 ) ; 
        eigvector = randn( dim , dim ) ;
        eigvalue = zeros(dim,1) ;
    case 'OP_SRC' %'SRC_DP' %  
        [eigvector eigvalue] = OP_SRC( fea_Train , gnd_Train ) ;
    case 'OP_LRC' 
        [eigvector eigvalue] = OP_LRC( fea_Train , gnd_Train ) ;
    case 'OP_NFS'        
        [eigvector eigvalue] = OP_NFS( fea_Train , gnd_Train ) ;
    case 'LRPP'
        [ eigvector , eigvalue ] = LRPP( fea_Train ) ;
    case 'SLRPP'
        [ eigvector , eigvalue ] = SLRPP( fea_Train , gnd_Train ) ;
    case 'SPP'
        [ eigvector , eigvalue ] = SPP( fea_Train , gnd_Train ) ;
    case 'Identity'
        [ eigvector , eigvalue ] = Identity( fea_Train ) ;  
    case 'MaxSubAngel'
        [ eigvector , eigvalue ] = MaxSubAngel( fea_Train , gnd_Train ) ;
    case 'XPDR'
        reddim = 74;
        [ eigvector , eigvalue ] = XPDR( fea_Train,  reddim) ;
    case 'GaborPCA'
        [ eigvector , eigvalue ] = GaborPCA( fea_Train ) ;
end

fea_Train = eigvector' * fea_Train ;
fea_Test = eigvector' * fea_Test ;
redDim = length(eigvalue) ;
