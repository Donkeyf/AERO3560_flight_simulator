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

function [P_max, T] = PropForces(U, x, Flight_Data)

    % Extract throttle and efficiency
    delta_T = U(1);                            % throttle fraction [0..1]
    eta     = Flight_Data.Prop.eta;

    % Flow properties and speed
    [rho, ~] = FlowProperties(Flight_Data, x); % air density [kg/m^3]
    V = sqrt(u^2 + v^2 + w^2);

    % Density ratio and sea-level density
    rho_SL = 1.225;
    sigma  = rho / rho_SL;

    % Power available model at altitude
    P_max_SL = Flight_Data.Prop.P_max;
    P_max  = P_max_SL * (1.1324*sigma - 0.1324);   % Watts

    % Thrust along +x_b (scalar). If needed as vector, use [T;0;0].
    T = eta * (P_max * delta_T) / V;          % Newtons
end