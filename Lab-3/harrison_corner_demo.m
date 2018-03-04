%% harrison corner demo
clear all
close all
clc

im_1 = imread('person_toy/00000001.jpg');

% harris_corner_detector(image, treshold, neighborhood)
[H, r, c] = harris_corner_detector(im_1, 0.0001, 1);