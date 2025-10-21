% File: WindForces.m
%
% Description: Compute Lift and Drag in the wind/stability frame from the
% current state, controls and aircraft data. Uses a simple drag polar
%   CD = CD0 + k * CL^2
% with dynamic effects embedded in CL via alphȧ and q̄ when available.
% Returns positive magnitudes:
%   Lift = +|L| (up in wind axis),  Drag = +|D| (along the flow).
%
% Instructions to the user: Call from the force/moment build when
% FlowProperties.m, AeroAngles.m and AngularRates.m are available.
% Inputs are state x = [u v w p q r q0 q1 q2 q3 x_e y_e z_e]^T,
% controls U = [δ_T; δ_e; δ_a; δ_r], Flight_Data with .Geo and .Aero.

function [Lift, Drag] = WindForces(x, U, Flight_Data, xDot)

    % State components (body axes)
    u = x(1);  v = x(2);  w = x(3);
    q_rate = x(5);                                 % pitch rate q [rad/s]

    % Optional state derivatives (for alphaDot); default to zeros if missing
    if nargin < 4 || isempty(xDot)
        xDot = zeros(size(x));
    end

    % Geometry and speed
    S = Flight_Data.Geo.S;
    c = Flight_Data.Geo.c;
    V = max(sqrt(u^2 + v^2 + w^2), 1e-8);          % guard very small speeds

    % Flow properties and kinematics
    [~, Q] = FlowProperties(x, Flight_Data);       % dynamic pressure [Pa]
    [alpha, ~] = AeroAngles(x);                    % [rad]
    [alphaDot, ~] = AngularRates(x, xDot);         % [rad/s]
    q_bar = (q_rate * c) / (2 * V);                % non-dimensional q

    % Controls (only elevator affects CL here)
    de = U(2);

    % Aerodynamic coefficients with robust field handling
    A = Flight_Data.Aero;

    % Zero-lift offset handling (prefer explicit CL0 if present)
    CL0 = getField(A,'CL0', getField(A,'CLo',[]));
    if isempty(CL0)
        % fallback via zero-lift angle if provided: CL0 = -CLa * alpha0
        alpha0 = firstAvailable(A, {'alpha0','alpha_o','alpha_0'}, 0);
        CL0 = - getField(A,'CLa',0) * alpha0;
    end

    % Lift-curve and dynamic terms
    CLa  = getField(A,'CLa',  0);
    CLad = getField(A,'CLad', 0);
    CLq  = getField(A,'CLq',  0);
    CLde = getField(A,'CLde', 0);

    % Drag polar terms
    CD0  = getField(A,'CD0', getField(A,'CDo', getField(A,'Cdo', 0)));
    k    = getField(A,'k', 0);

    % Coefficients
    CL = CL0 + CLa*alpha + CLad*alphaDot + CLq*q_bar + CLde*de;
    CD = CD0 + k*(CL^2);

    % Forces in wind/stability axes (positive magnitudes)
    Lift = CL * Q * S;                              % up in wind axes
    Drag = CD * Q * S;                              % along the flow
end

% Get a field or a default
function val = getField(S, name, defaultVal)
    if isfield(S, name)
        val = S.(name);
    else
        val = defaultVal;
    end
end

% Return the first existing field from a list, else default
function val = firstAvailable(S, names, defaultVal)
    val = [];
    for k = 1:numel(names)
        if isfield(S, names{k})
            val = S.(names{k});
            return
        end
    end
    val = defaultVal;
end






