function [new_da] = image_to_descriptors(file, colorspace, dense)

% read the file as an image
I_color = imread(char(file));

% convert the image to the appropiate colorspace
switch colorspace
    case "RGB"
        I_color = I_color;
    case "norm_rgb"
        % multiplied by 255 to make sure the values are not too small for
        % training
        I_color = 255*single(rgb2normedrgb(I_color));
    case "opponent"
        I_color = single(rgb2opponent(I_color));
    case {'hsv','HSV'}
        I_color = single(rgb2hsv(I_color));
    case {"xyz", "XYZ"}
        I_color = single(rgb2xyz(I_color));
    case {"ycbcr", "YCbCr"}
        I_color = single(rgb2ycbcr(I_color));
    otherwise
        fprintf('%s colorspace not implemented \n', colorspace)
end

% dense-SIFT
if dense
    % smooth the colored image
    I_smooth = vl_imsmooth(single(I_color), 1);
    
    % get the three channels of the smoothed image
    [ch_1, ch_2, ch_3] = getColorChannels(I_smooth);
    
    % use dense-SIFT to obtain the descriptors with a step size of 10
    [~, da_1] = vl_dsift(ch_1, 'step', 10);
    [~, da_2] = vl_dsift(ch_2, 'step', 10);
    [~, da_3] = vl_dsift(ch_3, 'step', 10);
% point-SIFT
else
    % get the three channels of the colored image
    [ch_1, ch_2, ch_3] = getColorChannels(I_color);
    % if the colorspace is RGB the colored image is converted to grayscales
    % by using the matlab build-in function. for the other colorspaces the
    % average of the three color channels is taken
    if strcmp(colorspace, "RGB")
        I_gray = single(rgb2grays(I_color, 'matlabfunc'));
    else
        I_gray = single(rgb2grays(I_color, 'average'));
    end
    % apply point-SIFT on the gray image to retrieve the keypoint positions
    [fa, ~] = vl_sift(I_gray);
    
    % retrieve the descriptors of the color channels at the keypoint
    % positions.
    [~, da_1] = vl_sift(single(ch_1), 'Frames', fa);
    [~, da_2] = vl_sift(single(ch_2), 'Frames', fa);
    [~, da_3] = vl_sift(single(ch_3), 'Frames', fa);
end

% concatenate the descriptors of the three color channels
new_da = vertcat(da_1, da_2, da_3);

end