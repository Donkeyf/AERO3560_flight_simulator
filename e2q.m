% AERO3560 Assignment 1: Coordinate Systems and airfoil characteristics
% Function 'e2q' to convert euler angles to quaternions

% Author: Wingtip Warriors

function quaternions = e2q(eulerAngles)

    
    
    % EulerAngles
    e = eulerAngles;

    % Extract phi, theta and psi
    phi = deg2rad(e(1,:));
    theta = deg2rad(e(2,:));
    psi = deg2rad(e(3,:));

    % Find q0
    q0 = ((cos(psi/2))* (cos(theta/2)) * (cos(phi/2))) + ...
                ((sin(psi/2)) * (sin(theta/2)) * (sin(phi/2)));

    % Find q1
    q1 = ((cos(psi/2))* (cos(theta/2)) * (sin(phi/2))) - ...
                ((sin(psi/2)) * (sin(theta/2)) * (cos(phi/2)));

    % Find q2
    q2 = ((cos(psi/2))* (sin(theta/2)) * (cos(phi/2))) + ...
                ((sin(psi/2)) * (cos(theta/2)) * (sin(phi/2)));

    % Find q4
    q3 = -((cos(psi/2))* (sin(theta/2)) * (sin(phi/2))) + ...
                ((sin(psi/2)) * (cos(theta/2)) * (cos(phi/2)));

    % quaternions vector with 4 columns and a single row
    quaternions = [q0; q1; q2; q3];

end
