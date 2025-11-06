% Determines the rotation matrix about the y-axis.
%
% Inputs
% theta - Any angle to rotate the aircraft about the y-axis by. [rad]
%
% Ouputs
% Cy - 3x3 rotation matrix to rotate any vectors about the y-axis by theta
% rad.

function Cy = C_y(theta)
    cos_theta = cos(theta);
    sin_theta = sin(theta);

    % Construct the C_y matrix
    Cy = [cos_theta, 0, -sin_theta; 
                 0, 1, 0; 
                 sin_theta, 0, cos_theta];
return
