function accuracy = Decision_Coeff( fea_Train , gnd_Train ,fea_Test , gnd_Test , Coeff_Test )


% Coeff_Test = abs(Coeff_Test) ;


%% 使用类内系数和最大作决策
num_Test = size(fea_Test,2) ;
nClass = length( unique(gnd_Train) ) ;
SA = zeros(nClass,num_Test) ;
for i = 1 : num_Test
   for k = 1 : nClass       
       index = find( gnd_Train == k ) ;
       SA(k,i) = sum( Coeff_Test( index ,i ) ) ;
%        SA(k,i) = norm( Coeff_Test( index ,i ) , 2 ) ;

   end
end
% for i = 1 : num_Test
%     SA(:,i) = SA(:,i)/norm(SA(:,i)) ;
% end
[val ind] = max( SA ) ;
accuracy = sum( ind == gnd_Test ) / num_Test ;
save Data_Coeff Coeff_Test SA



% %% 使用系数最大作决策
% num_Test = size(fea_Test,2) ;
% nClass = length( unique(gnd_Train) ) ;
% SA = zeros( nClass , num_Test ) ;
% for i = 1 : num_Test
%    for k = 1 : nClass       
%        index = find( gnd_Train == k ) ;
%        SA(k,i) = max( Coeff_Test( index ,i ) ) ;
%    end
% end
% [val ind] = max( SA ) ;
% accuracy = sum( ind == gnd_Test ) / num_Test ;
% save DebugData Coeff_Test SA

% % % 类内系数和与类间系数和比值最大作决策
% num_Test = size(fea_Test,2) ;
% nClass = length( unique(gnd_Train) ) ;
% SA = zeros(nClass,num_Test) ;
% 
% for i = 1 : num_Test
%    for k = 1 : nClass       
%        index = find( gnd_Train == k ) ;
%        Sw = sum( Coeff_Test( index ,i ) ) ;
%        index = find( gnd_Train ~= k ) ;
%        Sb = sum( Coeff_Test( index ,i ) ) ;
%        
%        SA(k,i) = Sw - Sb ;
%    end
% end
% % for i = 1 : num_Test
% %     SA(:,i) = SA(:,i)/norm(SA(:,i)) ;
% % end
% [val ind] = max( SA ) ;
% accuracy = sum( ind == gnd_Test ) / num_Test ;
% % save Data_Coeff Coeff_Test SA

