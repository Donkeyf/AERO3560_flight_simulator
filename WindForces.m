% File: WindForces.m
%
% Description: Compute Lift and Drag in the wind/stability frame from the
% current state, controls and aircraft data. Uses a simple drag polar
%   CD = CD0 + k * CL^2
% with dynamic effects embedded in CL via alphȧ and q̄ when available.
% Returns positive lift & drag coefficients to calculate lift and drag
% forces.
%
% Instructions to the user: Call from the force/moment build when
% FlowProperties.m, AeroAngles.m and AngularRates.m are available.
% Inputs are state x = [u v w p q r q0 q1 q2 q3 x_e y_e z_e]^T,
% controls U = [δ_T; δ_e; δ_a; δ_r], Flight_Data with .Geo and .Flight_Data.Aero.

function [C_L, C_D] = WindForces(X, U, Flight_Data, xDot)
    % Extract states from state vector and control vector
    q = X(5);
    de = U(2);

    % Compute velocity, angle of attack and sideslip angle
    [V, alpha, ~] = AeroAngles(X);
    [alphaDot, ~] = AngularRates(X, xDot);

    % Non-dimensionalise terms
    c_bar = Flight_Data.Geo.c;       % Chord length [m]

    % Nondimensional rates
    q_bar = (q*c_bar)/(2*V);               % pitch
    alphaDot = (alphaDot*c_bar)/(2*V);     % AoA

    % Lift Coefficient
    C_L = Flight_Data.Aero.CLa*alpha +  Flight_Data.Aero.CLq*q_bar + Flight_Data.Aero.CLad*alphaDot +Flight_Data.Aero.CLde*de + Flight_Data.Aero.CLo;

    % Drag Coefficient 
    k = Flight_Data.Aero.k;
    CD0 = Flight_Data.Aero.Cdo;
    C_D = CD0 + k*CL^2;
end




