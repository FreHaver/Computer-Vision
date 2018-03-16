function [matches, scores, x_a, x_b, y_a, y_b, fa,fb] = keypoint_matching(image1, image2)

    % convert the image to single precision
    Ia_single = single(image1);
    Ib_single = single(image2);

    % compute the SIFT frames (the keypoints) and the descriptors
    [fa, da] = vl_sift(Ia_single);
    [fb, db] = vl_sift(Ib_single);

    % with the descriptors, the frames are matched and given a score
    [matches, scores] = vl_ubcmatch(da, db);

    % store the x and y coordinates of the frames  
    x_a = fa(2, matches(1, :)) ;
    x_b = fb(2, matches(2, :)) ;
    y_a = fa(1, matches(1, :)) ;
    y_b = fb(1, matches(2, :)) ;
    
end