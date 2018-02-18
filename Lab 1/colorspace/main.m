% test your code by using this simple script

clear
clc
close all

I = imread('peppers.png');
image(I)

% close all

% J = ConvertColorSpace(I,'opponent');
% image(J)
% 
% J = ConvertColorSpace(I,'rgb');

% close all
% J = ConvertColorSpace(I,'hsv');
J = rgb2hsv(I);
h = J(:,:,1)
s = J(:,:,2);
v = J(:,:,3);
image(h)
% close all
% J = ConvertColorSpace(I,'ycbcr');

% close all
% J = ConvertColorSpace(I,'gray');
% image(J)