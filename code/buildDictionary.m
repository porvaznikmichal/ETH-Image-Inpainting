function U = buildDictionary(dim)
% Builds a dictionary with atoms of specified dimension
%
% INPUT
% dim: The dimensionality of the dictionary atoms
%
% OUTPUT
% U: (n x K) dictionary with unit norm atoms


try 
    temp = load('dictionary.mat');
    U = temp.U;
catch
    U = overDCTdict(dim^2, 2*dim^2);
end

   