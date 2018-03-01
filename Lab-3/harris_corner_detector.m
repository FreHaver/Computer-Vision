function [H_matrix, row_list, column_list] = harris_corner_detector(image, treshold, n)
    image = im2double(image);
    G = gauss2D(0.2, 3);
    [Gx, Gy] = gradient(G);
    Ix = imfilter(image, Gx, 'conv');
    Iy = imfilter(image, Gy, 'conv');
    Ix_squared = Ix.^2;
    Iy_squared = Iy.^2;
    Ixy = Ix.*Iy;
    A = imfilter(Ix_squared, G);
    B = imfilter(Ixy, G);
    C = imfilter(Iy_squared, G);
    H_1 = A.*C - B.^2;
    H_2 = (A + C).^2;
    H_matrix = H_1 - 0.04 * H_2;
    [h, w, s] = size(H_matrix);
    
    zero_matrix = zeros((n*2)+1,(n*2)+1, 3); 

    row_list = [];
    column_list = [];
    for col = 1+n:w-n
        for row = 1+n:h-n
            pixel_max = max(H_matrix(row, col, :));
            zero_matrix(n+1,n+1, :) = H_matrix(row, col, :);
            neighbor_matrix = H_matrix(row-n:row+n, col-n:col+n, :) - zero_matrix;

            neighborhood_max = max(max(max(neighbor_matrix)));
            if pixel_max > neighborhood_max && pixel_max > treshold
                row_list = [row_list, row];
                column_list = [column_list, col];
            end
        end
    end
    
    for i=1:length(row_list)
        image(row_list(i), column_list(i), :) = [1, 0, 0];
    end
    imshow(image)    
    fprintf('size A %i %i %i \n', size(A))
    fprintf('size B %i %i %i \n', size(B))
    fprintf('size C %i %i %i \n', size(C))
end
    