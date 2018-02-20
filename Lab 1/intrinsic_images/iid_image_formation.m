clc
clear all
close all

real_original = imread('ball.png');
reflectance_image = imread('ball_reflectance.png');
% reflectance_image = im2double(reflectance_image);
image(reflectance_image);
title('reflectance');

shadow_image = imread('ball_shading.png');
max(max(shadow_image))
shadow_image = im2double(shadow_image);
max(max(shadow_image))
figure;
imshow(shadow_image);
title('shadow');

[h, w, s] = size(reflectance_image);
original_image = zeros(h,w,s);

for col=1:w
    for row=1:h
        reflectance_element = reflectance_image(row, col, :);
        shadow_element = shadow_image(row, col);
        original_image(row, col, :) = shadow_element * reflectance_element;
    end
end

figure;
original_image = uint8(original_image);
subplot(2,1,1);
imshow(original_image);
title('shadow times reflectance');
subplot(2,1,2);
imshow(real_original);
title('original ball image');