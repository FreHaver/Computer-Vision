function [ height_map ] = construct_surface( p, q, path_type )
%CONSTRUCT_SURFACE construct the surface function represented as height_map
%   p : measures value of df / dx
%   q : measures value of df / dy
%   path_type: type of path to construct height_map, either 'column',
%   'row', or 'average'
%   height_map: the reconstructed surface


if nargin == 2
    path_type = 'row';
end

[h, w] = size(p);
height_map = zeros(h, w);

switch path_type
    case 'column'
        % =================================================================
        % YOUR CODE GOES HERE
        % top left corner of height_map is zero
        % for each pixel in the left column of height_map
        %   height_value = previous_height_value + corresponding_q_value
        
        % for each row
        %   for each element of the row except for leftmost
        %       height_value = previous_height_value + corresponding_p_value
        height_map(1, 1) = 0;
        for pixel = 2:h
            height_map(pixel, 1) = height_map(pixel - 1, 1) + q(pixel, 1);
        end
        
        for row = 1:h
            for pixel = 2:w
                height_map(row, pixel) = height_map(row, pixel - 1) + p(row, pixel);
            end
        end

       
        % =================================================================
               
    case 'row'
        
        % =================================================================
        % YOUR CODE GOES HERE
        height_map(1, 1) = 0;
        for pixel = 2:w
            height_map(1, pixel) = height_map(1, pixel - 1) + p(1, pixel);
        end
        
        for col = 1:w
            for pixel = 2:h
                height_map(pixel, col) = height_map(pixel - 1, col) + q(pixel, col);
            end
        end
        

        % =================================================================
          
    case 'average'
        
        % =================================================================
        % YOUR CODE GOES HERE
        height_map_row = construct_surface(p, q, 'row');
        height_map_col = construct_surface(p, q, 'column');
        height_map = (height_map_row + height_map_col) ./ 2;
        
        % =================================================================
end


end

