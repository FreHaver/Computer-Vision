    function [ imOut ] = denoise( image, kernel_type, varargin)

    switch kernel_type
        case 'box'
            % if kernel type is 'box', use the build-in function of matlab
            % to filter the image with a box filter.
            filterSize = varargin{1};
            imOut = imboxfilt(image, filterSize);
        case 'median'
            % if the kernel type is 'median', use the build-in function of
            % matlab to filter the image with a median filter
            size = varargin{1};
            imOut = medfilt2(image, [size, size]);
        case 'gaussian'
            % for the gaussian kernel type, use the implemented gauss2D
            % function to create a filter and use this to filter.
            size = varargin{1};
            sigma = varargin{2};
            G = gauss2D(sigma, size);
            imOut = imfilter(image, G);
    end
end
