function [da] = image_to_descriptors(file, colorspace, dense)
fprintf('getting descriptors from file: %s \n', char(file));
try
    % convert image to grayscale
    I_color = imread(char(file));
    I_gray = rgb2gray(I_color);
catch
    % if the image is already in grayscale, skip the image
    fprintf('file already in grayscale: %s \n', char(file));
end

% convert the type of the image to single
I_gray = single(I_gray);
I_color = single(I_color);

% apply sift and store the features
if dense
    fa = 0;
else
    [fa, ~] = vl_sift(I_gray);
end

% get the descriptors in the given colorspace 
da = color_descriptors(fa, I_color, colorspace, dense);
end