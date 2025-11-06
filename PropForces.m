% Determines the propulsive force in the body axes for a given altitude and
% throttle setting.
% 
% Inputs
% Flight_Data - A structure storing all aerodynamic, geometric, inertial,
% propulsive information required to simulate the aircraft dynamics, also
% includes the maximum control surface deflections.
% X - Aircraft state vector.
% u -  Aircraft control vector.
%
% Outputs
% T - Propulsive force in the x_b direction. [N]

function T = PropForces(Flight_Data, X, u)
% Standard sea level atmospheric density
rho_SL = 1.2256;             % [kg/m^3]

% Propeller data
eta = Flight_Data.prop.eta;              % Propeller efficiency
P_SL_max = Flight_Data.prop.P_max;       % Maximum power at sea level [W]

% Extract/Determine aircraft speed and throttle setting 
V = norm(X(1:3));
delta_t = u(1);

% Calculate air density at given aircraft altitude
[rho, ~] = FlowProperties(Flight_Data,X);

% Ratio of air densities
sigma = rho/rho_SL;

% Maximum power at given altitude
P_max = P_SL_max*(1.1324*sigma - 0.1324);   % [W]

% Aircraft thrust at given airspeed
T = (eta*P_max/V)*delta_t;          % [N]

end