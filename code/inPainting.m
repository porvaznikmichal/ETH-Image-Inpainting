function I_rec = inPainting(I, mask)
% Perform the actual inpainting of the image 
%
% INPUT
% I: (p x q) masked image
% mask: (p x q) the mask hiding image information
%
% OUTPUT
% I_rec: Reconstructed image 

% Parameters
rc_min = 0.01; % rc_min: minimal residual correlation before stopping pursuit
sigma = 0.01; % sigma: residual error stopping criterion, normalized by signal norm
max_coeff = 10; % max_coeff: sparsity constraint for signal representation
neib = 16; % neib: The patch sizes used in the decomposition of the image
overlap = 8; % overlap: number of pixels we skip between two neighbouring patches

% Build dictionary
U = buildDictionary(neib);

% Compute number of neighbours in the mask for each pixel
Deg = get_degrees(mask);    

% Reconstruct image using sequential mask peeling algorithm
I_rec = SMP(I, mask, U, Deg, neib, overlap, sigma, rc_min, max_coeff);
