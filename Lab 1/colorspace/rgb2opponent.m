function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space
opponent = zeros(size(input_image));
[R, G, B] = getColorChannels(input_image);

opponent(:, :, 1) = (R - G) /sqrt(2);
opponent(:, :, 2) = (R + G - 2*B) / sqrt(6);
opponent(:, :, 3) = (R + G + B) / sqrt(3);

output_image = opponent;
end

