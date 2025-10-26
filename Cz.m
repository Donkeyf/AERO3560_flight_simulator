function Rz = Cz(psi)
% Determines the rotation matrix about the z-axis
    Rz = [cos(psi), sin(psi), 0; 
         -sin(psi), cos(psi), 0; 
         0, 0, 1];
end