function [ albedo, normal ] = estimate_alb_nrm( image_stack, scriptV, shadow_trick)
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

for row = 1:w
    for col = 1:h
        i = squeeze(image_stack(row, col, :));
        scriptI = diag(i);
        
        if shadow_trick
            [g, ~] = linsolve(scriptI * scriptV, scriptI * i);
        else
            [g, ~] = linsolve(scriptV, i);
        end
        
        albedo(row, col, 1) = norm(g);
        if norm(g) > 0
            normal(row, col, :) = g / norm(g);
        end
    end
end

end

