function Xdot = StateRates(Flight_Data, X, U) 
    % Intial Angular Rates Guess
    alpha_dot = 0;
    beta_dot = 0;

    % Initialise Rates
    Xdot = zeros(size(X));

    % Solver Settings
    max = 100;
    i = 1;
    error = 1;
    tol = 1e-9;

    % Loop Through for Angular Rates Convergence
    while error > tol && i < max
        % Extract states from state vector
        u = X(1);
        v = X(2);
        w = X(3);
        p = X(4);
        q = X(5);
        r = X(6);
        q0 = X(7);
        q1 = X(8);
        q2 = X(9);
        q3 = X(10);

        % Inertial Coefficients
        C = inertial_coefficients(Flight_Data);

        % Compute external forces in body frame
        W = Gravity(FlightData, X);           % Gravity forces
        [F_B, M_B] = BodyForces(FlightData, X, U, Xdot);    % Aerodynamic forces

        % Velocity rates
        u_dot = (1/FlightData.Inertial.m) * (W(1) + F_B(1)) + r*v - q*w;
        v_dot = (1/FlightData.Inertial.m) * (W(2) + F_B(2)) - r*u + p*w;
        w_dot = (1/FlightData.Inertial.m) * (W(3) + F_B(3)) + q*u - p*v;

        % Assume thrust force acts purely in x and along the centre of mass, so
        % does not generate moments in any of x, y, or z directions
        M_Tx = 0;
        M_Ty = 0;
        M_Tz = 0;

        % Moments
        L = M_B(1) + M_Tx;
        M = M_B(2) + M_Ty;
        N = M_B(3) + M_Tz;

        % Body rate rates
        p_dot = C(4)*p*q + C(5)*q*r + C(2)*L + C(3)*N;
        q_dot = C(8)*p*r - C(7)*(p^2 - r^2) + C(6)*M;
        r_dot = C(10)*p*q - C(4)*q*r + C(3)*L + C(9)*N;

        % Quaternion rates
        q0_dot = -1/2*(q1*p + q2*q + q3*r);
        q1_dot = 1/2*(q0*p - q3*q + q2*r);
        q2_dot = 1/2*(q3*p + q0*q - q1*r);
        q3_dot = -1/2*(q2*p - q1*q - q0*r);

        % Compute the direction cosine matrix representing the earth to body frame
        C_be = DCM(X);
        C_eb = C_be';   % Body-to-Earth = Inverse

        % Position rates in the Earth frame
        pos_dot = C_eb * [u; v; w];

        % Extract the individual position rates
        xe_dot = pos_dot(1);
        ye_dot = pos_dot(2);
        ze_dot = pos_dot(3);

        % Concatenate into state vector derivative
        Xdot = [u_dot; v_dot; w_dot; p_dot; q_dot; r_dot; q0_dot; q1_dot; q2_dot; q3_dot; xe_dot; ye_dot; ze_dot];

        % Use the updated state rates to compute the angular rates
        [alphadot_new, betadot_new] = AngularRates(X, xDot);

        % Compute the error in angular rates from the previous iteration
        error_alphadot = abs(alphadot_new - alpha_dot);
        error_betadot = abs(betadot_new - beta_dot);

        % Use the maximum error in alpha and beta dot as the iteration error
        error = max([error_alphadot, error_betadot]);

        % Update the angular rates using the new values
        alpha_dot = alphadot_new;
        beta_dot = betadot_new;

        % Update the counter at each iteration
        i = i + 1;
    end
end

function [C] = inertial_coefficients(Flight_Data)
    % Extract the inertial field and properties 
    Ixx = Flight_Data.Inertial.Ixx;
    Iyy = Flight_Data.Inertial.Iyy;
    Izz = Flight_Data.Inertial.Izz;
    Ixz = Flight_Data.Inertial.Ixz;

    % Inertial coefficients
    C0 = Ixx*Izz - Ixz^2;
    C1 = Izz/C0;
    C2 = Ixz/C0;
    C3 = C2*(Ixx - Iyy + Izz);
    C4 = C1*(Iyy-Izz) - C2*Ixz;
    C5 = 1/Iyy;
    C6 = C5*Ixz;
    C7 = C5*(Izz - Ixx);
    C8 = Ixx/C0;
    C9 = C8*(Ixx-Iyy)+C2*Ixz;

    % Store values
    C = [C0, C1, C2, C3, C4, C5, C6, C7, C8, C9];
end