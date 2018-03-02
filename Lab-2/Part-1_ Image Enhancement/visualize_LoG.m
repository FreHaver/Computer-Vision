close all
clear all
clc

% read the image for which the edges have to be detected
im1 = imread('images/image2.jpg');

% apply the Laplacian to Gaussian filter with three different methods
imOut1 = compute_LoG(im1, 1);
imOut2 = compute_LoG(im1, 2);
imOut3 = compute_LoG(im1, 3, 0.4, 0.6);

% for the third method, initialize a range of sigma's to use
sigma_1 = [0.4, 0.05];
sigma_2 = [0.5, 1, 2, 4, 6,  8, 10, 15, 20, 25];

% compute the PSNR of the method with the LoG implemented by the build-in
% function of Matlab with the DoG method with different values for sigma
for i=1:length(sigma_1)
    for j=1:length(sigma_2)
        imOut = compute_LoG(im1, 3, sigma_1(i), sigma_2(j));
        psnr = myPSNR(imOut2, imOut);
        fprintf('sigma_1: %1.1f, sigma_2: %1.1f gives psnr: %2.3f \n', sigma_1(i), sigma_2(j), psnr)
    end
end

% create a figure to store the original image and the images of the three 
% different LoG implementation methods. 
figure;
subplot(1,4,1);
imshow(im1);
title('original image');
subplot(1, 4, 2);
imshow(imOut1);
title('method 1, Gaussian Laplacian');
subplot(1, 4, 3);
imshow(imOut2);
title('method 2, LoG');
subplot(1, 4, 4);
imshow(imOut);
title('method 3, DoG');
