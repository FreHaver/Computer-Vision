close all
road_image = im2double(imread('images/image2.jpg'));
[road_x, road_y, magn, dir] = compute_gradient(road_image);
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