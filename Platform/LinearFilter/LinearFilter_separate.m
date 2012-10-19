function [filteredFea] = LinearFilter_separate(filterType, data, Garborsetno)
	switch filterType
		case '2D-GaborFilter'
		gopt.f = 1;
        gopt.theta = 0;
        gopt.gamma = 1;
        gopt.eta = 1;
        gopt.size = [15 15];
		[~, filteredFea] = GaborFilter(data, gopt);
        case 'SobelFilter'
            [~, ~, filteredFea] = SobelFilter(data);
        case 'Gabor40'
            downsamplingrate = 1;
            imgsize = [round(sqrt(size(data,1))) round(sqrt(size(data,1)))];
            filteredFea = [];
            temp = [];
            for i = 1:size(data,2),
                [tempFea] = GaborFilter40(reshape(data(:,i),imgsize), [15,15]);
                tempFea = abs(tempFea);
                for j = 1:6,
                %tempFea(:,:,j) = tempFea(:,:,j)./max(max(tempFea(:,:,j)));
                %temp(:,:,j) = imresize(tempFea(:,:,j), downsamplingrate,'nearest');
                temp(:,:,j) = tempFea(:,:,j);
                end
                filteredFea = [filteredFea, temp(:)];
            end
         case 'Gabor40_real'
            filterType = 'Gabor40'; %arguments in fucntion ConstructFilterMatrix
            [filterMatrix, ~] = ConstructFilterMatrix_separate(filterType, data, Garborsetno);
            filterMatrix = abs(filterMatrix);
            filteredFea = [];
            temp = [];
            for i = 1:size(data,2),
                [tempFea] = filterMatrix*data(:,i);
                tempFea = (tempFea);
                filteredFea = [filteredFea, tempFea];
            end
     end