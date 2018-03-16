%% stitching
clear all
close all
clc

% read in the images
Ia_color = imread('left.jpg');
Ia = rgb2gray(Ia_color);
Ib_color = imread('right.jpg');
Ib = rgb2gray(Ib_color);

% stitch images
stitched_im = stitch(Ia_color, Ib_color, Ia, Ib, 6, 50);

% convert image
figure;
stitched_im = mat2gray(stitched_im);

% filter out salt-and-pepper noise with small median filter
stitched_im(:, :, 1) = medfilt2(stitched_im(:, :, 1), [2 2]);
stitched_im(:, :, 2) = medfilt2(stitched_im(:, :, 2), [2 2]);
stitched_im(:, :, 3) = medfilt2(stitched_im(:, :, 3), [2 2]);

% show image
imshow(stitched_im);