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
       
        % first add all partial derivatives in first column
        height_map(1, 1) = 0;
        for pixel = 2:h
            height_map(pixel, 1) = height_map(pixel - 1, 1) + q(pixel, 1);
        end
        
        % then add all partial derivatives in rows (except first element)
        for row = 1:h
            for pixel = 2:w
                height_map(row, pixel) = height_map(row, pixel - 1) + p(row, pixel);
            end
        end
               
    case 'row'
        
        % first add all partial derivatives in first row
        height_map(1, 1) = 0;
        for pixel = 2:w
            height_map(1, pixel) = height_map(1, pixel - 1) + p(1, pixel);
        end
        
        % then add all partial derivatives in columns (except first
        % element)
        for col = 1:w
            for pixel = 2:h
                height_map(pixel, col) = height_map(pixel - 1, col) + q(pixel, col);
            end
        end
          
    case 'average'
        
        % shape by integration for row-major and column-major
        height_map_row = construct_surface(p, q, 'row');
        height_map_col = construct_surface(p, q, 'column');
        
        % take average of the two
        height_map = (height_map_row + height_map_col) ./ 2;

end


end

