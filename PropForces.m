% File: PropForces.m
%
% Description: Compute propulsion power available at the current altitude
% and the thrust produced along the +x (body) axis. Uses the assignment
% model P_max = P_max,SL * (1.1324*σ - 0.1324), with σ = ρ/ρ_SL, and
% T = η * (P_max * δ_T) / V. Throttle δ_T ∈ [0,1].
%
% Instructions to the user: Call from the force/moment build (e.g.,
% StateRates.m) to add thrust in the +x_b direction. Requires
% FlowProperties.m and Flight_Data.Prop fields P_max (W) and η (–).
% Uses sea-level density from Flight_Data.Atmo if available, else 1.225 kg/m³.

function [P_max, T] = PropForces(U, x, Flight_Data, xDot)

    % Extract throttle and efficiency
    delta_T = U(1);                            % throttle fraction [0..1]
    eta     = getField(Flight_Data.Prop, 'eta', 1.0);

    % Flow properties and speed
    [rho, ~] = FlowProperties(x, Flight_Data); % air density [kg/m^3]
    u = x(1); v = x(2); w = x(3);
    V = sqrt(u^2 + v^2 + w^2);
    V_safe = max(V, 0.5);                      % guard very low speeds [m/s]

    % Density ratio and sea-level density
    rho_SL = getField(Flight_Data.Atmo, 'rho0', getField(Flight_Data.Atmo, 'rho_SL', 1.225));
    sigma  = rho / rho_SL;

    % Power available model at altitude
    P_max_SL = getField(Flight_Data.Prop, 'P_max', getField(Flight_Data.Prop, 'Pmax', 0));  % Watts
    coeff1 = 1.1324;
    coeff2 = 0.1324;
    P_max  = P_max_SL * (coeff1*sigma - coeff2);   % Watts
    P_max  = max(P_max, 0);                         % no negative power

    % Thrust along +x_b (scalar). If needed as vector, use [T;0;0].
    T = eta * (P_max * delta_T) / V_safe;          % Newtons
end

% Helper: safely get a struct field with a default
function val = getField(S, name, defaultVal)
    if isfield(S, name)
        val = S.(name);
    else
        val = defaultVal;
    end
end