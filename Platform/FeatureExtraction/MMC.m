function [eigvector eigvalue] = MMC( X , Y )

% 卢参义将胡戎翔的代码重新组织了一下，主要是接口上的修改 2012/07/13


beta = 1 ;

% X(d*n) , Y(1*n) 均为每列一个样本　

% 先用PCA降维
eigvector_PCA = PCA( X ) ;
X = eigvector_PCA' * X ;

classLabel = unique( Y );
% 获得类别总数
nClass = length(classLabel);

% 以下计算是以每行一个样本来计算的，而输入是以每列一个样本来计算的
X = X' ;
Y = Y' ;
% 样本均值
sampleMean = mean(X);
% nSmp 对应样本数
% nFea 对应样本维数，非常高啊
[nSmp,nFea] = size(X);


% disp('Computing SB and SW ...');
% 这里的计算速度实际上非常慢
% 计算SW和SB
MMM = zeros(nFea, nFea);
% 
for i = 1:nClass,
    %
	index = find( Y == classLabel(i) ) ;
    % 每一类的类心
	classMean = mean(X(index, :));
    % 主要的计算量都在这里
	MMM = MMM + length(index)*classMean'*classMean;
end
% X是整个样本矩阵
W = X'*X - MMM;
% 
B = MMM - nSmp*sampleMean'*sampleMean;

W = max(W, W');
B = max(B, B');
% 这里的beta是文章中的缩放因子，则前面所计算的就是最基本的SW和SB
S = B - beta*W;

dimMatrix = size(S,2);

[eigvector, eigvalue] = eig(S);


% 取出对角线上的元素
eigvalue = diag(eigvalue);
% 特征值排序
% When X is complex, the elements are sorted by ABS(X)
[junk, index] = sort(eigvalue,'descend');
% 特征向量矩阵重新排列，每一列对应一个特征向量，所以是在第二维上进行重排
eigvector = eigvector(:,index); 

for tmp = 1:size(eigvector,2)
    eigvector(:,tmp) = eigvector(:,tmp)./norm(eigvector(:,tmp));
end

% % 降维矩阵应包含PCA部分
eigvector = eigvector_PCA * eigvector ;

