%% harrison corner demo
clear all
close all
clc

im_1 = imread('person_toy/00000001.jpg');

[H, r, c] = harris_corner_detector(im_1, 1.9891e-16, 1);