function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space

% create a matrix of the same as the input image
opponent = zeros(size(input_image));

% use the helper function to split the input image into its three channels
[R, G, B] = getColorChannels(input_image);

% compute the opponent color values according to their formulas and put
% them in the new matrix
opponent(:, :, 1) = (R - G) /sqrt(2);
opponent(:, :, 2) = (R + G - 2*B) / sqrt(6);
opponent(:, :, 3) = (R + G + B) / sqrt(3);

output_image = opponent;
end

