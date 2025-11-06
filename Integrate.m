% Implements a fourth-order Runge-Kutta integration scheme to propagate the
% aircraft state.
%
% Inputs
% Flight_Data - A structure storing all aerodynamic, geometric, inertial,
% propulsive information required to simulate the aircraft dynamics, also
% includes the maximum control surface deflections.
% X - Current aircraft state vector.
% U - Aircraft control vector.
% dt - Integration timestep. [s]
%
% Outputs
% X_new - Aircraft state vector at the next timestep.

function [X_new] = Integrate(Flight_Data, X, U, dt)
    % X_dot at time t_k
    x_1dot = StateRates(Flight_Data, X, U);             % First increment
    An = x_1dot*dt;

    % X_dot at time t_k + 0.5
    x_2dot = StateRates(Flight_Data, X + An/2, U);      % Second increment
    Bn = x_2dot*dt;

    % X_dot at time t_k + 0.5
    x_3dot = StateRates(Flight_Data, X + Bn/2, U);      % Third increment
    Cn = x_3dot*dt;

    % X_dot at time t_k + 1
    x_4dot = StateRates(Flight_Data, X + Cn/2, U);      % Fourth increment
    Dn = x_4dot*dt;

    % New State Vector
    X_new = X + (1/6)*(An + 2*Bn + 2*Cn + Dn);    

    % Normalise Quaternions
    quat = X_new(7:10);
    X_new(7:10) = quat/norm(quat);
end