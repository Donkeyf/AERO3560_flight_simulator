function [G] = Gravity(W, X, Flight_Data)
    % Calculates weight force and rotates it into the body axis reference frame
    
    g = Flight_Data.Inertial.g;     % m/s^2 - Gravity Acceleration
    m = Flight_Data.Inertial.m;     % kg - Aircraft Mass
    
    % Weight Force Vector - Earth Frame
    F_g = [0;0;g*m];

    % Earth-to-body Frame Direction Cosine Matrix
    Cbe = DCM(X);

    G = Cbe * F_g;                  % Changed 'W' to 'G'
end 