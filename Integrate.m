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

    % Predict total increment in x across timestep as a weighted average
    X_new = X + (1/6)*(An + 2*Bn + 2*Cn + Dn);    % prediction for x at t_k+1

    % Need to normalise quaternion at each timestep
    quat = X_new(7:10);
    X_new(7:10) = quat/norm(quat);
end