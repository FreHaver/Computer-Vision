clc
clear all
close all

% load the original image and its intrinsics
original_image = imread('ball.png');
shading = imread('ball_shading.png');
shading = im2double(shading);
reflectance = imread('ball_reflectance.png');

% print the rgb value of the centre of the reflectance image (its true
% color)
fprintf('RGB values of the true color: %i %i %i \n', squeeze(reflectance(133,240, :)))

% get the size of the reflectance image
[h, w, s] = size(reflectance);

% create a purple image of the size of the reflectance
purple_reflectance = zeros(h, w, s);
purple_reflectance(:,:,1) = 255 * ones(h,w);
purple_reflectance(:,:,3) = 255 * ones(h,w);

% create a green image of the size of the reflectance
green_reflectance = zeros(h, w, s);
green_reflectance(:, :, 2) = 255 * ones(h,w);

% create to matrixes of the size of the reflectance (and original image)
green_image = zeros(h,w, s);
purple_image = zeros(h, w, s);

% for each patch, the shadow and the reflectance of the specific color are
% multiplied and put in the new matrices.
for row=1:h
    for col=1:w
        shading_element = shading(row, col);
        purple_element = purple_reflectance(row, col, :);
        green_element = green_reflectance(row,col,:);
        green_image(row, col, :) = shading_element * green_element;
        purple_image(row, col, :) = shading_element * purple_element;
    end
end

% convert the images back to uint8 values
green_image = uint8(green_image);
purple_image = uint8(purple_image);

% show the original image and the two recolored images
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
