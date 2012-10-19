function [rate Result] = kNN( Proto_centroids , Proto_classes , Data , Data_classes , k )

%
% kNN classifier
%

%Data=xt;
%Proto_classes=group;
%Data_classes=groupt;
%k=10;

%% 卢参义将输入修改为每列一个样本作为输入（原来是每行一个样本）,增加以下四行
Proto_centroids = Proto_centroids' ;
Proto_classes = Proto_classes' ;
Data = Data' ;
Data_classes = Data_classes';
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if nargin < 5
    k = 1 ;
end

[n dim]    = size(Data);
ncentroids = size(Proto_centroids, 1); % no of centroids

M        = mean(Proto_centroids); % mean & std of the prototypes
S        = std(Proto_centroids);

Proto_centroids = (Proto_centroids - ones(ncentroids, 1) * M)./(ones(ncentroids, 1) * S); % normalize prototypes
Data            = (Data-ones(n,1)*M)./(ones(n,1)*S); % normalize data

U        = unique(Proto_classes); % class labels
nclasses = length(U);

Result  = zeros(n, 1);
Count   = zeros(nclasses, 1);

for i = 1:n
  % compute distances between data vector and all prototypes and
  % sort them
  Dist         = sum((Proto_centroids - ones(ncentroids, 1) * Data(i, :)).^2, 2);
  [Dummy Inds] = sort(Dist);

  % compute the class labels of the k nearest prototypes
  Count(:) = 0;
  for j = 1:k
    ind        = find(Proto_classes(Inds(j)) == U);
    Count(ind) = Count(ind) + 1;
  end

  % determine the class of the data sample
  [dummy ind] = max(Count);
  Result(i)   = U(ind);
end
correctnumbers=length(find(Result==Data_classes));
rate=correctnumbers/n;

% 卢参义增加了预测标签的输出，每列一个样本，因此增加以下代码
Result = Result' ;
