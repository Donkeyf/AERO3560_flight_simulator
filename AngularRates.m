% File: AngularRates.m
%
% Description: Compute the angular rates of angle of attack (alpha) and
% sideslip (beta) from the body-axis translational velocities and their
% time-derivatives. Uses the kinematic definitions
%   alpha = atan2(w, u)
%   beta  = atan2( v, sqrt(u^2 + w^2) )
% and their exact time derivatives.
%
% Instructions to the user:
% Call this from within the force/moment build (e.g., WindForces.m) or
% StateRates.m when uDot, vDot, wDot are available. The state vector x is
% [u v w p q r q0 q1 q2 q3 x_e y_e z_e]^T. Units are SI, angles in radians.

function [alphaDot, betaDot] = AngularRates(x, xDot)
    % Extract velocity components and magnitude
    u = X(1);
    v = X(2);
    w = X(3);
    V = norm(X(1:3));

    % Extract acceleration components and magnitude
    u_dot = X_dot(1);
    v_dot = X_dot(2);
    w_dot = X_dot(3);
    V_dot = norm(X(1:3));

    % Compute rates of change of beta and alpha angles
    alphaDot = (u*w_dot - w*u_dot)/(u^2 + w^2);                    
    betaDot = ((v_dot/V)- ((v*V_dot)/V^2))/(sqrt(1- (v^2/V^2)));   
end