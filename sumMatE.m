function [ e ] = sumMatE( i, j )
%SUMMATE Construct a matrix that has j vectors at the diag, each of these
%vectors is ones(1,i).
% OUTPUT 
%   e       - size : j x (i*j)
    
    e = zeros(j, (i*j));
    for k =1:j
        e(k, ((k-1)*i+1) : (k*i)) = ones(1,i) / i;
    end

end

