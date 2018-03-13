function [stitched_im] = stitch(left_im, right_im, show)
    
    [stitched_im, M, t, left_inliers, right_inliers] = affine_transform(left_im, right_im, show);
    
end