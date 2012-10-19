function [fea_Train2,gnd_Train2,fea_Test2,gnd_Test2] = Arrange(fea_Train,gnd_Train,fea_Test,gnd_Test)

% 本函数作用是把训练样本和测试样本按照类别顺序排列

[dim,num_Train] = size(fea_Train) ;
num_Test = size(fea_Test,2) ;

% normalize 这个操作是必要的，否则会降低识别率
% for i = 1 : num_Train
%     fea_Train(:,i) = fea_Train(:,i) / norm( fea_Train(:,i) ) ;
% end
% for i = 1 : num_Test
%     fea_Test(:,i) = fea_Test(:,i) / norm( fea_Test(:,i) ) ;
% end

fea_Train2 = zeros(dim,num_Train) ;
fea_Test2 = zeros(dim,num_Test) ;
gnd_Train2 = zeros(1,num_Train) ;
gnd_Test2 = zeros(1,num_Test) ;
nClass = length( unique(gnd_Train) ) ;
flag1 = 0 ;
flag2 = 0 ;
for k = 1 : nClass
   ind = find( gnd_Train == k ) ;
   len = length( ind ) ;
   fea_Train2(:,flag1+1:flag1+len) = fea_Train(:,ind) ;
   gnd_Train2(flag1+1:flag1+len) = gnd_Train(:,ind) ;
   flag1 = flag1+len ;
   
   ind = find( gnd_Test == k ) ;
   len = length( ind ) ;
   fea_Test2(:,flag2+1:flag2+len) = fea_Test(:,ind) ;
   gnd_Test2(flag2+1:flag2+len) = gnd_Test(:,ind) ;
   flag2 = flag2+len ;    
end