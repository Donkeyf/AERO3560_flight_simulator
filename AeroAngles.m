function [alpha, beta] = AeroAngles(X)
% Calculates the angle of attack and sideslip angles using the current
% velocity.
%
% Outputs:
% alpha - Angle of Attack (radians)
% beta  - Sideslip Angle (radians)
    
    % Computing Current Velocity
    V = norm(X(1:3));

    % Calculating Aerodynamic Angles
    alpha = atan2(X(3)/X(1));
    beta = asin(X(2)/V);
end