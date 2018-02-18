function [output_image] = rgb2normedrgb(input_image)
% converts an RGB image into normalized rgb

[h, w, s] = size(input_image);
rgbnorm = zeros(size(input_image));

for col = 1:w
    for row = 1:h
        R = input_image(row, col, 1);
        G = input_image(row, col, 2);
        B = input_image(row, col, 3);
        rgbnorm(row, col, 1) = R / (R + G + B);
        rgbnorm(row, col, 2) = G / (R + G + B);
        rgbnorm(row, col, 3) = B / (R + G + B);
    end
end
disp("created rgbnorm image")
output_image = rgbnorm;
end

