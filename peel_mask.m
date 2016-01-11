function [M, Deg] = peel_mask(M, Deg, cutoff)
% Removes boundary pixel layer from the mask and updates number of
% neighbours in the mask
%
% INPUT
% M: (p x q) image mask
% Deg: (p x q) matrix, containing for each pixel, the number of its
%      neighbours with value 0 in the mask
% neib: The patch sizes used in the decomposition of the image
% cutoff: number of neighbours, under which a pixel is considered in
%         boundary layer
%
% OUTPUT
% mask: (p x q) peeled image mask
% Deg: (p x q) updated degree matrix

% Get image size
[p,q] = size(Deg);

% Get set of pixels with degree less than cutoff
boundary = find(Deg < cutoff);
% Consider only those in mask
boundary = intersect(boundary, find(M==0));
% Delete boundary elements from mask
M(boundary) = 1;

% Turn linear matrix indices to 2-dim subscripts
[x,y] = ind2sub(size(Deg), boundary);
% Update degrees by looping throught boundary layer
for i = 1:numel(boundary)
    % Remember original degree of this pixel
    d = Deg(x(i),y(i));
    % Get valid neighbourhood of ith pixel (!!!watch out for OUT OF RANGE)
    x_range = [max(x(i)-1, 1):min(x(i)+1, p)];
    y_range = [max(y(i)-1, 1):min(y(i)+1, q)];
    % Update neighbourhood of ith pixel
    Deg(x_range, y_range) = max(Deg(x_range, y_range) - 1, 0);
    % Correct the degree of itself
    Deg(x(i), y(i)) = d;
end


