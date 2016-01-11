function I_rec = SMP(I, M, U, Deg, neib, overlap, sigma, rc_min, max_coeff)
% Performs sequential mask peeling inpainting algorithm, as described
% in our paper
%
% INPUT
% I: (p x q) masked image
% M: (p x q) mask hidding image information
% U: (n x K) dictionary with unit atoms in columns
% Deg: (m x n) matrix, containing for each pixel, the number of its
%      neighbours with value 0 in the mask
% neib: the patch sizes used in the decomposition of the image 
% overlap: number of pixels we skip between two neighbouring patches
% sigma: residual error stopping criterion, normalized by signal norm
% rc_min: minimal residual correlation before stopping pursuit
% max_coeff: sparsity constraint for signal representation
%
% OUTPUT
% I_rec: Reconstructed image 

% Set the number of neighbours, under which a pixel is considered in
% boundary
cutoff = 6;

% Initizlize I_rec and stopping threshold
I_rec = I;
threshold = 0.1*sum(sum(M == 0));

% Main peeling loop
while (sum(sum(M == 0)) > threshold)
    % Get 1D signal representation of overlapping patches from image and
    % remainig mask
    X_rec = overlap_im2col(I_rec, neib, overlap);
    mask = overlap_im2col(M, neib, overlap);
    % find sparse representation over dictionary U, using OMP
    Z = OMP(U, X_rec, mask, sigma, rc_min, max_coeff);
    % approximate signals
    X_rec = U*Z;
    % Cut outliers off
    X_rec(X_rec < 0) = 0;
    X_rec(X_rec > 1) = 1;
    % Transform signals back to image
    I_new = overlap_col2im(X_rec, mask, neib, overlap, size(I));
    % Correct known pixels
    I_new(M~=0) = I_rec(M~=0);
    I_rec = I_new;
    % Peel mask and update dictionary
    [M, Deg] = peel_mask(M, Deg, cutoff);
end


