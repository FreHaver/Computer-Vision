function G = gauss1D( sigma , kernel_size )
    G = zeros(1, kernel_size);
    if mod(kernel_size, 2) == 0
        error('kernel_size must be odd, otherwise the filter will not have a center to convolve on')
    end
    boundary = floor(kernel_size/2);
    listje = -boundary:1:boundary;
    for i=1:kernel_size
        x = listje(i);
        normalize_factor = 1/ (sigma * sqrt(2 * pi));
        G(i) = normalize_factor * exp(-(x^2) / (2 * sigma^2));
    end
    G = G ./ sum(G);
end
