% test your code by using this simple script
clear
clc
close all

% load the pepper image
I = imread('peppers.png');
image(I)

% for the different options of converting, convert the pepper image to a
% different color space
ConvertColorSpace(I, 'opponent');
ConvertColorSpace(I, 'rgb');
ConvertColorSpace(I, 'gray');
ConvertColorSpace(I, 'hsv');
ConvertColorSpace(I, 'ycbcr');
