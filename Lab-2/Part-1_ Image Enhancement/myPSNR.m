function [ PSNR ] = myPSNR( orig_image, approx_image )
        
    % convert images to doubles if not already double
    if ~isa(orig_image, 'double') || ~isa(approx_image, 'double')
        orig_image = im2double(orig_image);
        approx_image = im2double(approx_image);
    end
    
    % get size of image
    [m, n, ~] = size(orig_image);
    
    % calculate RMSE
    MSE = (1/(m * n)) * sum(sum((orig_image - approx_image).^2));
    RMSE = sqrt(MSE);
    
    % get maximum pixel value of original image
    I_max = max(max(orig_image));
    
    % caluclate PSNR
    PSNR = 20 * log10((I_max / RMSE));

end

