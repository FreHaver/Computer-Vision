%% stitching
clear all
close all
clc

% read in the images
Ia = rgb2gray(imread('left.jpg'));
Ib = rgb2gray(imread('right.jpg'));

new_Ib = stitch(Ia, Ib, 10, 20, false);

% create a new figure
figure(3) ; clf ;
% show the two images side to side
imagesc(new_Ib);