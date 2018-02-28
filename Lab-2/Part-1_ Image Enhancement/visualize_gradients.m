close all
%% helper function to use when visualizing the Sabor gradient elements

% load image and use the compute_gradient function to compute the Sabor
% gradient elements
road_image = im2double(imread('images/image2.jpg'));
[road_x, road_y, magn, dir] = compute_gradient(road_image);

% plot the different gradient elements in the same figure.
figure;
subplot(2,2,1)
imshow(road_x);
title('gradient x-direction');
subplot(2,2,2)
imshow(road_y);
title('gradient y-direction');
subplot(2,2,3)
imshow(magn);
title('gradient magnitude');
subplot(2,2,4)
imshow(dir);
title('gradient direction');