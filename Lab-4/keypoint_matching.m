function [matches, scores, x_a, x_b, y_a, y_b, fa,fb] = keypoint_matching(image1, image2, show)

    % convert the image to single precision
    Ia_single = single(image1);
    Ib_single = single(image2);

    % the function vl_sift is used to compute the SIFT frames (the keypoints),
    % and the descriptors
    [fa, da] = vl_sift(Ia_single);
    [fb, db] = vl_sift(Ib_single);

    % with the descriptors, the frames are matched and given a score
    [matches, scores] = vl_ubcmatch(da, db);

    % with the matches and the frames, the x and y coordinates of the frames in
    % both images are stored.   
    x_a = fa(2, matches(1, :)) ;
    x_b = fb(2, matches(2, :)) ;
    y_a = fa(1, matches(1, :)) ;
    y_b = fb(1, matches(2, :)) ;

    % the scores are sorted in descending order and also the matches are sorted
    % accordingly
    [~, perm] = sort(scores, 'descend') ;
    matches = matches(:, perm);
    scores  = scores(perm);

    % create a figure with the two images side by side
    if show == true
        figure(1) ; clf ;
        imagesc(cat(2, image1, image2)) ;
        axis image off ;
    end

    % show the images again side by side, but this time with lines and points
    % to mark the matches (only the 50 with the highest scores are shown)
    matches = matches(:, 1:50);
    if show == true
        figure(2) ; clf ;
        imagesc(cat(2, image1, image2)) ;
    end    

    xa = fa(1, matches(1, :)) ;
    xb = fb(1, matches(2, :)) + size(image1, 2) ;
    ya = fa(2, matches(1, :)) ;
    yb = fb(2, matches(2, :)) ;
    
    fb(1,:) = fb(1,:) + size(image1,2) ;
    if show == true
        hold on ;
        h = line([xa ; xb], [ya ; yb]);
        set(h,'linewidth', 1, 'color', 'b');

        vl_plotframe(fa(:,matches(1,:))); 
        vl_plotframe(fb(:,matches(2,:))) ;
        axis image off ;
    end
    
end