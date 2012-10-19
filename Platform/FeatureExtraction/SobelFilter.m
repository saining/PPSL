function [filter_h, filter_v, sobelFea] = SobelFilter(data)
    
    
	[dim n] = size(data);
	imsize  = [32, 32];

	sobelFea = zeros(dim,n);

	for i = 1:n,
		img = reshape(data(:, i), 32, 32);
        imagesc(img);
		% create 1-D spatial sobel filter
		%disp('FILTER WITH 2D TIME DOMAIN sobel FILTER\n');

		g = fspecial('sobel')/8;
        x_mask = g'; % gradient in the X direction
        y_mask = g;
        scale = 4;
        offset = [0 0 0 0];
		%disp('Real part of the filter');
		%imagesc(real(g));
		%colormap(gray);

		% filter signal with given filter and plot magnitude
		%disp('If the image i(x,y) and filter g(x,y) are now convolved conv(g,x)');
		%disp('we can calculate the magnitudes of the filter response.');
		%resp1 = conv2(img, g, 'same');
		[filter_h, tmp1] = same_convmtx2(x_mask, img);
  		[filter_v, tmp2] = same_convmtx2(y_mask, img);
        resp_x = reshape(filter_h*img(:), imsize);
	    resp_y = reshape(filter_v*img(:), imsize);
        resp = resp_x.*resp_x + resp_y.*resp_y;
% 	    imshow(resp2, [min(min(resp2)) max(max(resp2))]);
% 	    pause;
        % 	    if (isequal(real(resp1), real(resp2))== 1)
        % 		 	disp('good, so you got conv2(oper,data,`same`) via convmtx2')
        % 		else 
        % 			disp('shit what happened');
        %         end
        imshow(resp, [min(min(resp)),max(max(resp))]);pause;
		sobelFea(:, i) = (resp(:));
        
		
        %imagesc(abs(resp1).^2);
		%colormap(gray);
		%colorbar;
        %%
        %To do the following operations to get the real edge.
        cutoff = scale*mean2(resp);
        e = resp > cutoff;        
        e = bwmorph(e,'thin');
        imshow(e);
        pause;
        
	end;

end