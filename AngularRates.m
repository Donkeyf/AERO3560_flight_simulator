% Determines the derivatives of the angle of attack and sidelsip angle.
% 
% Inputs
% x - Aircraft state vector.
% xDot - State rates vector.
%
% Ouputs
% alphaDot - Rate of change of angle of attack. [rad/s]
% betaDot - Rate of change of sideslip angle. [rad/s]

function [alphaDot, betaDot] = AngularRates(x, xDot)
    % Extract velocity components and magnitude
    u = x(1);
    v = x(2);
    w = x(3);
    V = norm(x(1:3));

    % Extract acceleration components and magnitude
    u_dot = xDot(1);
    v_dot = xDot(2);
    w_dot = xDot(3);
    V_dot = norm(xDot(1:3));

    % Compute rates of change of beta and alpha angles
    alphaDot = (u*w_dot - w*u_dot)/(u^2 + w^2);                    
    betaDot = ((v_dot/V)- ((v*V_dot)/V^2))/(sqrt(1- (v^2/V^2)));   
end