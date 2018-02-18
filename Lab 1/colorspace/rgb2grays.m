function [output_image] = rgb2grays(input_image, method)
% converts an RGB into grayscale by using 4 different methods

if strcmp(method, 'matlabfunc')
    grayscale = rgb2gray(input_image);
else
    [h, w, s] = size(input_image);
    grayscale = zeros(h,w,s);
    
    [R, G, B] = getColorChannels(input_image);

    for col = 1:w
        for row = 1:h
            R_element = R(row, col);
            G_element = G(row, col);
            B_element = B(row, col);
            max_rgb = max([R_element, G_element, B_element]);
            min_rgb = min([R_element, G_element, B_element]);

            if strcmp(method, 'lightness')
                grayscale(row,col, :) = (max_rgb - min_rgb) / 2;
            elseif strcmp(method, 'average')
                grayscale(row,col, : ) = ( R_element + G_element + B_element) / 3;
            elseif strcmp(method, 'luminosity')
                grayscale(row, col, :) = 0.21 * R_element + 0.72 * G_element + 0.07 * B_element;
            end
        end
    end
end

output_image = grayscale;

end

