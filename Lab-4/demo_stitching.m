%% stitching
clear all
close all
clc

% read in the images
Ia = rgb2gray(imread('left.jpg'));
Ib = rgb2gray(imread('right.jpg'));

stitched_im = stitch(Ia, Ib, 6, 50, false);
figure;
imshow(mat2gray(stitched_im));