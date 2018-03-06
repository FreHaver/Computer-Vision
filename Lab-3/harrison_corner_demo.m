%% harrison corner demo
clear all
close all
clc

im_1 = imread('person_toy/00000001.jpg');

% im_1 = imread('pingpong/0000.jpeg');

% harris_corner_detector(image, treshold, neighborhood, sigma_smooth, show figures)
[H, r, c] = harris_corner_detector(im_1, 0.001, 3, 1, false);

% im_1 = imrotate(im_1, 90);
% [H, r, c] = harris_corner_detector(im_1, 0.0007, 3, 1);
% 
% im_1 = imrotate(im_1, 30);
% [H, r, c] = harris_corner_detector(im_1, 0.0007, 3, 1);
