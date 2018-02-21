function [ albedo, normal] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
%COMPUTE_SURFACE_GRADIENT compute the gradient of the surface
%   image_stack : the images of the desired surface stacked up on the 3rd
%   dimension
%   scriptV : matrix V (in the algorithm) of source and camera information
%   shadow_trick: (true/false) whether or not to use shadow trick in solving
%   	linear equations
%   albedo : the surface albedo
%   normal : the surface normal


[h, w, ~] = size(image_stack);
if nargin == 2
    shadow_trick = true;    
end

albedo = zeros(h, w, 1);
normal = zeros(h, w, 3);

% loop over each pixel
for row = 1:h
    for col = 1:w
        
        % squeeze out the unit dimension
        i = squeeze(image_stack(row, col, :));
        
        % solve linear system per pixel and apply shadow trick if necessary
        if shadow_trick
            scriptI = diag(i);
            [g, ~] = linsolve(scriptI * scriptV, scriptI * i);
        else
            [g, ~] = linsolve(scriptV, i);
        end
        
        % extract the albedo
        albedo(row, col, 1) = norm(g);
        
        % calculate the normal if denominator larger than 0
        if norm(g) > 0
            normal(row, col, :) = g / norm(g);
        end
    end
end

end

