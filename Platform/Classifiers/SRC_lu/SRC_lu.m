% Reference: J. Wright, et al., "Robust Face Recognition via Sparse Representation,"
% IEEE Transactions on Pattern Analysis and Machine Intelligence, vol. 31, pp. 210-227, Feb 2009.
% This code is written based on the Eq. (22) of the reference.

function rate = SRC_lu( trnX ,trnY ,tstX , tstY )

% Input:
% trnX [dim * num ] - each column is a training sample
% trnY [ 1  * num ] - training label 
% tstX
% tstY

% Output:
% rate             - Recognition rate of test sample
% predictlabel     - predict label of test sample

[dim ntrn] = size( trnX ) ;
ntst = size( tstX , 2) ;
nClass = length( unique(trnY) ) ;

% normalize
for i = 1 : ntrn
    trnX(:,i) = trnX(:,i) / norm( trnX(:,i) ) ;
end
 for i = 1 : ntst
    tstX(:,i) = tstX(:,i) / norm( tstX(:,i) ) ;
 end

% A = [trnX eye(dim)] ; 
A = trnX ; 
predictlabel = zeros(1,ntst) ;

Coeff_Test = zeros(ntrn,ntst) ;
for i = 1 : ntst    % Each loop is to classify each test sample
    y = tstX(:,i) ;    
    
    % l1_magic package 慢
%     tic
    x0 = A\y ;
    Coeff_Test(:,i) = l1eq_pd(x0, A, [], y, 0.05) ; 
    
%     epsilon = 0.05;
%     Coeff_Test(:,i) = l1qc_logbarrier(x0, A, [], y, epsilon, 1e-3);

    
%     toc

    % SPG L1 solver
%     options.iterations = 20;
%     options.verbosity = 0;
% %     tic
%     xp = spgl1( A, y, 0, 1e-3, [], options );     %　最快
%     toc
%     l1_ls_matlab package
%     [xp,status]    =  l1_ls( A , y , 0.1 ) ;  % 一堆输出，耗时
    
    % SPAMS package
%     param.lambda = 0.001; % not more than 20 non-zeros coefficients
% %     param.numThreads=2; % number of processors/cores to use; the default choice is -1
%     % and uses all the cores of the machine
%     param.mode = 1;      % penalized formulation    
%     param.verbose = false ;   %　不显示中间调试信息
% %     tic
%     xp = mexLasso( y , A , param ) ;        %　这个速度很快，只是有一些输出延迟
%     B(:,i) = xp ;
%     toc
%     xp = SolveDALM_fast( A , y ) ;
    
    % SLEP package
%     [xp, funVal1, ValueL1]= glLeastR(G, y, rho, opts);         
   

end

% 基于类内残差最小的决策规则（SRC使用）
rate = Decision_Residual( trnX ,trnY ,tstX , tstY , Coeff_Test ) ;

% 基于类内系数和最大的决策规则
% rate2 = Decision_Coeff( trnX ,trnY ,tstX , tstY , Coeff_Test ) 



 
 
% [nSmp nFea] = size(TrainData);              % nSmp denotes the number of training samples
% [M dim] = size(TestData);                   % M denotes the number of test samples
% classLabel = unique(TrainGnd);
% nClass = length(classLabel) ;               % nClass denotes the number of classes
% Result = zeros(1,M);
% G = TrainData';                             % 每列一个训练样本
% 
% % 暂时不做归一化
% % for i = 1:nSmp
% %     G(:,i) = G(:,i)/norm(G(:,i));
% % end
% % 
% % for i = 1:M
% %     TestData(i,:) = TestData(i,:)/norm(TestData(i,:));
% % end
% 
% 
% 
% %----------------------- Set optional items -----------------------
% % Starting point
% opts.init=2;        % starting from a zero point
% % Termination
% opts.tFlag=5;       % run .maxIter iterations
% opts.maxIter = 100 ;   % maximum number of iterations
% % Normalization
% opts.nFlag=0;       % without normalization 不对A作归一化操作
% % Regularization
% opts.rFlag=0;       % the input parameter 'rho' is a ratio in (0, 1)
% % Group Property
% % opts.ind = indGroup_ini ;       % set the .0 indices
% opts.q = 1 ;           % set the value for q
% % opts.sWeight=[1,1]; % set the weight for positive and negative samples
% opts.gWeight=ones(nClass,1);
% % set the weight for the group, a cloumn vector
% 
% % fprintf('\n mFlag=0, lFlag=0 \n');
% opts.mFlag=0;       % treating it as compositive function
% opts.lFlag=0;       % Nemirovski's line search
% 
% % 根据类别分组
% indGroup_ini(1) = 0 ;
% for i = 1 : nClass
%    temin = find( TrainGnd == i ) ;
%    indGroup_ini(i+1) = indGroup_ini(i) + length(temin) ;
% end
% opts.ind = indGroup_ini ;
% 
% % rho=10^(-3) ;       % SLEP 工具包需要
% rho= 0.005 ;
% for i = 1:M %Each loop is to classify each test sample.
%     i;
%     y = TestData(i,:)';    
%     x0 = G\y;
%     
% %     l1_magic 工具包
%     tic
%     xp = l1eq_pd(x0, G, [], y, 1e-3);                       
%     toc
%     sum(abs(xp))
%     % SPG L1 solver
% %     options.iterations = 20;
% %     options.verbosity = 0;
% %     tic
% %     xp = spgl1( G, y, 0, 1e-3, [], options ); 
% %     toc
%     % SLEP 工具包
% %     [xp, funVal1, ValueL1]= glLeastR(G, y, rho, opts);         
%    
%     % Compute the residuals for each class
%     R = zeros(nClass,1);
%     %
%     for ii = 1:nClass
%         delta = find(TrainGnd ~= ii);
%         xdelta = xp;
%         xdelta(delta) = 0;
%         R(ii) = norm(y - G*xdelta);   
%     end
%     
%     [Rmin index] = min(R);    % find the minimum residual
%     Result(i) = index;        % 
% end
% 
% 
% % [nSmp nFea] = size(TrainData)              % nSmp denotes the number of training samples
% % [M dim] = size(TestData)                   % M denotes the number of test samples
% % classLabel = unique(TrainGnd);
% % nClass = length(classLabel)                % nClass denotes the number of classes
% 
% rate = length(find(Result==TestGnd'))/M ;  % Recognition rate



