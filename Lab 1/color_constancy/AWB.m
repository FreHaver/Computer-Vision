clc
clear all
close all

fprintf('Automatic White Balance\n')

original_image = imread('awb.jpg');

original_mean_vector = squeeze(mean(mean(original_image)));
R_mean = original_mean_vector(1);
G_mean = original_mean_vector(2);
B_mean = original_mean_vector(3);
fprintf('mean of the original image per channel: %f %f %f \n', R_mean, G_mean, B_mean)

grey_world_image = zeros(size(original_image));

grey_world_image(:, :, 1) = (128 / R_mean) * original_image(:, :, 1);
grey_world_image(:, :, 2) = (128 / G_mean) * original_image(:, :, 2);
grey_world_image(:, :, 3) = (128 / B_mean) * original_image(:, :, 3);

grey_mean_vector = squeeze(mean(mean(grey_world_image)));
R_mean2 = grey_mean_vector(1);
G_mean2 = grey_mean_vector(2);
B_mean2 = grey_mean_vector(3);

grey_world_image = uint8(grey_world_image);
fprintf('mean of the grey world image per channel: %f %f %f \n', R_mean2, G_mean2, B_mean2)
figure;
subplot(1,2,1);
imshow(original_image);
title('original');
subplot(1,2,2);
imshow(grey_world_image);
title('grey world');

