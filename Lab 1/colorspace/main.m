% test your code by using this simple script

clear
clc
close all

I = imread('peppers.png');
image(I)

J = ConvertColorSpace(I,'opponent');

J = ConvertColorSpace(I,'rgb');

J = ConvertColorSpace(I,'gray');

J = ConvertColorSpace(I, 'hsv');

J = ConvertColorSpace(I,'ycbcr');
