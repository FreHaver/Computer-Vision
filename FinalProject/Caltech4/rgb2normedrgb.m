function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb image

% create a matrix of the same as the input image
rgbnorm = zeros(size(input_image));

% use the helper function to split the input image into its three channels
[R, G, B] = getColorChannels(input_image);

% compute the denominator
denominator = R + G + B;

% compute the normalized RGB values and put them in the new matrix
rgbnorm(:, :, 1) = R ./ denominator;
rgbnorm(:, :, 2) = G ./ denominator;
rgbnorm(:, :, 3) = B ./ denominator;

output_image = rgbnorm;
end

