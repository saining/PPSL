%% Construct linear filter operator matrix
function [filterMatrix, filteredFea] = ConstructFilterMatrix_separate(filterType, data, Garborsetno)
	switch filterType
		case '2D-GaborFilter'
		    gopt.f = 1;
		    gopt.theta = 0;
		    gopt.gamma = 1;
		    gopt.eta = 1;
		    gopt.size = [15 15];

		    [filterMatrix, filteredFea] = GaborFilter(data, gopt);
        case 'Gabor40'
            w = round(sqrt((length(data(:,1)))));
            h = w;
            imgSize = [h, w];
            
            knSize = [h/2 - 1, w/2 - 1];
            gkSize = [5  8];
            
            if any(knSize>imgSize)
                error('Gabor kernel is larger than image!');
            end
            glGaborKernel = {};
            if isempty(glGaborKernel) ||  any(size(glGaborKernel{1,1})~= imgSize)
                glGaborKernel = funSetKernel(knSize(1),knSize(2),gkSize(1),gkSize(2),2*pi,2*pi,pi/2,sqrt(2));
            end
            
            k = mod(Garborsetno, gkSize(2));
            if k ==0, 
                k = 8; 
                j = (Garborsetno/gkSize(2));
            else
                j = floor(Garborsetno/gkSize(2)) + 1;
            end;
            filterMatrix = same_convmtx2(glGaborKernel{j,k}, imgSize);
            
            fprintf('filterMatrix Size: %d-by-%d', size(filterMatrix,1), size(filterMatrix,2));
            filteredFea = []; %TO-DO
    end

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