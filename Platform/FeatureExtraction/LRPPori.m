function [eigvector eigvalue] = LRPP( X )

% LRPP - Low-Rank Preserving Projections
% 将低秩表示保持到低维空间
% 与SPP的区别是用低秩表示代替稀疏表示

% min |X|_*+lambda*|E|_2,1
% s.t., X = XZ+E
% reg -- the norm chosen for characterizing E, 
% reg = 0 ;   % reg=0 (default),                  use the l21-norm %% 用这个结果差得多
% reg = 1 ;   % reg=1 (or ther values except 0),  use the l1-norm
% lambda = 0.5 ;
% Z = solve_lrr( X , X , lambda , reg ) ;

% Z = analytical_lrr( X , X ) ; % 这个是解析解，比第一式快200倍左右


% 先用PCA降维
P = PCA( X ) ;
X = P' * X ;
                


% Z = analytical_LRR( X ) ;               % 最快，min_Z |Z|_*  s.t. X = X * Z
% Z = analytical_LRR1( X , X ) ;          % 较快，min_Z |Z|_*  s.t. X = A * Z
tau = 300 ;
Z = analytical_LRR2( X , tau ) ;        % 较慢，min_Z |Z|_* + (tau/2)*(|X-X*Z|_F)^2




ZL = X * (Z + Z' - Z' * Z) * X' ;
ZR = X * X' ;

ZL = max(ZL,ZL') ;
ZR = max(ZR,ZR') ;

% [eigvector,eigvalue] = eig(ZL,ZR) ;
% [junk, index] = sort(-eigvalue);


ZL2 = X * X' -  X * ( Z + Z' - Z' * Z) * X' ;
ZL2 = max(ZL2,ZL2') ; % 这个对称化作用非常明显
[eigvector,eigvalue] = eig( ZL2 ) ;
[junk, index] = sort(eigvalue);



eigvalue = diag(eigvalue);
eigvalue = eigvalue(index);
% eigvalue
eigvector = eigvector(:,index);

%
% for tmp = 1:size(eigvector,2)
%     eigvector(:,tmp) = eigvector(:,tmp)./norm(eigvector(:,tmp));
% end


eigvector = P * eigvector ;


save LRPPdata


