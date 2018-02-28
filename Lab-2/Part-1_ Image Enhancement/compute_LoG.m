function imOut = compute_LoG(image, LOG_type)

switch LOG_type
    case 1
        %method 1
        h = gauss2D(0.5 , 5);
        smoothed_im = imfilter(image, h);
        % implement laplacian on smoothed image
        fprintf('Not implemented\n')

    case 2
        %method 2
        h = fspecial('log', 5, 0.5);
        imOut = imfilter(image, h);
    case 3
        %method 3
        fprintf('Not implemented\n')

end
end

