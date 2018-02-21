function [new_image] = ConvertColorSpace(input_image, colorspace)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Converts an RGB image into a specified color space, visualizes the 
% color channels and returns the image in its new color space.                     
%                                                        
% Colorspace options:                                    
%   opponent                                            
%   rgb -> for normalized RGB
%   hsv
%   ycbcr
%   gray
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% convert image into double precision for conversions
input_image = im2double(input_image);

if strcmp(colorspace, 'opponent')
    new_image = rgb2opponent(input_image);
elseif strcmp(colorspace, 'rgb')  
    new_image = rgb2normedrgb(input_image); 
elseif strcmp(colorspace, 'hsv') 
    new_image = rgb2hsv(input_image);
elseif strcmp(colorspace, 'ycbcr')
    new_image = rgb2ycbcr(input_image);
elseif strcmp(colorspace, 'gray')
    % for rgb2grays, not only the input image is given as an argument but
    % also which method to use to convert the image to the grayspace
    new_image = rgb2grays(input_image, 'lightness');
else
% if user inputs an unknow colorspace just notify and do not plot anything
    fprintf('Error: Unknown colorspace type [%s]...\n',colorspace);
    new_image = input_image;
    return;
end

% because the visualization of the grayspace needs the input image, this is
% also given as an argument.
visualize(new_image, input_image, colorspace);

end