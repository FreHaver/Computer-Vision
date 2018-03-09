%% affine transformation
clear all
close all
clc

% read in the images
Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

% use the keypoint_matching function to find the matching points in the two
% images.
[matches, scores, x_a, x_b, y_a, y_b, f_a, f_b] = keypoint_matching(Ia, Ib);

% use the matching points from keypoint_matching to find the transformation
% from image 1 to image 2.
[m_remember, t_remember, n_inliers, a_inliers, b_inliers] = ransac(x_a, x_b, y_a, y_b, 50, 50);

fprintf('number of inliers: %i \n', n_inliers); 

[h,w] = size(Ia);
new_Ia = zeros(h, w);
count = 0;
for row = 1:h
    for col = 1:w
        new_coordinates = m_remember * [row; col] + t_remember;
        new_row = round(new_coordinates(1));
        new_col = round(new_coordinates(2));
        if new_row <= 0
            new_row = 1;
        end
        if new_col <= 0
            new_col = 1;
        end
        new_Ia(new_row, new_col) = Ia(row, col);
    end
end

% result comparison with matlab built-in functions (used imwarp instead of 
m_trans = horzcat(vertcat(m_remember, t_remember'), [0; 0; 1]);
T = affine2d(m_trans);
new_Ia2 = imwarp(Ia, T);

% create a new figure
figure(3) ; clf ;
% show the two images side to side
imagesc(new_Ia);
figure(4) ; clf ;
imagesc(new_Ia2);

% figure(4) ; clf ;
% imagesc(Ib);
% imagesc(cat(2, Ib, new_Ia)) ;

% get the x and y coordinates of the inliers, (the x coordinates for the
% second image are shifted because the images are shown side by side)
xa = a_inliers(1,:) ;
xb = b_inliers(1,:) + size(Ia,2) ;
ya = a_inliers(2,:) ;
yb = b_inliers(2,:);

% draw lines between the interest points in image 1 and the interest points
% in image 2. 
% hold on ;
% h = line([xa ; xb], [ya ; yb]) ;
% set(h,'linewidth', 1, 'color', 'b') ;