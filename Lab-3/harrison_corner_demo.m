%% harrison corner demo
clear all
close all
clc

im_1 = rgb2gray(imread('person_toy/00000001.jpg'));

[H, r, c] = harris_corner_detector(im_1, 5.0591e-07, 0.01);