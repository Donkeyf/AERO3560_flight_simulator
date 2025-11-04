% AERO3560 Assignment 3: Coordinate Systems and airfoil characteristics
% Function 'q2e' to convert quaternions to euler angles

% Author: 460 495 765
function [e] = q2e(q)

% Extract quaternion components
q0 = q(1, :);
q1 = q(2, :);
q2 = q(3, :);
q3 = q(4, :);

% Determine Euler angles
theta = atan2(q0.*q2 - q1.*q3, sqrt((q0.^2 + q1.^2 - 0.5).^2 + (q1.*q2 + q0.*q3).^2));
phi = atan2(q2.*q3 + q0.*q1, q0.^2 + q3.^2 - 0.5);
psi = atan2(q1.*q2 + q0.*q3, q0.^2 + q1.^2 - 0.5);

% Set output vector
e = [phi; theta; psi];

end