function [da] = image_to_descriptors(file, colorspace, dense)

I_color = imread(char(file));

da = converted_descriptors(I_color, colorspace, dense);

end