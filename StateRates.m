function Xdot = StateRates(Flight_Data, X, U) 
% Initialise values for angular rates
alpha_dot = 0;
beta_dot = 0;

% Initialise zero rates for first iteration
X_dot = zeros(size(X));

% Initialise settings for convergence iterations
iter_max = 2;     % Max number of iterations
counter = 1;        % Iteration counter
error = 1;          % Arbitrarily large number for initial error
eps = 1e-9;         % Error tolerance

% Loop for convergence on angular rates
while error > eps && counter < iter_max

    % Compute the state rates with the previous guess at the rates and
    % state vectors
    Xdot = compute_rates(Flight_Data, X, X_dot, U);

    % Use the updated state rates to compute the angular rates
    [ad_kp1, bd_kp1] = AngularRates(X, X_dot);

    % Compute the error in angular rates from the previous iteration
    error_ad = abs(ad_kp1 - alpha_dot);
    error_bd = abs(bd_kp1 - beta_dot);

    % Use the maximum error in alpha and beta dot as the iteration error 
    error = max([error_ad, error_bd]);

    % Update the angular rates using the new values
    alpha_dot = ad_kp1;
    beta_dot = bd_kp1;

    % Break the loop if the maximum number of iterations are exceeded
    if counter > iter_max
        warning('No convergence for State Rate Iteration')
        break
    end

    % Update the counter at each iteration
    counter = counter + 1;

end



function x_dot = compute_rates(Flight_Data, X, x_dot, u_control)
% Compute the time derivatives of each state variable, using quaternions to
% keep track of the aircrafts attitude. Standard equations are used to
% calculate the rates for each element of the state vector, with velocity,
% body rates, quaternions and positions.
% Inputs:
    % Flight_Data - aircraft flight data structure
    % X - aircraft state vector 
    % x_dot - state rate vector at previous iteration
    % u_control - aircraft control state vector
% Returns:
    % x_dot - aircraft state rate vector

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
x_e = X(11);
y_e = X(12);
z_e = X(13);

% Determine inertial coefficients from flight data for moment calculation
C = InertialCoefficients(Flight_Data);

% Compute external forces in body frame
F_gb = Gravity(Flight_Data, X);           % Gravity forces
[F_A, M_A] = BodyForces(Flight_Data, X, u_control, x_dot);    % Aerodynamic forces

% Velocity rates
u_dot = (1/Flight_Data.Inertial.m) * (F_gb(1) + F_A(1)) + r*v - q*w;
v_dot = (1/Flight_Data.Inertial.m) * (F_gb(2) + F_A(2)) - r*u + p*w;
w_dot = (1/Flight_Data.Inertial.m) * (F_gb(3) + F_A(3)) + q*u - p*v;

% Assume thrust force acts purely in x and along the centre of mass, so
% does not generate moments in any of x, y, or z directions
M_Tx = 0;
M_Ty = 0;
M_Tz = 0;

% Moments
L = M_A(1) + M_Tx;
M = M_A(2) + M_Ty;
N = M_A(3) + M_Tz;

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
C_eb = C_be';   % Body to earth is the inverse (transpose for rotation matrix)

% Position rates in the Earth frame
pos_dot = C_eb * [u; v; w];

% Extract the individual position rates
xe_dot = pos_dot(1);
ye_dot = pos_dot(2);
ze_dot = pos_dot(3);

% Concatenate into state vector derivative
x_dot = [u_dot; v_dot; w_dot; p_dot; q_dot; r_dot; q0_dot; q1_dot; q2_dot; q3_dot; xe_dot; ye_dot; ze_dot];

end

end

function [C] = InertialCoefficients(Flight_Data)
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