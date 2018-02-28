function imOut = compute_LoG(image, LOG_type, varargin)

switch LOG_type
    case 1
        % construct the (5x5) Gaussian kernel with std 0.5
        h = gauss2D(0.5 , 5);
        
        % smooth the image with the Gaussian kernel
        smoothed_im = imfilter(image, h, 'conv');
        
        % compute the second order derivative of the smoothed image
        [Gx, Gy, ~, ~] = compute_gradient(smoothed_im);
        [Gx_2, ~, ~, ~] = compute_gradient(Gx);
        [~, Gy_2, ~, ~] = compute_gradient(Gy);
        imOut = Gx_2 + Gy_2;
    case 2
        % apply the build-in matlab function for LoG
        h = fspecial('log', 5, 0.5);
        imOut = imfilter(image, h, 'conv');
    case 3
        % construct two gaussian kernels with different sigma values
        g_1 = gauss2D(varargin{2}, 5);
        g_2 = gauss2D(varargin{1}, 5);
        
        % subtract the kernels to create the final kernal and smooth the
        % image with it
        h = g_1 - g_2;
        imOut = imfilter(image, h, 'conv');
end
end

