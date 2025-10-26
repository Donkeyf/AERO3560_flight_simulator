%% C_y matrix
% What does this function do?
% This function generates the C_y matrix for a given pitching angle theta.

% You must Input:
% theta: Pitching angle

% Output will be:
% Cy_matrix: 3x3 rotation matrix

% Main Author:
% 500028951, K.

% Group number: Seven.

function Cy = C_y(theta)
    cos_theta = cos(theta);
    sin_theta = sin(theta);

    % Construct the C_y matrix
    Cy = [cos_theta, 0, -sin_theta; 
                 0, 1, 0; 
                 sin_theta, 0, cos_theta];
return
