function [stitched_im] = stitch(left_im, right_im, p, n, show)
    
    [~, M, t, ~, ~] = affine_transform(right_im, left_im, p, n, show);
    
    [h_l, w_l] = size(left_im);
    [h_r, w_r] = size(right_im);

    corners = [1, 1; w_r, h_r];
    xlims = zeros(4, 1);
    ylims = zeros(4, 1);
    for i = 1:length(corners)
        current_corner = corners(:, i);
        points = M * current_corner + t;
        xlims(i) = points(2);
        ylims(i) = points(1);
    end
    
    xmin = min(1, min(min(xlims)));
    xmax = max(w_l, max(max(xlims)));
    ymin = min(1, min(min(ylims)));
    ymax = max(h_l, max(max(ylims)));
    
    xlim = [xmin; xmax];
    ylim = [ymin; ymax];
    
    width = round(xlim(2) - xlim(1));
    height = round(ylim(2) - ylim(1));

    [h, w] = size(left_im);
    % Initialize panorama.
    stitched = zeros(height, width);
    for row = 1:h
        for col = 1:w
            stitched(row, col) = left_im(row, col);
        end
    end
    
    [h_r, w_r] = size(right_im);
    for row = 1:h_r
        for col = 1:w_r
            new_coordinates = M * [row; col] + t;
            new_row = round(new_coordinates(1));
            new_col = round(new_coordinates(2));
            if new_row <= 0
                new_row = 1;
            end
            if new_col <= 0
                new_col = 1;
            end
            left_row = max(1, new_row - 2);
            left_col = max(1, new_col - 2);
            stitched(left_row: new_row + 2, left_col: new_col + 2) = right_im(row, col);
        end
    end
    stitched_im = stitched;
end