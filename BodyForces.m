% File: BodyForces.m
%
% Description: Compute aerodynamic forces and moments in the BODY axes.
% Lift (L), Drag (D) and Sideforce (Y) are formed in the wind/stability
% frame from coefficient models, then rotated into the body frame. Moments
% (L, M, N) are computed directly in the body axes.
%
% Instructions to the user: Called from the simulation loop by StateRates.
% Requires FlowProperties.m, AeroAngles.m, AngularRates.m and the rotation
% helpers C_y.m and C_z.m. Units are SI; angles in radians.

function [Forces_b, Moments_b] = BodyForces(Flight_Data, X, u, XDot)

    % Extract body rates
    p = X(4);
    q = X(5);
    r = X(6);
    V = norm(X(1:3));

    % Extracting control vector deflections
    de = u(2);
    da = u(3);
    dr = u(4);

    % Compute velocity, angle of attack and sideslip angle from velocity
    % components
    [alpha, beta] = AeroAngles(X);    
    [alpha_dot, beta_dot] = AngularRates(X, XDot);

    % Non-dimensionalise pitch, roll and yaw rates, as well as angular rates
    b = Flight_Data.Geo.b;           % Wing span
    c_bar = Flight_Data.Geo.c;       % Mean Chord
    p_bar = (p*b)/(2*V);            % roll
    q_bar = (q*c_bar)/(2*V);        % pitch
    r_bar = (r*b)/(2*V);            % yaw
    alpha_dot = (alpha_dot*c_bar)/(2*V);    % AoA
    beta_dot = (beta_dot*b)/(2*V);          % Sideslip

    % Lift and Drag coefficients
    [CL, CD] = WindForces(X, u, Flight_Data, XDot);
    T = PropForces(Flight_Data,X, u);
    [~, Q] = FlowProperties(Flight_Data, X);

    % Thrust force acts purely in x direction
    F_T = T*[1; 0; 0];

    % Sideforce coefficient
    CY = Flight_Data.Aero.Cyb*beta + Flight_Data.Aero.Cyp*p_bar + Flight_Data.Aero.Cyr*r_bar + Flight_Data.Aero.Cyda*da + Flight_Data.Aero.Cydr*dr + Flight_Data.Aero.Cybd*beta_dot;

    % Convert force coefficients to forces
    L = Q*Flight_Data.Geo.S*CL;
    D = Q*Flight_Data.Geo.S*CD;
    Y = Q*Flight_Data.Geo.S*CY;

    % Rotate from stability axes to body axes
    C_bs = C_y(alpha);

    % Overall body force, converted from stability axes to body axes
    Forces_b = F_T + C_bs*[-D; Y; -L];

    % Calculate moment coefficients
    CM = Flight_Data.Aero.Cmo + Flight_Data.Aero.Cma*alpha + Flight_Data.Aero.Cmq*q_bar + Flight_Data.Aero.Cmad*alpha_dot + Flight_Data.Aero.Cmde*de;
    CN = Flight_Data.Aero.Cnb*beta + Flight_Data.Aero.Cnp*p_bar + Flight_Data.Aero.Cnr*r_bar + Flight_Data.Aero.Cnda*da + Flight_Data.Aero.Cndr*dr + Flight_Data.Aero.Cnbd*beta_dot;
    Cl = Flight_Data.Aero.Clb*beta + Flight_Data.Aero.Clp*p_bar + Flight_Data.Aero.Clr*r_bar + Flight_Data.Aero.Clda*da + Flight_Data.Aero.Cldr*dr + Flight_Data.Aero.Clbd*beta_dot;

    % Convert moment coefficients to moments
    M = CM*Q*Flight_Data.Geo.S*Flight_Data.Geo.c;
    N = CN*Q*Flight_Data.Geo.S*Flight_Data.Geo.b;
    l = Cl*Q*Flight_Data.Geo.S*Flight_Data.Geo.b;

    % Overall body moment
    Moments_b = [l; M; N];
end