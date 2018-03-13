function [new_image, M, t, a_inliers, b_inliers] = affine_transform(im_a, im_b, p, n, show)

    % use the keypoint_matching function to find the matching points in the two
    % images.
    [~, ~, x_a, x_b, y_a, y_b, ~, ~] = keypoint_matching(im_a, im_b, show);

    % use the matching points from keypoint_matching to find the transformation
    % from image 1 to image 2.
    [M, t, n_inliers, a_inliers, b_inliers] = ransac(x_a, x_b, y_a, y_b, p, n);

    fprintf('number of inliers: %i \n', n_inliers); 

    [h,w] = size(im_a);
    new_image = zeros(h + 2, w + 2);
    for row = 1:h
        for col = 1:w
            new_coordinates = M * [row; col] + t;
            new_row = round(new_coordinates(1));
            new_col = round(new_coordinates(2));
            if new_row <= 0
                new_row = 1;
            end
            if new_col <= 0
                new_col = 1;
            end
            
            % fill pixels at neighborhood of transformed location
            left_row = max(1, new_row - 2);
            left_col = max(1, new_col - 2);
            new_image(left_row:new_row + 2, left_col:new_col + 2) = im_a(row, col);
        end
    end

end