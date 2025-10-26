% AERO3560 Assignment 3: Coordinate Systems and airfoil characteristics
% Function 'q2e' to convert quaternions to euler angles

% Author: 460 495 765
function [eulerAngles] = q2e(quaternions)

    % Determine size of quaternions matrix
    q = quaternions;

    % Extract quaternions
    
    q0 = q(1,:);
    q1 = q(2,:); 
    q2 = q(3,:);
    q3 = q(4,:);
        
    % Calculate theta
    theta = atan2(((q0.*q2)-(q1.*q3)), (((q0.^2 + q1.^2) - (1/2))^2 + ((q1.*q2) + (q0 .* q3))^2)^(1/2));

    % Calculate psi
    phi = atan2(((q2.*q3)+(q0.*q1)), ((q0.^2 + q3.^2) - (1/2))); 

    % Calculate phi
    psi = atan2(((q1.*q2)+(q0.*q3)), ((q0.^2 + q1.^2) - (1/2))); 
     
    % Assemble matrix of euler angles 
    eulerAngles = [phi; theta; psi];
end