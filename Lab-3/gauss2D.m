function G = gauss2D( sigma , kernel_size )

    % combine two 1D Gaussian kernels to create a 2D Gaussian kernel
    G = gauss1D(sigma, kernel_size).' * gauss1D(sigma, kernel_size);
      
end
