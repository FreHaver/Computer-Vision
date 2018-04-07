function [output_image] = rgb2grays(input_image, method)
% converts an RGB into grayscale by using 4 different methods

if strcmp(method, 'matlabfunc')
    % if the method equals the matlabfunction, then no other steps are
    % necessary to convert to the grayscale colorspace
    grayscale = rgb2gray(input_image);
else
    % for the other methods, first a grayscale matrix of the same size as
    % the input image is created
    [h, w, ~] = size(input_image);
    grayscale = zeros(h,w);
    
    % use the helper function to split the input image into its three
    % channels
    [R, G, B] = getColorChannels(input_image);

    for col = 1:w
        for row = 1:h
            % get the three color values at a specific row and column 
            R_element = R(row, col);
            G_element = G(row, col);
            B_element = B(row, col);
            
            % for each method seperatly, fill in the grayscale matrix
            % according to the right formula.
            if strcmp(method, 'lightness')
                max_rgb = max([R_element, G_element, B_element]);
                min_rgb = min([R_element, G_element, B_element]);
                grayscale(row,col) = single((max_rgb - min_rgb) / 2);
            elseif strcmp(method, 'average')
                grayscale(row,col) = single(( R_element + G_element + B_element) / 3);
            elseif strcmp(method, 'luminosity')
                grayscale(row, col) = single(0.21 * R_element + 0.72 * G_element + 0.07 * B_element);
            end
        end
    end
end

output_image = grayscale;

end

