clear all
close all
clc

% read in the images
Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

% use the keypoint_matching function to find the matching points in the two
% images.
[matches, scores, x_a, x_b, y_a, y_b] = keypoint_matching(Ia,Ib);

% use the matching points from keypoint_matching to find the transformation
% from image 1 to image 2.
[m_remember, t_remember, n_inliers, a_inliers, b_inliers] = ransac(x_a, x_b, y_a, y_b, 50, 60);

fprintf('number of inliers: %i \n', n_inliers); 

% create a new figure
figure(3) ; clf ;
% show the two images side to side
imagesc(cat(2, Ia, Ib)) ;

% get the x and y coordinates of the inliers, (the x coordinates for the
% second image are shifted because the images are shown side by side)
xa = a_inliers(1,:) ;
xb = b_inliers(1,:) + size(Ia,2) ;
ya = a_inliers(2,:) ;
yb = b_inliers(2,:);

% draw lines between the interest points in image 1 and the interest points
% in image 2. 
hold on ;
h = line([xa ; xb], [ya ; yb]) ;
set(h,'linewidth', 1, 'color', 'b') ;