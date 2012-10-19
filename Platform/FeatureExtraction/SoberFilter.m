function [filterMatrix, sobelFea] = sobelFilter( data, options )

	[dim n] = size(data);
	imsize  = [32, 32];

	sobelFea = zeros(dim,n);

	for i = 1:n,
		img = reshape(data(:, i), 32, 32);
        imagesc(img);
		% create 1-D spatial sobel filter
		%disp('FILTER WITH 2D TIME DOMAIN sobel FILTER\n');

		g = fspecial('sobel');
		%disp('Real part of the filter');
		%imagesc(real(g));
		%colormap(gray);

		% filter signal with given filter and plot magnitude
		%disp('If the image i(x,y) and filter g(x,y) are now convolved conv(g,x)');
		%disp('we can calculate the magnitudes of the filter response.');
		resp1 = conv2(img, g, 'same');
		[filterMatrix, tmp] = same_convmtx2(g, img);
	    
	    resp2 =  reshape(filterMatrix*img(:), 32, 32);
	    imshow(resp2);
	    pause;
        % 	    if (isequal(real(resp1), real(resp2))== 1)
        % 		 	disp('good, so you got conv2(oper,data,`same`) via convmtx2')
        % 		else 
        % 			disp('shit what happened');
        %         end

		sobelFea(:, i) = (filterMatrix * img(:));
		%imagesc(abs(resp1).^2);
		%colormap(gray);
		%colorbar;
	end;

end