function I = overlap_col2im(X, M, d, overlap, im_size)
% Recombines overlapping (d x d) patches into an image reconstruction
% weighting them by their signal-to-noise ration as described in 
% Section 2.3
%
% INPUT
% X: (d^2 x N) matrix containing the vectorised signals
% M: (d^2 x N) matrix containing the vectorised mask. Each column is the
% mask of the corresponding column of X
% d: patch size
% overlap: number of pixels between consecutive patches
% im_size: tuple of original image dimensions
%
% OUTPUT
% X: matrix with vectorised patches as columns

% Get image dimensions
p = im_size(1);
q = im_size(2);

% Initialise the image
I = zeros(p, q);

% Initialise the matrix that stores the cumulative signal used to calculate
% each pixel
S = zeros(p, q);

% Calculate how many patches fit horisontally and vertically
horisontal = (q - d)/overlap;
vertical = (p - d)/overlap;

% Iterate through patches and keep a counter to know what column of X to
% access next
counter = 0;
for i = 0:horisontal
    for j = 0:vertical
        counter = counter + 1;
        % Get x and y range of current patch
        x_patch = [1:d]+i*overlap;
        y_patch = [1:d]+j*overlap;
        % Get existing patch
        existing_patch = I(x_patch, y_patch);
        % Get current patch and calculate its signal strength
        current_patch = reshape(X(:,counter), d, d);
        signal = sum(sum(M(:,counter)~=0));
        % Update cumulative signal strength
        S(x_patch, y_patch) = S(x_patch, y_patch) + signal;
        % Update patch
        I(x_patch, y_patch) = existing_patch + current_patch*signal;
    end
end
% If a pixel was not covered by a single patch with signal, set its signal
% value to 1, in order to prevent division by zero
S(S == 0) = 1;

% Divide each pixel by its corresponding cumulative signal coverage
I = I./S;
