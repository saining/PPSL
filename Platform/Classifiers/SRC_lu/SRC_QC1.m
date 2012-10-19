% Reference1: J. Wright, et al., "Robust Face Recognition via Sparse Representation,"
% IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 31, pp. 210-227, Feb 2009.
% Reference 2: L. S. Qiao, et al., "Sparsity preserving projections with
% applications to face recognition," Pattern Recognition, vol. 43, pp.
% 331-341, Jan 2010.
% 依据Reference1 P 214的Algorithm1的不等式约束,
function rate = SRC_QC1( TrainData,TrainGnd,TestData,TestGnd )
% SRC Sparse Representation Classifier 
% with quadratic constraints
% using l1qc_logbarrier
%
% Input:
% TrainData
% TrainGnd
% TestData
% TestGnd
%
% Output:
% rate

TrainData = TrainData' ;
TestData = TestData' ;
% N为训练样本数
[N dim] = size(TrainData);
% M为测试样本数
[M dim] = size(TestData);
%
classLabel = unique(TrainGnd);
% 获得类别总数
nClass = length(classLabel);
% 识别结果
Result = zeros(1,M);

% 训练样本作为字典
G = TrainData'; 
% l2范数归一化
for i = 1:N
    G(:,i) = G(:,i)/norm(G(:,i));
end
%

% 测试样本处理
% l2范数归一化
for i = 1:M
    TestData(i,:) = TestData(i,:)/norm(TestData(i,:));
end

G=[G;ones(1,N)];

Coeff_Test = zeros(N,M) ;
% 循环对每一个测试样本进行类别判断
for i = 1:M
    %
    i;
    % 取出该次样本，转置成列向量
    y = TestData(i,:)';
%     y = [y; 1];
    %
    epsilon = 0.05;
    %
%     x0 = G'*y;
    x0 = G'\y ;
    % 计算l1范数最小化问题
    xp = l1qc_logbarrier(x0, G, [], y, epsilon, 1e-3);
    Coeff_Test(:,i) = xp ;
    %  
    % 计算残差
    % 按类别计算残差
    R = zeros(nClass,1);
    %
    for ii = 1:nClass
        %
        delta = find(TrainGnd ~= ii);
        %
        xdelta = xp;
        %
        xdelta(delta) = 0;
        %
        R(ii) = norm(y - G*xdelta);      
    end
    
    % 确定最小残差
    [Rmin index] = min(R); 
    % 修改结果
    Result(i) = index;    
end

rate = length(find(Result==TestGnd))/M;% Recognition rate


save Data_SRCQ1 Coeff_Test

