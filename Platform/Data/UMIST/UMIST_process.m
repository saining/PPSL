
% 
% % 从原始的UMIST数据转化
% resized_row = 32 ;
% resized_col = 32 ;
% resized_dim = resized_row * resized_col ;
% len = 0 ;
% 
% fea = [] ;
% gnd = [] ;
% for k = 1 : 20 %length( facedat(1,1,:) )
%    [a b lenk]=  size(  facedat{1,k} ) ;
%    for i = 1 : lenk
%        face = facedat{1,k}(:,:,i) ;
%        face_resized = imresize(face,[resized_row resized_col]) ;
%        face_vector = reshape(face_resized,resized_dim,1) ;
%        fea = [ fea face_vector] ;
%    end
%    classk = k * ones(1,lenk) ;
%    gnd = [gnd classk] ;   
% end
% 
% save UMIST fea gnd


%　产生随机分割
nTrain = 12 ; % 每类中选取的用于训练的样本个数
splits = 50 ; % 分割数目
nClass = length( unique( gnd ) ) ;
idxTrain = zeros(splits,nTrain*nClass) ;
idxTest = zeros(splits,575-nTrain*nClass) ;
for s = 1 : splits
    idxTrain_s = [] ;
    idxTest_s = [] ;
    flag = 0 ;
    for k = 1 : nClass
        ind = find( gnd == k ) ;
        lenk = length( ind ) ;
        tem = randperm(lenk);
        b = sort(tem(1:nTrain)) + flag ;
        idxTrain_s = [idxTrain_s b] ;
        b = sort(tem(nTrain+1:end)) + flag ;
        idxTest_s = [idxTest_s b] ;
        
        flag = flag + lenk ;
    end
    idxTrain(s,:) = idxTrain_s ;
    idxTest(s,:) = idxTest_s ;
end

save idxData12 idxTrain idxTest






