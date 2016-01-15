function Deg = get_degrees(M)
% Takes image mask M in 2-D image form and counts for each pixel the number
% of its neighbours in mask
%
% INPUT
% M: (p x q) binary mask
%
% OUTPUT
% Deg: (p x q) matrix, containing for each pixel, the number of its
%      neighbours with value 0 in the mask

% Get mask dimensions
[p, q] = size(M);

% Initialize Deg
Deg = zeros(p, q);

% Get indices of missing pixels (M == 0)
[mask_x, mask_y] = ind2sub([p, q], find(M == 0));
% Loop through the missing pixels and count the number of their neighbours
for i = 1:numel(mask_x)
    % Get current pixel position
    x = mask_x(i);
    y = mask_y(i);
    % Get valid neighbourhood of ith pixel (!!!watch out for OUT OF RANGE)
    x_range = [max(x-1, 1):min(x+1, p)];
    y_range = [max(y-1, 1):min(y+1, q)];
    % Count neighbours
    Deg(x, y) = sum(sum(M(x_range, y_range) == 0)) - 1;
end

