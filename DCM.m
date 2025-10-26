function [Cbe] = DCM(X)
    % Determines the direction cosine matrix to transform from the Earth to the
    % body reference frame

    % Extracting quaternions
    q0 = X(1);                                  % Changed (CLW) from '7'
    q1 = X(2);
    q2 = X(3);
    q3 = X(4);

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