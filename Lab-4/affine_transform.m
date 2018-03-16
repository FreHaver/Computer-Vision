function [new_image, M, t, a_inliers, b_inliers] = affine_transform(im_a, im_b, p, n, neighborhood, show)

    % use the keypoint_matching function to find the matching points in the two
    % images.
    [matches, ~, x_a, x_b, y_a, y_b, fa, fb] = keypoint_matching(im_a, im_b);
    
    % get random permutation of matches
    le = length(matches);
    k = randperm(le);
    matches(:, k);

    % show images with connection between random subset of matches
    matches = matches(:, 1:50);
    if show == true
        figure(2) ; clf ;
        imshow(cat(2, mat2gray(im_a), mat2gray(im_b))) ;
    end    
    
    % plot lines between matches
    xa = fa(1, matches(1, :)) ;
    xb = fb(1, matches(2, :)) + size(im_a, 2) ;
    ya = fa(2, matches(1, :)) ;
    yb = fb(2, matches(2, :)) ;
    fb(1,:) = fb(1,:) + size(im_a, 2) ;
    if show == true
        hold on ;
        h = line([xa ; xb], [ya ; yb]);
        set(h,'linewidth', 1, 'color', 'b');

        vl_plotframe(fa(:,matches(1,:))); 
        vl_plotframe(fb(:,matches(2,:))) ;
        axis image off ;
    end
    
    % use the matching points from keypoint_matching to find the transformation
    % from image 1 to image 2.
    [M, t, n_inliers, a_inliers, b_inliers] = ransac(x_a, x_b, y_a, y_b, p, n);

    fprintf('number of inliers: %i \n', n_inliers); 
    
    % get size of image to initialize new image
    [h, w] = size(im_a);
    new_image = zeros(h + 2, w + 2);
    
    % transform each pixel coordinate and add to new image
    for row = 1:h
        for col = 1:w
            
            % transform coordinates
            new_coordinates = M * [row; col] + t;
            new_row = round(new_coordinates(1));
            new_col = round(new_coordinates(2));

            % fill pixel at transformed location
            new_row = max(1, new_row - neighborhood);
            new_col = max(1, new_col - neighborhood);
            new_image(new_row: new_row, new_col: new_col) = im_a(row, col);
        end
    end
end