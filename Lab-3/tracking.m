%% tracking
clear all
close all
clc

% initialize video writer (CHANGE NAME TO SAVE)
writer = VideoWriter('person_toy.avi'); % change name to save to
open(writer);

% get first image (CHANGE IF DIFFERENT IMAGE PATH)
im_name = 'person_toy/00000001.jpg'; % change image to detect corners on
no_images = 103; % change number of last image manually (52 or 103)

% get begin and end of image name to change number of image in loop
im_name_split = strsplit(im_name, '/');
folder_name = strcat(im_name_split{1}, '/');
im_name_split_2 = strsplit(im_name_split{2}, '.');
file_name = im_name_split_2{1};
extension = strcat('.', im_name_split_2{2});
name_length = length(file_name);
first_img = imread(im_name);

% detect corners on first image
[H, r, c] = harris_corner_detector(first_img, 0.001, 3, 1, false);
 
% set axes
ax = gca();
for i = 1:no_images - 1
    
    % get image pair for tracking
    fn_1 = pad(int2str(i), name_length, 'left', '0');
    fn_2 = pad(int2str(i + 1), name_length, 'left', '0');
    fn_1 = strcat(folder_name, fn_1, extension);
    fn_2 = strcat(folder_name, fn_2, extension);
    im_1 = imread(fn_1);
    im_2 = imread(fn_2);
    [h, w, ~] = size(im_1);
    
    % lucas-kanade optical flow
    [flows_x, flows_y] = lucas_kanade(im_1, im_2, false, r, c);
    
    % update corner points based on flow (with factor 1.5)
    [r, c] = update_points(flows_x, flows_y, r, c, 1.5);
    
    % plot opticalflow
    [V_x, V_y] = meshgrid(1:w, 1:h);
    im = imshow(im_1, 'Parent', ax);
    hold on;
    q = quiver(ax, V_x, V_y, flows_x, flows_y, 20, 'r');
    drawnow();
    
    % write to video
    frame = getframe(gca);
    writeVideo(writer, frame);
    
    % delete image and quiver
    delete(im);
    delete(q);
end

% close axes and video writer
close(gcf);
close(writer);

% function that updates row and col numbers of corner points based on
% optical flow velocity vectors (and multiplies update step with fct)
function [new_r, new_c] = update_points(flowsX, flowsY, r, c, fct)
    new_r = zeros(length(r));
    new_c = zeros(length(c));
    for i = 1:length(r)
       new_r(i) = round(r(i) + fct * flowsY(r(i), c(i)));
       new_c(i) = round(c(i) + fct * flowsX(r(i), c(i)));
    end
end
