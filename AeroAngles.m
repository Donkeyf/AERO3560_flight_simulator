function [alpha, beta] = AeroAngles(X)
% Calculates the angle of attack and sideslip angles using the current
% velocity.
%
% Outputs:
% alpha - Angle of Attack (radians)
% beta  - Sideslip Angle (radians)
    
    % Extract velocity components and magnitude
    u = X(1);
    v = X(2);
    w = X(3);
    V = norm(X(1:3));

    % Calculating Aerodynamic Angles
    alpha = atan2(w/u);
    beta = asin(v/V);
end