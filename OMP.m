function Z = OMP(U, X, M, sigma, rc_min, max_coeff)
% Perform sparse coding using a orthogonal matching pursuit tailored to the
% inpainting problem with residual stopping criterion.
%
% INPUT
% U: (d x l) unit norm atoms
% X: (d x n) observations
% M: (d x n) mask denoting which observations are unknown
% sigma: residual error stopping criterion, normalized by signal norm
% rc_min: minimal residual correlation before stopping
% max_coeff: maximal number of non-zero coefficients for signal
%
% OUTPUT
% Z: OMP coding
%

% Constants and initializations
l = size(U,2);
d = size(U,1);
n = size(X,2);
mask = (M~=0);
U_copy = U;
Z = zeros(l,n);

% Loop over all observations in the columns of X
for nn = 1:n
    % Initialize the residual with the observation x
    Res = X(:,nn);
    % Mask the dictionary according to the signal mask to prevent fitting
    % to the missing data
    U_copy = U_copy.*repmat(mask(:,nn), 1, l);
    
    % Initialize z to zero
    z = [];
    
    % Initialize used atoms
    D = [];
    I = [];
    
    % initialize st0ping criteria
    threshold = norm(X(:,nn))*sigma;
    rc_max = inf;
    num_coeff = 0;
    while ((norm(Res) > threshold) && (rc_max > rc_min) && (sum(z~=0) < max_coeff)) 
        % Select atom with maximum absolute correlation to the residual
        [rc_max, max_ind] = max(abs(Res'*U_copy));
        % Update the used atoms
        D = [D, U_copy(:,max_ind)];
        I = [I, max_ind]; 
        % Update coding vector
        z = inv(D'*D)*D'*X(:,nn);
        % Update residual vector
        Res = X(:,nn) - D*z;
    end
    % Add the calculated coefficient vector z to the overall matrix Z
    coding = zeros(l,1);
    coding(I) = z;
    Z(:,nn) = coding;
    % Reset dictionary matrix U
    U_copy = U;
end

