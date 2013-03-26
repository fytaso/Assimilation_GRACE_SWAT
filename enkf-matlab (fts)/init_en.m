function [ x_e ] = init_en( x, d, q )
%INIT_ENSEMBLE Initialize the ensemble
% INPUT:
%   x    - The initial model STATE, n by 1
%   d    - The standard variance of the Gaussian perturbations
%   q    - The size of the ensemble
%
% OUTPUT:
%   x_e  - The ensemble of the model STATEs, n by q

    n = size(x,1);
    x_e = zeros(n,q);
    for i = 1:q
        x_e(:,i) = x + normrnd(0,d,[n,1]);
    end
end