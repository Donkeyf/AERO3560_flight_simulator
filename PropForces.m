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

function T = PropForces(Flight_Data, X, u)
% Compute propulsion forces directly in the body axes according to a
% simple model
% Refer lecture 9B slide 13
% Inputs:
    % FlightData - Aircraft flight data structure
    % X - state vector
    % u - control vector
% Returns:
    % T - thrust magnitude in x_b axis

% Standard sea level atmospheric density
rho_SL = 1.2256;             % [kg/m^3]

% Pull out propulsive values from aircraft FlightData structure
prop = Flight_Data.Prop;

% Propeller data
eta = prop.eta;                     % Propeller efficiency
P_SL_max = prop.P_max;              % Maximum power at sea level [W]

% Determine aircraft speed and altitude from state vector, and throttle
% setting from control vector
V = norm(X(1:3));
delta_t = u(1);

% Calculate air density [kg/m^3] given aircraft altitude
[rho, ~] = FlowProperties(Flight_Data,X);

% Ratio of air densities
sigma = rho/rho_SL;

% Maximum power at given altitude
P_max = P_SL_max*(1.1324*sigma - 0.1324);   % [W]

% Aircraft thrust at given airspeed
T = (eta*P_max/V)*delta_t;          % [N]

return