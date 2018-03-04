%% Lucas Kanade demo
close all
clc

im_11 = imread('sphere1.ppm');
im_12 = imread('sphere2.ppm');
lucas_kanade(im_11, im_12);

im_21 = imread('synth1.pgm');
im_22 = imread('synth2.pgm');
lucas_kanade(im_21, im_22);