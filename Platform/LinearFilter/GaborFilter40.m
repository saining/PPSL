function GaborFeature = GaborFilter40(Image,knSize)

%对图像提取的Gabor特征,用纯matlab实现。
% Input：
%       Image: 二维矩阵，灰度值
%
% Output:
%       GaborFeature：提取特征后的Gabor特征，为【R×C×40】的数据
%
%Notes:
%       40个Gabor的滤波器的顺序是先方向后尺度.


% * 当前版本：1.0
% * 作    者：牛志恒，苏煜
% * 完成日期：2008年4月11日


imgSize = size(Image);
if length(imgSize)~=2
    err('只能处理灰度图像！');
end
if isa(Image,'double')~=1 
    Image = double(Image);
end
%knSize = [65 65];
gkSize = [ 5 8];
if any(knSize>imgSize)
    error('Gabor kernel is larger than image!');
end
glGaborKernel = {};
GaborFeature = zeros([imgSize gkSize(1)*gkSize(2)]);
if isempty(glGaborKernel) ||  any(size(glGaborKernel{1,1})~= imgSize)
    glGaborKernel = funSetKernel(knSize(1),knSize(2),gkSize(1),gkSize(2),2*pi,2*pi,pi/2,sqrt(2));
    fftw('planner','patient');
    for j = 1:gkSize(1)
        for k = 1:gkSize(2)
            imgKernel = glGaborKernel{j,k};
            imgKernel(imgSize(1),imgSize(2)) = 0;
            imgKernel = circshift(imgKernel,ceil((imgSize-knSize)/2));
            imgKernel = fftshift(imgKernel);
            glGaborKernel{j,k} = fftn(imgKernel);
        end
    end
end
%tic
imgFFT = fftn(Image);
for j = 1:gkSize(1)
    for k = 1:gkSize(2)
        Out = imgFFT.*glGaborKernel{j,k} ;
        Out = ifftn(Out);
        GaborFeature(:,:,(j-1)*gkSize(2)+k) = Out;
    end
end
%t = toc;
%disp(t);

function GaborKernel = funSetKernel(KernelWidth, KernelHeight, scale, nOrientation,  xSigma,  ySigma, Kmax,  Frequency)

GaborKernel = cell(scale,nOrientation);
X = -(KernelWidth -1)/2:(KernelWidth -1)/2;
Y = -(KernelHeight-1)/2:(KernelHeight-1)/2;
[Y,X] = meshgrid(X,Y);
for j = 1:nOrientation
    Phi = (j-1) * pi / nOrientation;
    for k = 1:scale
        Kv  = Kmax / Frequency^(k-1);
        Kuv = Kv^2;
        xySigma = xSigma*ySigma;
        Mag = exp(-Kuv*((X/xSigma).^2 + (Y/ySigma).^2))*Kuv/xySigma;
        Pha = Kv*(cos(Phi)*X + sin(Phi)*Y);
        GaborKernel{k,j} = Mag.*(exp(i*Pha)-exp(-xySigma/2));
    end
end
