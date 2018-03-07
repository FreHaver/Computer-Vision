function [flows_x, flows_y] = lucas_kanade(image_t1, image_t2, plot_result, varargin)
    
    % convert to grayscale if necessary
    if length(size(image_t1)) > 2
        im_t1 = rgb2gray(image_t1);
        im_t2 = rgb2gray(image_t2);
    else
        im_t1 = image_t1;
        im_t2 = image_t2;
    end
    
    % get size of image at time 1
    [h, w] = size(im_t1);
    
    % set neighborhood
    n = 15;
    
    % if no points specified, use center of 15 by 15 patches as points
    if length(varargin) < 2
        rows = [];
        cols = [];
        for i = 1:15:h - 15 + 1
            for j = 1:15:h - 15 + 1
                rows = [rows i];
                cols = [cols j];
            end
        end
    else
        rows = varargin{1};
        cols = varargin{2};
    end
    
    % calculate gradients at current time
    grad_filter = [-1 0 1; -1 0 1; -1 0 1];
    Ix = conv2(im_t1, grad_filter);
    Iy = conv2(im_t1, grad_filter.');
    
    % calculate gradients with respect to time (blurring signal and taking
    % differences)
    It = conv2(im_t1, ones(3)) + conv2(im_t2, -ones(3));
    
    % divide image in non-overlapping 15 by 15 regions 
    flows_x = zeros(size(im_t1));
    flows_y = zeros(size(im_t1));
    
    % add padding
    pad_size = floor(n / 2);
    Ix = padarray(Ix,[pad_size pad_size],'circular','both');
    Iy = padarray(Iy,[pad_size pad_size],'circular','both');
    It = padarray(It,[pad_size pad_size],'circular','both');
    
    % loop over image in steps of size n (neighborhood)
    for i = 1:length(cols)
        
        % get current point
        row = rows(i);
        col = cols(i);
        
        % get the region with its gradients
        current_rows = row: row + n - 1;
        current_cols = col: col + n - 1;
        region_grads_x = Ix(current_rows, current_cols);
        region_grads_y = Iy(current_rows, current_cols);
        region_grads_t = It(current_rows, current_cols);

        % calculate the optical flow for the region
        V = optical_flow(region_grads_x, region_grads_y, region_grads_t);
        
        % save flows in return arrays
        flows_x(row, col) = V(1);
        flows_y(row, col) = V(2);
    end
    if plot_result == true
        plot_optical_flow(image_t1, flows_x, flows_y, h, w);
    end
end

% calculate optical flow velocity vectors with least squares
% (pseudoinverse)
function [flow] = optical_flow(Ix, Iy, It)

    % calculate A and b
    A = double([Ix(1:end); Iy(1:end)].');
    b = double((-1 * It(1:end)).');

    % calculate flow with pseudoinverse
    flow = pinv(A)*b;
end

% plot optical flow over image with quiver
function [] = plot_optical_flow(orig_image, V_1, V_2, h, w)
    
    % get grid for arrows
    [V_x, V_y] = meshgrid(1:w, 1:h);
    
    % show original image and velocity vectors
    figure();
    imshow(orig_image);
    hold on;
    quiver(V_x, V_y, V_1, V_2, 10, 'r');
end