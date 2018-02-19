function [ p, q, SE ] = check_integrability( normals )
%CHECK_INTEGRABILITY check the surface gradient is acceptable
%   normals: normal image
%   p : df / dx
%   q : df / dy
%   SE : Squared Errors of the 2 second derivatives

% initalization
[h, w, d] = size(normals);
p = zeros(h, w, 1);
q = zeros(h, w, 1);
SE = zeros(h, w, 1);

% ========================================================================
% YOUR CODE GOES HERE
% Compute p and q, where
% p measures value of df / dx
% q measures value of df / dy
for row = 1:h
    for col = 1:w
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
p2 = diff(p, 1, 1);
q2 = diff(q, 1, 2);

% zero padding
[x, y] = size(p2);
p2 = [p2; zeros(abs(x - y), w)];
q2 = [q2, zeros(h, abs(x - y))];
for row = 1:h
    for col = 1:w
        errors = (p2(row, col, 1) - q2(row, col, 1))^2;
        SE(row, col) = errors;
    end
end

% ========================================================================




end

