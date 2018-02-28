function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
    % convert the given image to double
    image = im2double(image);
    
    % create the matrixes for the x and y gradient
	Gx_filter = [1 0 -1 ; 2 0 -2 ; 1 0 -1]; 
    Gy_filter = [1 2 1 ; 0 0 0 ; -1 -2 -1];
    
    % apply the x- and y-filters on the image
    Gx = imfilter(image, Gx_filter);
    Gy = imfilter(image, Gy_filter);
    
    % compute the square of the gradient images
    Gx_squared = Gx.^2;
    Gy_squared = Gy.^2;
    
    % calculate the magnitude and direction of the gradient
    im_magnitude = sqrt(Gx_squared + Gy_squared);
    im_direction = atan(Gy ./ Gx);
end

