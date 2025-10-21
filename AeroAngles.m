function [alpha, beta] = AeroAngles(X)
% Calculates the angle of attack and sideslip angles using the current
% velocity
    V = sqrt(X(1)^2 + X(2)^2 + X(3)^2);
    alpha = asin(X(2)/V);
    beta = atan(X(3)/V);
end