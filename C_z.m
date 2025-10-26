%% C_z matrix
% What does this function do ?
% This function generates the C_z matrix for a given yaw angle psi.

% You must Input: 
% psi: Yaw angle

% Output will be: 
% Cz_matrix: 3x3 rotation matrix

function Cz_matrix = C_z(psi)
    c_psi = cos(psi);
    s_psi = sin(psi);

    % Construct the C_z matrix
    Cz_matrix = [c_psi, s_psi, 0; -s_psi, c_psi, 0; 0, 0, 1];
return
