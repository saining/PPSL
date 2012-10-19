
% OP-SRC
% plot UMIST result 

clear
close all

root = 'E:\Work\LRRC\Results\UMIST\' ;
Num_train = 12 ; % 8 10 12
method = { 'PCA' 'LDA' 'SPP' 'SRC_DP' 'OP_SRC' } ;
legendMethod = { 'PCA' 'LDA' 'SPP' 'SRC-DP' 'OP-SRC'} ;
color  = {'r' 'g' 'b' 'c' 'm'} ;
figure ; hold on

xlabel('Dims') ;
ylabel('Accuracy') ;

UsedMethod = [1:5] ;
for m = UsedMethod
    filename = [ num2str(Num_train) 'Train_SRC_lu_SPAMS_' method{m} '_D=[5-5-119]_s=10' ] ;
    load([root filename]) ;
    plot( D , ave_Acc , color{m} ) ;
end       
legend( legendMethod(UsedMethod),4 ) ;


    
