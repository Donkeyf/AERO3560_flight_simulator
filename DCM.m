% Determines the direction cosine matrix (DCM) to rotate a vector from the
% Earth to the body frame of an aircraft from its quaternion attitude.
%
% Inputs
% X - Aircraft state vector.
%
% Ouputs
% Cbe - 3x3 DCM to rotate vector from Earth to body axes.

function [Cbe] = DCM(X)
    % Extracting quaternions
    q0 = X(7);                                 
    q1 = X(8);
    q2 = X(9);
    q3 = X(10);

    % Calculation of the rotation matrix terms
    t11 = q0^2 + q1^2 -q2^2 - q3^2;
    t12 = 2*(q1*q2 + q0*q3);
    t13 = 2*(q1*q3 - q0*q2);
    t21 = 2*(q1*q2 - q0*q3);
    t22 = q0^2 - q1^2 + q2^2 - q3^2;
    t23 = 2*(q2*q3 + q0*q1);
    t31 = 2*(q0*q2 + q1*q3);
    t32 = 2*(q2*q3 - q0*q1);
    t33 = q0^2 - q1^2 - q2^2 + q3^2;

    % DCM
    Cbe = [t11,t12,t13; t21,t22,t23; t31,t32,t33];
end