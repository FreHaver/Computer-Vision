clc
clear all
close all

fprintf('Automatic White Balance\n')

% load the original image
original_image = imread('awb.jpg');

% compute for R, G and B what the average value in the matrix is.
original_mean_vector = squeeze(mean(mean(original_image)));
R_mean = original_mean_vector(1);
G_mean = original_mean_vector(2);
B_mean = original_mean_vector(3);
fprintf('mean of the original image per channel are: %f %f %f \n', R_mean, G_mean, B_mean)

gray_world_image = zeros(size(original_image));

% the new values for R, G and B ar computed by multiplying the original R,
% G and B values with the fraction of the mean compared to 128.
gray_world_image(:, :, 1) = (128 / R_mean) * original_image(:, :, 1);
gray_world_image(:, :, 2) = (128 / G_mean) * original_image(:, :, 2);
gray_world_image(:, :, 3) = (128 / B_mean) * original_image(:, :, 3);

% again the average values for R, G, and B are computed to check the new
% values
gray_mean_vector = squeeze(mean(mean(gray_world_image)));
R_mean2 = gray_mean_vector(1);
G_mean2 = gray_mean_vector(2);
B_mean2 = gray_mean_vector(3);

% the figure is made with the original and the new image
gray_world_image = uint8(gray_world_image);
fprintf('mean of the gray world image per channel: %f %f %f \n', R_mean2, G_mean2, B_mean2)
figure;
subplot(1,2,1);
imshow(original_image);
title('original');
subplot(1,2,2);
imshow(gray_world_image);
title('gray world');

