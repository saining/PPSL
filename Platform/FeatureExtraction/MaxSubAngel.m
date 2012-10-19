function [eigvector eigvalue] = MaxSubAngel( fea_Train , gnd_Train )

% fea_Train(dim*num_Train) , gnd_Train(1*num_Train) 均为每列一个样本　

[ eigvector_PCA , eigvalue ] = PCA( fea_Train ) ;
fea_Train = eigvector_PCA' * fea_Train ;



[dim,num_Train] = size(fea_Train) ;
nClass = length( unique(gnd_Train) ) ;

meanX = (mean(fea_Train'))' ;

Sb = zeros(dim,dim) ;
for k = 1 : nClass
    ind = gnd_Train ~= k ;
    Xi = fea_Train(:,ind) ;
    meanXi = (mean(Xi'))' - meanX ;
    Sb = Sb + meanXi * meanXi' ;    
end

[eigvector eigvalue] = eig( Sb ) ;
eigvalue = diag(eigvalue) ;
%     [eigr eigc] = size(eigvalue) ;
[~, index] = sort(-eigvalue) ;
%     size(eigvector)
%     indexBig = index(1:reducedDim) ;
eigvalue = eigvalue(index) ;
eigvector = eigvector(:,index) ;

for tmp = 1:size(eigvector,2)
    eigvector(:,tmp) = eigvector(:,tmp)./norm(eigvector(:,tmp));
end

eigvector = eigvector_PCA * eigvector ;









% 
% 
% 
% Rw = zeros(dim,dim) ;
% Rb = zeros(dim,dim) ;
% 
% Coeff_Train = Coding( fea_Train , gnd_Train ) ;
% 
% for i = 1 : num_Train
%     x = fea_Train(:,i) ;                                % X的第i个样本
% %     residual = zeros(nClass,1) ;
%     for k = 1 : nClass
%         ind = find( gnd_Train ~= k ) ;
%         coeff_x = Coeff_Train(:,i) ;                    % X的第i个样本对应的编码系数
%         coeff_x(ind) = 0 ;
%         R(:,k) = x - fea_Train * coeff_x ;      % 样本x对就第k类残差
% %         residual(k) = norm( R(:,k) ) ;
%     end
%     Ri = R(:,gnd_Train(i)) * R(:,gnd_Train(i))' ;
%     Rw = Rw + Ri ;
%     Rb = Rb + R * R' - Ri ;
% %     [minres,kth] = min(residual) ;
% %     %         residual
% %     if(kth==gnd_Train(i))
% %         corr = corr+1 ;
% %     end
% end
% % corRate = corr / num_Train ;
% 
% Rw = Rw / num_Train ;
% Rb = Rb / ( num_Train*(nClass-1) ) ;
% 
% save Data_OPNFS Rw Rb
% 
% beta = 0.25 ;
% tic
% [eigvector eigvalue] = eig( beta * Rb - Rw ) ;    % our method
% %     [eigvector eigvalue] = eig( Rb , Rw ) ;      % SRC-DP 这个求解速度比上面式子慢十倍
% toc
% 
% 
% eigvalue = diag(eigvalue) ;
% %     [eigr eigc] = size(eigvalue) ;
% [junk, index] = sort(-eigvalue) ;
% %     size(eigvector)
% %     indexBig = index(1:reducedDim) ;
% eigvalue = eigvalue(index) ;
% eigvector = eigvector(:,index) ;
% 
% for tmp = 1:size(eigvector,2)
%     eigvector(:,tmp) = eigvector(:,tmp)./norm(eigvector(:,tmp));
% end
% 
