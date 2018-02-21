clc
clear all
close all

% load the original image and its intrinsics.
original_image = imread('ball.png');
reflectance_image = imread('ball_reflectance.png');
shadow_image = imread('ball_shading.png');
shadow_image = im2double(shadow_image);

% create a new matrix with the size of the original image
[h, w, s] = size(original_image);
recreated_image = zeros(h,w,s);

% for each patch, multiply the shadow and the reflectance of that patch
% with each other and put the result in the new matrix
for col=1:w
    for row=1:h
        reflectance_element = reflectance_image(row, col, :);
        shadow_element = shadow_image(row, col);
        recreated_image(row, col, :) = shadow_element * reflectance_element;
    end
end

% create a figure with the original image, the reflectance, shading and the
% recreated image.
figure;
recreated_image = uint8(recreated_image);
subplot(1,4,1);
imshow(original_image);
title('original');
subplot(1,4,2);
imshow(shadow_image);
title('shadow');
subplot(1,4,3);
imshow(reflectance_image);
title('reflectance');
subplot(1,4,4);
imshow(recreated_image);
title('recreated')