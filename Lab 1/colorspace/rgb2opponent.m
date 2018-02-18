function [output_image] = rgb2opponent(input_image)
% converts an RGB image into opponent color space
[h, w, s] = size(input_image);
opponent = zeros(size(input_image));

for col = 1:w
    for row = 1:h
        R = input_image(row, col, 1);
        G = input_image(row, col, 2);
        B = input_image(row, col, 3);
        opponent(row, col, 1) = (R - G) / sqrt(2);
        opponent(row, col, 2) = (R + G - 2*B) / sqrt(6);
        opponent(row, col, 3) = (R + G + B) / sqrt(3);
    end
end
disp("created opponent image")
output_image = opponent;
end

