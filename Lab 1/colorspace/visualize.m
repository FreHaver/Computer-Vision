function visualize(new_image, input_image, method)

% if the requested method is gray, the input image is used to compute the
% four different grayscale color spaces. They are put together in one
% figure with their corresponding labels.
if strcmp(method, 'gray')
    disp("visualizing gray images")
    im_lightness = rgb2grays(input_image, 'lightness');
    im_average = rgb2grays(input_image, 'average');
    im_luminosity = rgb2grays(input_image, 'luminosity');
    im_matlab = rgb2grays(input_image, 'matlabfunc'); 
    figure;
    subplot(2,2,1);
    imshow(im_lightness);
    title('lightness');  
    subplot(2,2,2);
    imshow(im_average);
    title('average');
    subplot(2,2,3);
    imshow(im_luminosity);
    title('luminosity')
    subplot(2,2,4);
    imshow(im_matlab);
    title('rgb2gray');
    suptitle('visualisation of gray color space')
% for all the other methods, the already converted image is split into
% three channels and the image is shown with its channels.
else
    fprintf('Visualizing %s image with its channels \n',method);
    first_channel = new_image(:, :, 1);
    second_channel = new_image(:, :, 2);
    third_channel = new_image(:, :, 3);

    figure;
    subplot(2,2,1);
    imshow(new_image);
    title('converted image');
    subplot(2,2,2);
    imshow(first_channel);
    title('first channel');
    subplot(2,2,3);
    imshow(second_channel);
    title('second channel');
    subplot(2,2,4);
    imshow(third_channel);
    title('third channel')
    suptitle(['visualisation of ', method, ' color space'])
end

