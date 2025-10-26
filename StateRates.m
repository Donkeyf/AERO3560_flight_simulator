function Xdot = StateRates(W, X, F_b, Flight_Data)
Ixx = Flight_Data.Inertial.Ixx;
Iyy = Flight_Data.Inertial.Iyy;
Izz = Flight_Data.Inertial.Izz;
Ixz = Flight_Data.Inertial.Ixz;

m = Flight_Data.Inertial.m;
g = Flight_Data.Inertial.g;

% state variables
% velocitie rate
u = X(1);
v = X(2);
w = X(3);

% body rate rate
p = X(4);
q = X(5); 
r = X(6);

% quaternion attitude
q0 = X(7);
q1 = X(8);
q2 = X(9);
q3 = X(10);

% euler angles
e = q2e(X(7:10)');
phi = e(1);
theta = e(2);

% positions
x_e = X(11);
y_e = X(12);
z_e = X(13);

% DCM from earth to body
F_g = Gravity(W, X(7:10)', Flight_Data);
C_be = DCM(X(7:10)');
F_gb = C_be * F_g;

Fx = F_b(1, 1) + F_gb(1);
Fy = F_b(2, 1) + F_gb(2);
Fz = F_b(3, 1) + F_gb(3);           % Changed Fy to 'Fz' (CLW)
L = F_b(1, 1);                      % Changed index in position 2 to '1' (CLW)
M = F_b(2, 1);                      % Changed index in position 2 to '1' (CLW)
N = F_b(3, 1);                      % Changed index in position 2 to '1' (CLW)

% velocities
u_dot = r * v - q * w - g * sin(theta) + Fx/m;
v_dot = -r * u + p * w + g * sin(phi) * cos(theta) + Fy/m;
w_dot = q * u - p * v + g * cos(phi) * cos(theta) + Fz/m;

% rotation rates
% Compute constants
C0 = Ixx * Izz - Ixz^2;
C1 = Izz/C0;
C2 = Ixz/C0;
C3 = C2 * (Ixx - Iyy + Izz);
C4 = C1 * (Iyy - Izz) - C2 * Ixz;
C5 = 1/Iyy;
C6 = C5 * Ixz;
C7 = C5 * (Izz - Ixx);
C8 = Ixx/C0;
C9 = C8 * (Ixx - Iyy) + C2 * Ixz;

p_dot = C3 * p * q + C4 * q * r + C1 * L + C2 * N;
q_dot = C7 * p * r - C6 * (p^2 - r^2) + C5 * M;
r_dot = C9 * p * q - C3 * q * r + C2 * L + C8 * N;

% attitude rates
q0_dot = -0.5 * (q1 * p + q2 * q + q3 * r);
q1_dot = 0.5 * (q0 * p - q3 * q + q2 * r);
q2_dot = 0.5 * (q3 * p + q0 * q - q1 * r);
q3_dot = -0.5 * (q2 * p - q1 * q - q0 * r);

% position rate
C_eb = C_be';
pos_e = C_eb * [u, v, w]';

xe_dot = pos_e(1); 
ye_dot = pos_e(2); 
ze_dot = pos_e(3); 

Xdot = [u_dot, v_dot, w_dot, p_dot, q_dot, r_dot, q0_dot, q1_dot, q2_dot, q3_dot, xe_dot, ye_dot, ze_dot]';

end