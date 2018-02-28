    function [ imOut ] = denoise( image, kernel_type, varargin)

    switch kernel_type
        case 'box'
            filterSize = varargin{1};
            imOut = imboxfilt(image, filterSize);
        case 'median'
            size = varargin{1};
            imOut = medfilt2(image, [size, size]);
        case 'gaussian'
            size = varargin{1};
            sigma = varargin{2};
            G = gauss2D(sigma, size);
            imOut = imfilter(image, G);
    end
end
