function [] = lucas_kanade(image_t1, image_t2)
    
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
    
    % calculate gradients at current time
    %[Gx, Gy] = gradient(double(images(:, :, 1))); % TODO: find out why this doesnt work
    %Gt = abs(images(:, :, 1) - images(:, :, 2));
    Gx = conv2(im_t1, [-1 1; -1 1]);
    Gy = conv2(im_t1, [-1 -1; 1 1]);
    
    % calculate gradients with respect to time
    Gt = conv2(im_t1, ones(2)) + conv2(im_t2, -ones(2));
    
    % divide image in non-overlapping 15 by 15 regions 
    n = 15;
    flows_1 = zeros(size(im_t1));
    flows_2 = zeros(size(im_t1));
    
    % loop over image in steps of size n (neighborhood)
    for col = 1:n:w - n + 1
        for row = 1:n:h - n + 1
            
            % get the region with its gradients
            current_rows = row: row + n - 1;
            current_cols = col: col + n - 1;
            region_grads_x = Gx(current_rows, current_cols);
            region_grads_y = Gy(current_rows, current_cols);
            region_grads_t = Gt(current_rows, current_cols);
            
            % calculate the optical flow for the region
            V = optical_flow(region_grads_x, region_grads_y, region_grads_t);
            flows_1(row, col) = V(1);
            flows_2(row, col) = V(2);
        end 
    end
    plot_optical_flow(image_t1, flows_1, flows_2, h, w, n);
end

function [flow] = optical_flow(Ix, Iy, It)

    % calculate A and b
    A = double([Ix(1:end); Iy(1:end)].');
    b = double((-1 * It(1:end)).');
    
    % calculate flow with pseudoinverse
    flow = pinv(A)*b;
end


function [] = plot_optical_flow(orig_image, V_1, V_2, h, w, n)
    
    % get grid for arrows
    [X, Y] = meshgrid(1:w, 1:h);
    
    % make arrows a bit larger
    V_x = X(1:n:end, 1:n:end);
    V_y = Y(1:n:end, 1:n:end);
    V_1 = V_1(1:n:end, 1:n:end);
    V_2 = V_2(1:n:end, 1:n:end);
    
    % show original image and velocity vectors
    figure();
    imshow(orig_image);
    hold on;
    quiver(V_x, V_y, V_1, V_2, 'r')
end