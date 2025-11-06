%% Manoeuver Planning
% Run Main.m select CG1 at 180knots first
%% Steady-Heading Sideslip
% Sideslip Angle Value
beta = 5*pi/180;

% A Matrix
% Aerodynamic Terms
C_L = Flight_Data.Aero.CLo + alpha*Flight_Data.Aero.CLa;
C_Ydr = Flight_Data.Aero.Cydr;
C_lda = Flight_Data.Aero.Clda;
C_ldr = Flight_Data.Aero.Cldr;
C_nda = Flight_Data.Aero.Cnda;
C_ndr = Flight_Data.Aero.Cndr;

A = [C_L, 0, C_Ydr; 0, C_lda, C_ldr; 0, C_nda, C_ndr];

% RHS
% Aerodynamic Terms
C_Yb = Flight_Data.Aero.Cyb;
C_lb = Flight_Data.Aero.Clb;
C_nb = Flight_Data.Aero.Cnb;

RHS = [-C_Yb*beta; -C_lb*beta; -C_nb*beta];

% Solving for deflections:
trim = A\RHS;
trim = rad2deg(trim);


