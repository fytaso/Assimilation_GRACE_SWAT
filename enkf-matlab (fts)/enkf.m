function [ xa_e ] = enkf( xf_e, H, y, R )
%ENKF The Ensemble Kalman Filter
% INPUTS:
%   xf_e  	- Ensemble of model forecast STATEs, n by q
%   H       - OBSERVATION operator, n by m
%   y       - OBSERVATION vector, m by 1
%   R       - Coariance of OBSERVATION, m by m
%
% OUTPUTS:
%   xa_e    - Ensemble of assimilation analysis STATEs, q by n
%
% VARIABLES
%   n       - Dimension of model state
%   m       - Dimension of observation
%   q       - Size of ensemble

    % dimension of observation
    m = size(y, 1);
    
    % size of ensemble
    q = size(xf_e, 2);
    
    % convariance matrix of forecast state
    Pf_e = cov(xf_e');
    
    % ensemble of observation
    y_e = zeros(m, q);
    for i = 1:q
        y_e(:,i) = y + mvnrnd(zeros(1,m), R)';
    end
    
    % covariance matrix of observation
    R_e = cov(y_e');
    
    % Kalman gain
    K = Pf_e * H' / (H * Pf_e * H' + R_e);
    
    % Analysis Ensemble
    xa_e = zeros(size(xf_e));
    
    % Analysis process, update each member in the ensemble
    for i = 1:q
        xa_e(:,i) = xf_e(:,i) + K * (y - H * xf_e(:,i));
    end
end

