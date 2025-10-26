function Rx = Cx(phi)
% Determines the rotation matrix about the x-axis
    Rx = [1, 0, 0; 
         0, cos(phi), sin(phi); 
         0, -sin(phi), cos(phi)];
end