%% affine transformation
clear all
close all
clc

% read in the images
Ia = imread('boat1.pgm');
Ib = imread('boat2.pgm');

% perform affine transformation algorithm
% CHANGE: location of Ib and Ia as input to run transformation other way
% around
[new_Ia, m_remember, t_remember, a_inliers, b_inliers] = affine_transform(Ia, Ib, 50, 50, 0, true);

% result comparison with matlab built-in functions (used imwarp instead of 
m_trans = horzcat(vertcat(m_remember, t_remember'), [0; 0; 1]);
T = affine2d(m_trans);
new_Ia2 = imwarp(Ia, T);

% create a new figure
figure(3) ; clf ;

% convert transformed image
new_Ia = mat2gray(new_Ia);

% filter out salt-and-pepper noise with small median filter
% CHANGE: filter of size [2 2] for image Ia to Ib and [3 3] for Ib to Ia
new_Ia = medfilt2(new_Ia, [2 2]);

% show the new image
imshow(mat2gray(new_Ia));