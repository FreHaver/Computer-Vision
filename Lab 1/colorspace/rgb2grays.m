function [output_image] = rgb2grays(input_image, method)
% converts an RGB into grayscale by using 4 different methods

[h, w, s] = size(input_image);
grayscale = zeros(h,w,s);

for col = 1:w
    for row = 1:h
        R = input_image(row, col, 1);
        G = input_image(row, col, 2);
        B = input_image(row, col, 3);
        max_rgb = max([R, G, B]);
        min_rgb = min([R, G, B]);
        
        if strcmp(method, 'lightness')
            grayscale(row,col, :) = (max_rgb - min_rgb) / 2;
        elseif strcmp(method, 'average')
            grayscale(row,col, : ) = ( R + G + B) / 3;
        elseif strcmp(method, 'luminosity')
            grayscale(row, col, :) = 0.21 * R + 0.72 * G + 0.07 * B;
        else
            disp("this method was not implemented by ourselfs")
        end
    end
end

if strcmp(method, 'matlabfunc')
    disp("using matlab rgb2gray function")
    grayscale = rgb2gray(input_image);
else
    disp("the method is also not implemented by matlab, choose another method")
end

disp("created grayscale image")
output_image = grayscale;

end

