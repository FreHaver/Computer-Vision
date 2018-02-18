function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
% p = zeros(size(normals));
[w, h, d] = size(normals);
p = zeros(512, 512, 1);
% q = zeros(size(normals));
q = zeros(512, 512, 1);
% SE = zeros(size(normals));
SE = zeros(512, 512, 1);

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy
for row = 1:w
    for col = 1:h
        current = normals(row, col, :);
        p(row, col, 1) = current(1) / current(3);
        q(row, col, 1) = current(2) / current(3);
    end
end
% ========================================================================

p(isnan(p)) = 0;
q(isnan(q)) = 0;

% ========================================================================
% YOUR CODE GOES HERE
% approximate second derivate by neighbor difference
% and compute the Squared Errors SE of the 2 second derivatives SE
p2 = diff(p,1,1);
q2 = diff(q,1,2);
p2 = [p2; zeros(1, w)];
q2 = [q2, zeros(w, 1)];
for row = 1:w
    for col = 1:h
        errors = (p2(row, col) - q2(row, col))^2;
        SE(row, col) = errors;
    end
end

% ========================================================================




end

