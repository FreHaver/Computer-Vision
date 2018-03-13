%% stitching
clear all
close all
clc

% read in the images
Ia = rgb2gray(imread('left.jpg'));
Ib = rgb2gray(imread('right.jpg'));

new_Ia = stitch(Ia, Ib, false);

% create a new figure
figure(3) ; clf ;
% show the two images side to side
imagesc(new_Ia);