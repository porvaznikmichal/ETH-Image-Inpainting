function X = overlap_im2col(I, d, overlap)
% Extracts (d x d) patches from image I after every 'overlap' pixels
%
% INPUT
% I: (p x q) image
% d: patch size
% overlap: number of pixels between consecutive patches
%
% OUTPUT
% X: matrix with vectorised patches as columns

% Get image size
[p, q] = size(I);
% Initialise X
X = [];
% Calculate how many patches fit horisontally and vertically
horisontal = (q - d)/overlap;
vertical = (p - d)/overlap;
% Iterate through patches
for i = 0:horisontal
    for j = 0:vertical
        % Take a patch with top-left corner at (i, j) and vectorise it
        X = [X, reshape(I([1:d]+i*overlap, [1:d]+j*overlap), d*d, 1)];
    end
end

