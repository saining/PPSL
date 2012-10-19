
% plot Yale result

clear
close all

methods = { 'kNN' 'NFS' 'SRC_lu_SPAMS' 'WSRC_SPAMS' } ;
% featureextractionmethod = 'PCA' ;
mark = {'k-o','g-+','b-v','r-s'} ;
% resultpath = 'E:\Work\LRRC\Results\YaleB\' ;    % YaleB
% resultpath = 'E:\Work\LRRC\Results\YaleB\Usedinpaper\' ;    % YaleB
% resultpath = 'E:\Work\LRRC\Results\AR\' ;       % AR
resultpath = 'E:\Work\LRRC\Results\AR\Usedinpaper\' ;       % AR

figure ; hold on
grid
for t = 1 : length(methods)

%     filename = [ '30Train_' methods{t} '_PCA_D=[30   56  120  504]_s=1' ] ; % YaleB
%     filename = [ '30Train_' methods{t} '_Random_D=[30   56  120  504]_s=1' ] ; % YaleB
%     filename = [ '30Train_' methods{t} '_LDA_D=[5  10  15  20  25  30  35]_s=1' ] ; % YaleB
% ----------------------------------------------------------------------------------------
%     filename = [ '7Train_' methods{t} '_PCA_D=[30   54  130  540]_s=1' ] ;      % AR 
%     filename = [ '7Train_' methods{t} '_Random_D=[30   54  130  540]_s=1' ] ;      % AR
    filename = [ '7Train_' methods{t} '_LDA_D=[10  20  30  40  50  60  70  80  90]_s=1' ] ;      % AR
    

%     [resultpath filename]
    load( [resultpath filename] ) ;
    plot(D,ave_Acc,mark{t},'LineWidth',2,'MarkerSize',5) ;
%     disp(methods{t})
    fprintf('%s\t',methods{t}) ;
%     disp(ave_Acc*100)
    for i = 1 : length(ave_Acc)
       fprintf('%.2f\t',ave_Acc(i)*100); 
    end
    fprintf('\n');
end
disp(D)
legend('NN' , 'NFS' , 'SRC' , 'WSRC') ;
xlabel('Feature Dimenstion') ;
ylabel('Recognition Rate(%)') ;
% title('PCA');
% title('Random');
title('LDA');


% filepath = 'C:\Users\Administrator\Desktop\LYK\LYK\result\Yale_SRC_caideng\' ;
% filepath = 'C:\Users\Administrator\Desktop\LYK\LYK\result\Yale_SRC_caideng\' ;
% % resultpath = 'C:\Users\Administrator\Desktop\LYK\LYK\result\';
% 
% % same = 6 ;
% startnum = 30 ; % YaleB
% % startnum = 7 ; % AR
% endnum = startnum ;
% % endnum = 6 ;
% 
% 
% Num_train = [ startnum : endnum ] ;
% for i = Num_train
%     figure
%     for m = 1 : length(method)
%         filename = [ 'Model_caideng_YALE32_' method{m} '_SRC_' num2str(i) 'Train' ] ;
%         
%         load([filepath filename]) ;
%         if strcmp('PCA',method{m})
%             aveRecog_pca = aveRecog ;
%         elseif strcmp('SRC-MMC',method{m})
%             aveRecog_srcmmc = aveRecog ;
%         end
%         
%         hold on
%         if strcmp('SRC-MMC',method{m})
%             aveRecog_pca = aveRecog ;
%             plot( aveRecog(1:end-1) , color{m} ) ;
%         else
%             plot( aveRecog , color{m} ) ;
%         end       
%         
%     end
%     if aveRecog_pca(end) == aveRecog_srcmmc(end)
%         fprintf('i=%d\n',i);
%     end
%         
%     legend( 'PCA', 'LDA', 'SPP', 'SRC-DP', 'SRC-MMC') ;
%     
% end

       

%     figure
%     plot( aveRecog )
    
%     [maxRecog, maxDim] = max(aveRecog) ;
%     fprintf('%.3f¡À%.3f(%d)\n', maxRecog , stdDeviation , maxDim ) ;
    
%     savefilename = [resultpath filename ] ;
%     save(savefilename , 'aveRecog','rate', 'maxRecog', 'maxDim', 'stdDeviation'); 

fprintf('\n');