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

    % Guard for missing or empty xDot (fallback to zeros)
    if nargin < 2 || isempty(xDot)
        xDot = zeros(size(x));
    end

    % Extract body-axis velocities and their derivatives
    u    = x(1);
    v    = x(2);
    w    = x(3);
    uDot = xDot(1);
    vDot = xDot(2);
    wDot = xDot(3);

    % Useful magnitudes with small epsilons to avoid division by zero
    r_xz = sqrt(u^2 + w^2);           % speed in x–z plane
    V    = sqrt(u^2 + v^2 + w^2);     % total speed
    epsR = 1e-8;                      % small number for robustness
    epsV = 1e-8;

    r_xz_safe = max(r_xz, epsR);
    V_safe    = max(V,    epsV);

    % Time derivative of alpha = atan2(w, u)
    % alphaDot = (u*wDot - w*uDot) / (u^2 + w^2)
    denom_alpha = max(r_xz_safe^2, epsR);
    alphaDot    = (u*wDot - w*uDot) / denom_alpha;

    % Time derivative of beta = atan2(v, r_xz)
    % betaDot = (r_xz*vDot - v*r_xzDot) / (r_xz^2 + v^2)  with
    % r_xzDot = (u*uDot + w*wDot) / r_xz
    r_xzDot     = (u*uDot + w*wDot) / r_xz_safe;
    denom_beta  = max(V_safe^2, epsV);              % r_xz^2 + v^2 = V^2
    betaDot     = (r_xz*vDot - v*r_xzDot) / denom_beta;
end