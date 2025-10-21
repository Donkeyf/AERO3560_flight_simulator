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

function [Forces_b, Moments_b] = BodyForces(x, U, Flight_Data, xDot)

    % State components (body axes)
    u = x(1);  v = x(2);  w = x(3);
    p = x(4);  q = x(5);  r = x(6);

    % State derivatives (if not provided, assume zeros)
    if nargin < 4 || isempty(xDot)
        xDot = zeros(size(x));
    end
    uDot = xDot(1);  vDot = xDot(2);  wDot = xDot(3); %#ok<NASGU>

    % Geometry and speed
    S = Flight_Data.Geo.S;
    b = Flight_Data.Geo.b;
    c = Flight_Data.Geo.c;
    V = max(sqrt(u^2 + v^2 + w^2), 1e-8);          % guard very small speeds

    % Non-dimensional rate parameters
    p_bar = (p * b) / (2 * V);
    q_bar = (q * c) / (2 * V);
    r_bar = (r * b) / (2 * V);

    % Flow and kinematics
    [~, Q] = FlowProperties(x, Flight_Data);       % dynamic pressure [Pa]
    [alpha, beta] = AeroAngles(x);                 % angles [rad]
    [alphaDot, betaDot] = AngularRates(x, xDot);   % angle rates [rad/s]

    % Controls: U = [delta_T; delta_e; delta_a; delta_r]
    de = U(2);
    da = U(3);
    dr = U(4);

    % Shorthand for aero coefficients
    A = Flight_Data.Aero;

    % Resolve naming variations once (CL0 vs CLo, CD0 vs CDo, CY* vs Cy*)
    CL0 = iff(isfield(A,'CL0'), A.CL0, iff(isfield(A,'CLo'), A.CLo, 0));
    CD0 = iff(isfield(A,'CD0'), A.CD0, iff(isfield(A,'CDo'), A.CDo, 0));

    CYb  = iff(isfield(A,'CYb'),  A.CYb,  iff(isfield(A,'Cyb'),  A.Cyb,  0));
    CYbd = iff(isfield(A,'CYbd'), A.CYbd, iff(isfield(A,'Cybd'), A.Cybd, 0));
    CYr  = iff(isfield(A,'CYr'),  A.CYr,  iff(isfield(A,'Cyr'),  A.Cyr,  0));
    CYp  = iff(isfield(A,'CYp'),  A.CYp,  iff(isfield(A,'Cyp'),  A.Cyp,  0));
    CYda = iff(isfield(A,'CYda'), A.CYda, iff(isfield(A,'Cyda'), A.Cyda, 0));
    CYdr = iff(isfield(A,'CYdr'), A.CYdr, iff(isfield(A,'Cydr'), A.Cydr, 0));

    % Lift and drag (wind/stability axes)
    % CL = CL0 + CLa*alpha + CLad*alphaDot + CLq*q_bar + CLde*de
    CL = CL0 ...
       + A.CLa  * alpha ...
       + A.CLad * alphaDot ...
       + A.CLq  * q_bar ...
       + A.CLde * de;

    % Drag polar: CD = CD0 + k*CL^2
    CD = CD0 + A.k * (CL^2);

    % Sideforce (wind/stability axes)
    CY = CYb * beta + CYbd * betaDot + CYr * r_bar + CYp * p_bar + CYda * da + CYdr * dr;

    % Forces in wind axes (x_w forward, y_w right, z_w down)
    D = CD * Q * S;
    L = CL * Q * S;
    Y = CY * Q * S;
    F_w = [-D; Y; -L];                        % [X_w; Y_w; Z_w]

    % Rotate wind → body: C_y(alpha) then C_z(beta)
    T_wb = C_y(alpha) * C_z(beta);
    Forces_b = T_wb * F_w;                    % [Fx; Fy; Fz] body axes

    % Rolling, pitching, yawing moment coefficients (body axes)
    % Use typical field names; if your loader uses different, add fields.
    Cl0 = iff(isfield(A,'Cl0'), A.Cl0, 0);
    Cm0 = iff(isfield(A,'Cm0'), A.Cm0, 0);
    Cn0 = iff(isfield(A,'Cn0'), A.Cn0, 0);

    Cl = Cl0 ...
       + A.Clb  * beta ...
       + A.Clbd * betaDot ...
       + A.Clr  * r_bar ...
       + A.Clp  * p_bar ...
       + A.Clda * da ...
       + A.Cldr * dr;

    Cm = Cm0 ...
       + A.Cma  * alpha ...
       + A.Cmad * alphaDot ...
       + A.Cmq  * q_bar ...
       + A.Cmde * de;

    Cn = Cn0 ...
       + A.Cnb  * beta ...
       + A.Cnbd * betaDot ...
       + A.Cnr  * r_bar ...
       + A.Cnp  * p_bar ...
       + A.Cnda * da ...
       + A.Cndr * dr;

    % Moments in body axes
    L_roll  = Cl * Q * S * b;                 % +x_b (roll)
    M_pitch = Cm * Q * S * c;                 % +y_b (pitch)
    N_yaw   = Cn * Q * S * b;                 % +z_b (yaw)

    Moments_b = [L_roll; M_pitch; N_yaw];
end

% Local inline helper to avoid verbose isfield blocks
function out = iff(cond, a, b)
    if cond, out = a; else, out = b; end
end