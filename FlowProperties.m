function [rho, Q] = FlowProperties(X,Flight_Data)
% Calculates the air density and dynamic pressure for the current altitude
% and flight speed
    R = 287;                                % J/kgK - Gas Constant of Air
    h = X(end);                             % m - Current Altitude
    V = sqrt(X(1)^2 + X(2)^2 + X(3)^2);     % m/s - Current Velocity
    P_sls = 101325;                         % Pa - Sea Level Pressure
    T_sls = 288.15;                         % K - Sea Level Temperature
    L = -6.5/1000;                          % K/m - Lapse Rate
    g = Flight_Data.g;                      % m/s^2 - Gravity Acceleration

    T = T_sls + L*h;
    P = P_sls*(1 + (L/T_sls)*h)^(-g/(R*L));
    rho = P/(R*T);
    Q = 0.5*rho*V^2;
end