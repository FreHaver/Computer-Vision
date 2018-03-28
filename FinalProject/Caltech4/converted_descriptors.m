function [new_da] = converted_descriptors(I_color, colorspace, dense)

switch colorspace
    case "RGB"
        I_color = I_color;
    case "norm_rgb"
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

if dense
    I_smooth = vl_imsmooth(single(I_color), 1);
    [ch_1, ch_2, ch_3] = getColorChannels(I_smooth);
    [~, da_1] = vl_dsift(ch_1, 'step', 10);
    [~, da_2] = vl_dsift(ch_2, 'step', 10);
    [~, da_3] = vl_dsift(ch_3, 'step', 10);
else
    [ch_1, ch_2, ch_3] = getColorChannels(I_color);
    if strcmp(colorspace, "RGB")
        I_gray = single(rgb2gray(I_color));
    else
        I_gray = single(rgb2grays(I_color, 'average'));
    end
    [fa, ~] = vl_sift(I_gray);
    [~, da_1] = vl_sift(single(ch_1), 'Frames', fa);
    [~, da_2] = vl_sift(single(ch_2), 'Frames', fa);
    [~, da_3] = vl_sift(single(ch_3), 'Frames', fa);
end

new_da = vertcat(da_1, da_2, da_3);

end