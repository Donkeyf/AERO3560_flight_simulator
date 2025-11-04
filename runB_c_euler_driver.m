clc; clear; close all

addpath(pwd);                  % repo root

CGs     = ["CG1","CG2"];
V_knots = [100, 180];


[FlightData_CG1] = aero3560_LoadFlightDataPC9_nominalCG1();
[FlightData_CG2] = aero3560_LoadFlightDataPC9_CG2();

IC_CG2_100kn = load("AircraftData/ICs_PC9_CG2_100Kn_1000ft.mat");
IC_CG2_180kn = load("AircraftData/ICs_PC9_CG2_180Kn_1000ft.mat");
IC_CG1_180kn = load("AircraftData/ICs_PC9_nominalCG1_180Kn_1000ft.mat");
IC_CG1_100kn = load("AircraftData/ICs_PC9_nominalCG1_100Kn_1000ft.mat");

Lon_CG2_100kn = load("AircraftData/Longitudinal_Matrices_PC9_CG2_100Kn_1000ft.mat");
Lon_CG2_180kn = load("AircraftData/Longitudinal_Matrices_PC9_CG2_180Kn_1000ft.mat");
Lon_CG1_100kn = load("AircraftData//Longitudinal_Matrices_PC9_nominalCG1_100Kn_1000ft.mat");
Lon_CG1_180kn = load("AircraftData//Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat");

mat_CG2_100kn = Get_Matrix(FlightData_CG2, Lon_CG2_100kn, IC_CG2_100kn);
mat_CG2_180kn = Get_Matrix(FlightData_CG2, Lon_CG2_180kn, IC_CG2_180kn);
mat_CG1_100kn = Get_Matrix(FlightData_CG1, Lon_CG1_100kn, IC_CG1_100kn);
mat_CG1_180kn = Get_Matrix(FlightData_CG1, Lon_CG1_180kn, IC_CG1_180kn);

mat = [mat_CG1_100kn, mat_CG2_100kn; mat_CG1_180kn, mat_CG2_180kn];


% Load Longitudinal matrices for this CG / V
%f_lon = sprintf('AircraftData/Longitudinal_Matrices_PC9_%s_%dKn_1000ft.mat', token, V_knots(i));
%L     = load(f_lon,'A_lon','B_lon');
A_lon = mat_CG2_100kn.A_Lon; 
B_lon = mat_CG2_100kn.B_Lon;

% Trim perturbations (linear model starts at Δx=0, Δu=0)
U0 = zeros(4,1);                     % [δT; δe; δa; δr]
X0 = zeros(size(A_lon,1),1);         % n×1

% Simulation parameters
dt_s = 0.01; 
T_end = 20; 
pulse_s = 0.5; % s (elevator held)
defl_deg = 5; % deg (elevator magnitude)

fprintf('=== Part B(c): Euler impulse simulations ===/n');
for i = 1:2
    for j = 1:2

        %fprintf('Case: V=%3d kt, %s ... ', V_knots(i), CGs(j));

        FD = mat(i, j).FD;
        U0 = mat(i, j).U0;
        X0 = mat(i, j).X0;
        A_lat = mat(i,j).A_Lat;
        B_lat = mat(i,j).B_Lat;
        A_lon = mat(i,j).A_Lon;
        B_lon = mat(i,j).B_Lon;

        % After elevator call
        [t, Xlon_elev, Ulon_elev] = eulerImpulseSim(A_lon, B_lon, 2, defl_deg, pulse_s, T_end, dt_s);
        if size(Xlon_elev,1) ~= numel(t), Xlon_elev = Xlon_elev.'; end
        if size(Ulon_elev,1) ~= numel(t), Ulon_elev = Ulon_elev.'; end

        % If you keep lateral calls for later use:
        [~, Xlat_ail, Ulat_ail] = eulerImpulseSim(A_lat, B_lat, 1, defl_deg, pulse_s, T_end, dt_s);
        if size(Xlat_ail,1) ~= numel(t), Xlat_ail = Xlat_ail.'; end
        if size(Ulat_ail,1) ~= numel(t), Ulat_ail = Ulat_ail.'; end

        [~, Xlat_rud, Ulat_rud] = eulerImpulseSim(A_lat, B_lat, 2, defl_deg, pulse_s, T_end, dt_s);
        if size(Xlat_rud,1) ~= numel(t), Xlat_rud = Xlat_rud.'; end
        if size(Ulat_rud,1) ~= numel(t), Ulat_rud = Ulat_rud.'; end

        % Pack results
        S(i,j).t = t;
        S(i,j).lon.elev.X = Xlon_elev;  S(i,j).lon.elev.U = Ulon_elev;
        S(i,j).lat.ail.X  = Xlat_ail;   S(i,j).lat.ail.U  = Ulat_ail;
        S(i,j).lat.rud.X  = Xlat_rud;   S(i,j).lat.rud.U  = Ulat_rud;
        S(i,j).meta = struct('V', V_knots(i), 'CG', CGs(j));

        fprintf('done./n');
    end
end

save('PartB_c_soln.mat', 'S');
fprintf('Saved results to PartB_c_soln.mat/n');

% Sanity plot so something shows immediately
figure;
plot(t, rad2deg(S(1,1).lon.elev.X(:,3))); grid on
title('Quick check: q response (elevator) — CG1 @ 100 kt');
ylabel('q [deg/s]'); xlabel('t [s]');




% File: impulseResponseLinear.m

% Inputs:
%   A, B      : state and input matrices
%   chan      : control channel index to excite (1-based)
%   mag_deg   : input magnitude in degrees (for surfaces); throttle left as-is
%   pulse_s   : duration (s) for which the input is held at mag
%   T_end     : total simulation time (s)
%   dt        : time step (s)
%
% Outputs:
%   t         : 1×N time vector
%   X         : N×n state history (rows = time)
%   U         : N×m input history (rows = time)

function [t, X, U] = eulerImpulseSim(A, B, chan, mag_deg, pulse_s, T_end, dt)

    % Time grid
    t = 0:dt:T_end;
    N = numel(t);

    % Dimensions
    n = size(A, 1);   % number of states
    m = size(B, 2);   % number of inputs

    % Preallocate histories (rows = time)
    X = zeros(N, n);          % start at Δx = 0
    U = zeros(N, m);          % baseline Δu = 0

    % Build control pulse on the selected channel
    u_mag = deg2rad(mag_deg);
    U(t <= pulse_s, chan) = u_mag;

    % Explicit Euler integration
    for k = 1:N-1
        % x_dot = A x + B u at time step k
        xdot      = (A * X(k,:).' + B * U(k,:).').';  % 1×n row
        % Euler update
        X(k+1,:)  = X(k,:) + dt * xdot;
    end
end


