%% affine transformation
clear all
close all
clc

% read in the images
Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

% perform affine transformation algorithm
[new_Ia, m_remember, t_remember, a_inliers, b_inliers] = affine_transform(Ia, Ib, 50, 50, true);

% result comparison with matlab built-in functions (used imwarp instead of 
m_trans = horzcat(vertcat(m_remember, t_remember'), [0; 0; 1]);
T = affine2d(m_trans);
new_Ia2 = imwarp(Ia, T);

% create a new figure
figure(3) ; clf ;
% show the two images side to side
imshow(mat2gray(new_Ia));
% figure(4) ; clf ;
% imshow(mat2gray(new_Ia2));

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