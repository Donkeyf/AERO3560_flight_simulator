function Ry = Cy(theta)
% Determines the rotation matrix about the y-axis
    Ry = [cos(theta), 0, -sin(theta); 
         0, 1, 0; 
         sin(theta), 0, cos(theta)];
end