function [Filter, tmp] = same_convmtx2(oper, data)

%thus we are definig this area in a matrix
%you can insert whatever you want here
A = convmtx2(oper,size(data)); %

tmp = zeros(size(oper)+size(data)-1); %size of the result
tmp([round((size(oper,1)-1)/2)+1:size(tmp,1)-round((size(oper,1)-1)/2-0.1)],...
[round((size(oper,2)-1)/2)+1:size(tmp,2)-round((size(oper,2)-1)/2-0.1)])=1;
%need the -0.1 to round it down

%imagesc(tmp);%to see what happens here; that is the area, of the result we are interested in
tmp2=tmp(:);
Filter = A(find(tmp2==1),:);

%reshape(A2*data(:),size(tmp)-size(data)+1) - conv2(oper,data,'same')
%%should be zero everywhere


% if isequal(conv2(oper,data,'same'),reshape(A2*data(:),size(tmp)-size(data)+1))== 1
% disp('good, so you got conv2(oper,data,`same`) via convmtx2')
% else
% disp('---very very baaaad----');
% beep;pause(0.1);beep;pause(0.1);beep;pause(0.1);beep;pause(0.1);beep
% end
% %% your result: conv(oper,data,'same')=
% result=reshape(A2*data(:),size(tmp)-size(data)+1)
%======================================================================================old=====================================================================================
% %thus we are definig this area in a matrix
% %you can insert whatever you want here
% A = convmtx2(oper,size(data)); %
% 
% tmp = zeros(size(oper)+size(data)-1); %size of the result
% tmp([round((size(data,1)-1)/2)+1:size(tmp,1)-round((size(data,1)-1)/2-0.1)],...
% [round((size(data,2)-1)/2)+1:size(tmp,2)-round((size(data,2)-1)/2-0.1)])=1;
% %need the -0.1 to round it down
% 
% %imagesc(tmp);%to see what happens here; that is the area, of the result we are interested in
% tmp2=tmp(:);
% Filter = A(find(tmp2==1),:);
% 
% %reshape(A2*data(:),size(tmp)-size(data)+1) - conv2(oper,data,'same')
% %%should be zero everywhere
% 
% 
% % if isequal(conv2(oper,data,'same'),reshape(A2*data(:),size(tmp)-size(data)+1))== 1
% % disp('good, so you got conv2(oper,data,`same`) via convmtx2')
% % else
% % disp('---very very baaaad----');
% % beep;pause(0.1);beep;pause(0.1);beep;pause(0.1);beep;pause(0.1);beep
% % end
% % %% your result: conv(oper,data,'same')=
% % result=reshape(A2*data(:),size(tmp)-size(data)+1)