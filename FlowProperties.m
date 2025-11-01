function [rho, Q] = FlowProperties(Flight_Data, X)
% Calculates the air density and dynamic pressure for the current altitude
% and flight speed.
%
% Outputs:
% Q     - Dynamic Pressure (Pascals)
% rho   - Air Density (kg/m^3)
    R = 287.05;                             % J/kgK - Gas Constant of Air
    h = -X(end);                            % m - Current Altitude
    V = norm(X(1:3));                       % m/s - Current Velocity
    P_sls = 101325;                         % Pa - Sea Level Pressure
    T_sls = 288.15;                         % K - Sea Level Temperature
    L = -6.5/1000;                          % K/m - Lapse Rate
    g = Flight_Data.Inertial.g;             % m/s^2 - Gravity Acceleration

    % Temp. & Pressure Change Due to Altitude
    T = T_sls + L*h;
    P = P_sls*(1 + (L/T_sls)*h)^(-g/(R*L));

    % Flow Properties
    rho = P/(R*T);
    Q = 0.5*rho*V^2;
end