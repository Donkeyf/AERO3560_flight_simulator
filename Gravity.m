% Determines the weight force acting on the aircraft in the body frame.
% 
% Inputs
% Flight_Data - A structure storing all aerodynamic, geometric, inertial,
% propulsive information required to simulate the aircraft dynamics, also
% includes the maximum control surface deflections.
% X - Aircraft state vector.
% 
% Outputs
% G - Weight force vector acting in the body frame.

function [G] = Gravity(Flight_Data, X)
    % Calculates weight force and rotates it into the body axis reference frame
    
    g = Flight_Data.Inertial.g;     % m/s^2 - Gravity Acceleration
    m = Flight_Data.Inertial.m;     % kg - Aircraft Mass
    
    % Weight Force Vector - Earth Frame
    Wf = [0;0;g*m];

    % Earth-to-body Frame Direction Cosine Matrix
    Cbe = DCM(X);

    % Rotate weight force into body axes
    G = Cbe * Wf;                  
end 