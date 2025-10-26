%% C_x matrix
% What does this function do?
% This function generates the C_x matrix for a given rolling angle phi.

% You must Input:
% phi: Rolling angle

% Output will be:
% Cx_matrix: 3x3 rotation matrix

% Main Author:
% 500028951, K.

% Group number: Seven.

function Cx = C_x(phi)
    cos_phi = cos(phi);
    sin_phi = sin(phi);
    % Construct the C_x matrix
    Cx = [1, 0, 0; 0, cos_phi, sin_phi; 0, -sin_phi, cos_phi];
return
