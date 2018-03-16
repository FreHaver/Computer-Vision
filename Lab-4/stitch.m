function [stitched] = stitch(left_original, right_original, left_im, right_im, p, n)
    
    % use the keypoint_matching function to find the matching points in the two
    % images.
    [~, ~, x_a, x_b, y_a, y_b, ~, ~] = keypoint_matching(right_im, left_im);

    % use the matching points from keypoint_matching to find the transformation
    % from image 1 to image 2.
    [M, t, ~, ~, ~] = ransac(x_a, x_b, y_a, y_b, p, n);
       
    % get size of left and right image
    [h_l, w_l] = size(left_im);
    [h_r, w_r] = size(right_im);
    
    % estimate size of stitched image
    [height, width] = estimate_size(h_r, w_r, M, t);

    % initialize stitched image
    stitched = zeros(height, width, 3);
    
    % copy left image to stitched image
    for row = 1:h_l
        for col = 1:w_l
            stitched(row, col, :) = left_original(row, col, :);
        end
    end
    
    % add transformed right image to stitched image
    for row = 1:h_r
        for col = 1:w_r
            
            % transform coordinates
            new_coordinates = M * [row; col] + t;
            new_row = round(new_coordinates(1));
            new_col = round(new_coordinates(2));
            
            % add to image with weighted mean of left and right if
            % in overlapping area
            current_pixel = stitched(new_row, new_col, :);
            if sum(current_pixel) ~= 0
                stitched(new_row, new_col, :) = 0.5 * double(current_pixel) + 0.5 * double(right_original(row, col, :));
            
            % add to image as is in non-overlapping ares
            else
                stitched(new_row, new_col, :) = right_original(row, col, :);
            end 
        end
    end
end

% function that estimates size of stitched image based on corners of
% rightmost image
function [height, width] = estimate_size(h_r, w_r, M, t)
    
    % get corners of image
    corners = [1, 1, h_r, h_r; 1, w_r, 1, w_r];
    
    % initialize limits
    xlims = zeros(8, 1);
    ylims = zeros(8, 1);
    
    % loop over corners, transform and save in limits
    for i = 1:length(corners)
        current_corner = corners(:, i);
        points = M * current_corner + t;
        xlims(i) = points(2);
        ylims(i) = points(1);
    end
    
    % get mins and max of limits
    xmin = min(1, min(min(xlims)));
    xmax = max(w_r, max(max(xlims)));
    ymin = min(1, min(min(ylims)));
    ymax = max(h_r, max(max(ylims)));
    
    % save in actual limits and calculate estimate width and height
    xlim = [xmin; xmax];
    ylim = [ymin; ymax];
    width = round(xlim(2) - xlim(1));
    height = round(ylim(2) - ylim(1));
end