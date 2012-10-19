function [] = Showimage(data, imsize, layout)
imgno = size(data,2);
x = layout(1);
y = layout(2);
ha = tight_subplot(x,y,[.01 .01], [.01,.01], [.01, .01]);

for i = 1:imgno,
    data(:,i) = data(:,i)/max(data(:,i));
    axes(ha(i));
    imshow(abs(reshape(data(:,i),imsize)));
end
% figure;
% for i = 1:imgno,
%     data(:,i) = data(:,i)/max(data(:,i));
%     axes(ha(i));
%     imshow(imag(reshape(data(:,i),imsize)));
% end