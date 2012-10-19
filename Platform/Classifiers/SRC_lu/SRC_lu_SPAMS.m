function [rate predictlabel] = SRC_lu_SPAMS( trnX ,trnY ,tstX , tstY )

% Reference: J. Wright, et al., "Robust Face Recognition via Sparse Representation,"
% IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 31, pp. 210-227, Feb 2009.
% This code is written based on the Eq. (22) of the reference.
% 使用SPAMS工具包的SRC算法，不同点在于其以矩阵形式输入样本，以矩阵形式输出
% 相应的稀疏表示系数

% Input:
% trnX [dim * num ] - each column is a training sample
% trnY [ 1  * num ] - training label 
% tstX
% tstY

% Output:
% rate             - Recognition rate of test sample
% predictlabel     - predict label of test sample

ntrn = size( trnX , 2 ) ;
ntst = size( tstX , 2 ) ;

% normalize
for i = 1 : ntrn
    trnX(:,i) = trnX(:,i) / norm( trnX(:,i) ) ;
end
for i = 1 : ntst
    tstX(:,i) = tstX(:,i) / norm( tstX(:,i) ) ;
end

% classify
param.lambda = 0.001 ; % not more than 20 non-zeros coefficients
%     param.numThreads=2; % number of processors/cores to use; the default choice is -1
% and uses all the cores of the machine
param.mode = 1 ;       % penalized formulation
param.verbose = false ;       % 禁止输出中间结果

A = mexLasso( tstX , trnX , param ) ;

% 基于类内残差最小的决策规则（SRC使用）
[rate predictlabel] = Decision_Residual( trnX ,trnY ,tstX , tstY , A ) ;

% 基于类内系数和最大的决策规则
% rate2 = Decision_Coeff( trnX ,trnY ,tstX , tstY , A ) ;

% fprintf('%f %f\n',rate,rate2) ;
% A = abs( A ) ;
% rate3 = Decision_Residual( trnX ,trnY ,tstX , tstY , A ) 
% rate4 = Decision_Coeff( trnX ,trnY ,tstX , tstY , A ) 
