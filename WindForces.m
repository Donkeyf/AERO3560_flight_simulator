% Calculates the lift and drag coefficients from the aircraft state,
% control vector and state rates using linear approximation for lift and
% simple drag model.
% 
% Inputs
% X - Aircraft state vector.
% U - Aircraft control vector.
% Flight_Data - A structure storing all aerodynamic, geometric, inertial,
% propulsive information required to simulate the aircraft dynamics, also
% includes the maximum control surface deflections.
% xDot - State rates vector.

function [C_L, C_D] = WindForces(X, U, Flight_Data, xDot)
    % Extract states from state vector and control vector
    q = X(5);
    de = U(2);
    V = norm(X(1:3));

    % Compute velocity, angle of attack and sideslip angle
    [alpha, ~] = AeroAngles(X);
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
    C_D = CD0 + k*C_L^2;
end




