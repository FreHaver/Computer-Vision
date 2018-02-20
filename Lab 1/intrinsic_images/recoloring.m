clc
clear all
close all

original_image = imread('ball.png');
shading = imread('ball_shading.png');
shading = im2double(shading);
reflectance = imread('ball_reflectance.png');

[h, w, s] = size(reflectance);

purple_reflectance = zeros(h, w, s);
purple_reflectance(:,:,1) = 255 * ones(h,w);
purple_reflectance(:,:,3) = 255 * ones(h,w);

green_reflectance = zeros(h, w, s);
green_reflectance(:, :, 2) = 255 * ones(h,w);

green_image = zeros(h,w, s);
purple_image = zeros(h, w, s);
for row=1:h
    for col=1:w
        shading_element = shading(row, col);
        purple_element = purple_reflectance(row, col, :);
        green_element = green_reflectance(row,col,:);
        green_image(row, col, :) = shading_element * green_element;
        purple_image(row, col, :) = shading_element * purple_element;
    end
end

green_image = uint8(green_image);
purple_image = uint8(purple_image);

figure;
subplot(1,3,1);
imshow(original_image);
title('input')
subplot(1,3,2);
imshow(green_image);
title('green ball');
subplot(1,3,3);
imshow(purple_image);
title('magenta ball');
