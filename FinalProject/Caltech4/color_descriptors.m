function [new_da] = color_descriptors(fa, I_color, colorspace, dense)

% convert the image to the given colorspace
switch colorspace
    case "RGB"
        I_color = I_color;
    case "rgb"
        I_color = rgb2rgbnormrgb(I_color);
    case "opponent"
        I_color = rgb2opponent(I_color);
    otherwise
        fprintf('%s colorspace not implemented \n', colorspace)
end


if dense
    I_smooth = vl_imsmooth(I_color, 1);
    [ch_1, ch_2, ch_3] = getColorChannels(I_smooth);
    [~, da_1] = vl_dsift(ch_1, 'step', 10);
    [~, da_2] = vl_dsift(ch_2, 'step', 10);
    [~, da_3] = vl_dsift(ch_3, 'step', 10);
else
    [ch_1, ch_2, ch_3] = getColorChannels(I_color);
    [~, da_1] = vl_sift(ch_1, 'Frames', fa);
    [~, da_2] = vl_sift(ch_2, 'Frames', fa);
    [~, da_3] = vl_sift(ch_3, 'Frames', fa);
end
new_da = vertcat(da_1, da_2, da_3); 
fprintf('descriptor size for this image: %i, %i \n', size(new_da));
end