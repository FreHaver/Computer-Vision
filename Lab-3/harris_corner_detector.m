function [H, row_list, column_list] = harris_corner_detector(rgb_image, treshold, neighborhood, sigma_smooth, show_figures)
    % convert the image to grayscale and double to be able to do computations
    gray_image = im2double(rgb2gray(rgb_image));
        
    % set neighborhood to n for notation
    n = neighborhood;
    
    % construct a Gaussian filter to compute the x and y gradients
    G = gauss2D(0.3, 3);
    
    % get the x and y gradient of the Gaussian filter
    [Gx, Gy] = gradient(G);
    
    % filter the image with the first order derivatives of the Gaussian
    % filter
    Ix = imfilter(gray_image, Gx, 'conv');
    Iy = imfilter(gray_image, Gy, 'conv');

    % square or multiply the derivatives
    Ix_squared = Ix.^2;
    Iy_squared = Iy.^2;
    Ixy = Ix.*Iy;
    
    % create Gaussian to smooth the image (window bigger than the
    % neighborhood window of H)
    G = gauss2D(sigma_smooth, (n*2) + 3);
    
    % calculate the A, B and C matrix
    A = imfilter(Ix_squared, G);
    B = imfilter(Ixy, G);
    C = imfilter(Iy_squared, G);
    
    % get size of A to create H and loop over all the rows and columns.
    [h, w] = size(A);
    
    % create H of ones, so H is padded with ones, this is to make sure the
    % edges are not detected as corners (they would be quicker detected as
    % corners if H would be zero padded, as all the other values in H are
    % smaller than 0.02
    H = ones(h+2*n, w+2*n);
    row_list = [];
    column_list = [];
    
    % construct the H matrix
    for col = 1:w
        for row = 1:h
            A_xy = A(row, col);
            B_xy = B(row, col);
            C_xy = C(row, col);
            H(row+n, col+n) = (A_xy*C_xy - B_xy^2) - 0.04*(A_xy+C_xy)^2;
        end
    end
    
    % get the new size of H
    [h_n, w_n] = size(H);
    
    % create a matrix of zeros with the size of the neighborhood to be
    % inspected in H
    zero_matrix = zeros((n*2)+1,(n*2)+1);
    
    % check if the pixel value is an edge. 
    for col = (1+n):(w_n-n)
        for row = (1+n):(h_n-n)
            pixel_value = H(row, col);
            zero_matrix(n+1,n+1) = H(row, col);
            neighbor_matrix = H(row-n:row+n, col-n:col+n) - zero_matrix;
            neighborhood_max = max(max(neighbor_matrix));
            if (pixel_value > neighborhood_max) && (pixel_value > treshold)
                row_list = [row_list, (row-n)];
                column_list = [column_list, (col-n)];
            end
        end
    end 
    
    % create dots on every corner pixel
    for i=1:length(row_list)
        rgb_image(row_list(i), column_list(i), :) = [1, 0, 0];
    end
    
    % if show_figures is set to true, show the iamges of the x-gradient,
    % y-gradient and the detected corners in the rgb image
    if show_figures
        figure;
        imshow(Ix);
        title('x-gradient');
        figure;
        imshow(Iy);
        title('y-gradient');
        figure;    
        imshow(rgb_image);
        hold on
        % draw a circle wit radius 2 around every corner pixel
        t=0:0.1:2*pi;
        radius = 2;
        for i=1:length(row_list)
            y = row_list(i) + radius*sin(t);
            x = column_list(i) + radius*cos(t);
            plot(x,y,'g');
        end
        title('corner detection');
    end
end
    