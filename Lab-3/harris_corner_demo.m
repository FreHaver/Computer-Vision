%% Harris corner demo
clear all
close all
clc

% comment or uncomment the line to determine the image that is used.
% person_toy: treshold 0.001
% pingpong  : treshold 0.002
im_1 = imread('person_toy/00000001.jpg');
% im_1 = imread('pingpong/0000.jpeg');

% pick an rotation angle and rotate the image with it
rotation_angle = 0;
im_rotated = imrotate(im_1, rotation_angle);

% use the harrison corner detector function to mark the corners on the
% rotated image, with the variables listed below:
% harris_corner_detector(image, treshold, neighborhood, sigma_smooth, show_figures)
[H, r, c] = harris_corner_detector(im_rotated, 0.001, 3, 1, true);