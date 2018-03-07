%% Lucas Kanade demo
close all
clc

% read sphere images
im_11 = imread('sphere1.ppm');
im_12 = imread('sphere2.ppm');

% perform lucas kanade and show plot
lucas_kanade(im_11, im_12, true);

% read synth images
im_21 = imread('synth1.pgm');
im_22 = imread('synth2.pgm');

% perform lucas kanade and show plot
lucas_kanade(im_21, im_22, true);