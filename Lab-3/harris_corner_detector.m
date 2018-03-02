function [H, row_list, column_list] = harris_corner_detector(image, treshold, difference)
    % convert the image to double to be able to do computations
    image = im2double(image);
    
    % construct a Gaussian filter 
    G = gauss2D(0.2, 3);
    
    % get the x and y gradient of the Gaussian filter
    [Gx, Gy] = gradient(G);
    
    % filter the image with the first order derivatives of the Gaussian
    % filter
    Ix = imfilter(image, Gx, 'conv');
    Iy = imfilter(image, Gy, 'conv');
    
    % 
    Ix_squared = Ix.^2;
    Iy_squared = Iy.^2;
    Ixy = Ix.*Iy;
    
    %
    A = imfilter(Ix_squared, G);
    B = imfilter(Ixy, G);
    C = imfilter(Iy_squared, G);
    
    [h, w] = size(A);
    H = zeros(size(A));
    Q = zeros(2,2);
    row_list = [];
    column_list = [];
    
    for col = 1:w
        for row = 1:h
            A_xy = A(row, col);
            B_xy = B(row, col);
            C_xy = C(row, col);
            H(row,col) = (A_xy*C_xy - B_xy^2) - 0.04*(A_xy+C_xy)^2;
            Q = [A_xy, B_xy; B_xy, C_xy];
            lambdas = eig(Q);
            lambda_1 = lambdas(1);
            lambda_2 = lambdas(2);
            if abs(lambda_1 - lambda_2) < difference && lambda_1 > treshold && lambda_2 > treshold
                row_list = [row_list, row];
                column_list = [column_list, col];
            end
        end
    end
    
    
%     H_1 = A.*C - B.^2;
%     H_2 = (A + C).^2;
%     H_matrix = H_1 - 0.04 * H_2;
%     [h, w, s] = size(H_matrix);
%     Q = [A(1,1,1), B(1,1,1); B(1,1,1), C(1,1,1)];
%     size(Q)
%     lambda = eig(Q)
%     zero_matrix = zeros((n*2)+1,(n*2)+1, 3); 
% 
%     
%     for col = 1+n:w-n
%         for row = 1+n:h-n
%             pixel_max = max(H_matrix(row, col, :));
%             zero_matrix(n+1,n+1, :) = H_matrix(row, col, :);
%             neighbor_matrix = H_matrix(row-n:row+n, col-n:col+n, :) - zero_matrix;
% 
%             neighborhood_max = max(max(max(neighbor_matrix)));
%             if pixel_max > neighborhood_max && pixel_max > treshold
%                 row_list = [row_list, row];
%                 column_list = [column_list, col];
%             end
%         end
%     end
    rgb_image = zeros(576, 720,3);
    rgb_image(:, :, 1) = image;
    rgb_image(:, :, 2) = image;
    rgb_image(:, :, 3) = image;
    for i=1:length(row_list)
        rgb_image(row_list(i), column_list(i), :) = [1, 0, 0];
    end
    imshow(rgb_image)    
    fprintf('size A %i %i %i \n', size(A))
    fprintf('size B %i %i %i \n', size(B))
    fprintf('size C %i %i %i \n', size(C))
end
    