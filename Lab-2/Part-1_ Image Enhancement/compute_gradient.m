function [Gx, Gy, im_magnitude,im_direction] = compute_gradient(image)
	Gx_filter = [1 0 -1 ; 2 0 -2 ; 1 0 -1]; 
    Gy_filter = [1 2 1 ; 0 0 0 ; -1 -2 -1];
    Gx = imfilter(image, Gx_filter);
    Gy = imfilter(image, Gy_filter);
    Gx_squared = Gx.^2;
    Gy_squared = Gy.^2;
    im_magnitude = sqrt(Gx_squared + Gy_squared);
    im_direction = atan(Gy ./ Gx);
end

