function [ yend ] = lorenz3( y, dt )
%LORENZ3 step one for 3 dimensional Lorenz model
    
    function [dy] = lorenz3_deriv(y,dummy)
    % Calculates derivative for L3 model.
        dy = [0; 0; 0];
    
        dy(1) = 10.0 * (y(2) - y(1));
        dy(2) = (28.0 - y(3)) * y(1) - y(2);
        dy(3) = y(1) * y(2) - (8.0 / 3.0) * y(3); 
    end
   
    yend = rk4step(@lorenz3_deriv, dt, y);
end