 function G = gauss1D( sigma , kernel_size )
    % create an empty matrix to store the Gaussian kernel is
    G = zeros(1, kernel_size);
    
    % make sure the kernel size is an odd number, otherwise throw an error
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    
    % create indexes according to the kernel size.
    boundary = floor(kernel_size/2);
    x_values = -boundary:1:boundary;
    
    % calculate the gaussian value at every index
    for i=1:kernel_size
        x = x_values(i);
        normalize_factor = 1/ (sigma * sqrt(2 * pi));
        G(i) = normalize_factor * exp(-(x^2) / (2 * sigma^2));
    end
    % normalize the gaussian
    G = G ./ sum(G);
end
