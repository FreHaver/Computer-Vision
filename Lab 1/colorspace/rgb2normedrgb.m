function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb

rgbnorm = zeros(size(input_image));
[R, G, B] = getColorChannels(input_image);
denominator = R + G + B;

rgbnorm(:, :, 1) = R ./ denominator;
rgbnorm(:, :, 2) = G ./ denominator;
rgbnorm(:, :, 3) = B ./ denominator;

output_image = rgbnorm;
end

