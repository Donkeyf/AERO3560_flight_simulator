% AERO3560 Flight Mechanics 1
% Assignment 3: Wingtip Warriors

% Description: The purpose of this project and code is a flight controller
% for the PC-9, military trainer for a set of eight maneouvres including
% perturbations, turns, rolls and sideslip.

% Instructions to the user: Select 'Editor', click 'run' and 
% follow the prompts.

% Clear the workspace, command window and close all figures
clear; clc; close all;

% Open the graphical user interface
% File folder for Control GUI
%    addpath('Control GUI/__MACOSX/Control_GUI_updated_AB24/');
%    varargout = Control_GUI_full(varargin);

% Initialise the Flight Data and selected simulation option or manual
% control option
[Flight_Data, X_0, X0, U_input, T_input, Flight_Condition, ...
    Flight_Simulation] = Initialisation();
disp(X_0);

% Trim aircraft
% Extract required data VelTrim, AltTrim and PsiTrim from X0
VelTrim = sqrt(X0(1)^2 + X0(2)^2 + X0(3)^2);
AltTrim = X0(12);
PsiTrim = X0(9);

% Trim aircraft
[X_0_trim, U_input_trim] = Trim(VelTrim,AltTrim,PsiTrim,Flight_Data);
disp(X_0_trim);

% Add path to file folder
% addpath('AircraftData');

% Matrices to recieve state rates X_data, U_data and time_data
X_data = {};                % State rates for each time time step
U_data = {};                % Control inputs including as varied in order to trim aircraft
time_data = {};             % Time vector which Total time divided by dt (time step)

% Total time and time step
dt = 0.01;                  % Time step in seconds
total_time = 200;           % Total time in seconds for simulation
time = 0:dt:total_time;     % Time vector
time_data{1} = time;        % Time vector stored

% Set up solution matrices for simulation
X = zeros(length(X_0_trim), length(time));
U = zeros (length(U_input_trim), length(time));
X(:,1) = X_0_trim;          % Inital state vector now trimmed
U(:,1) = U_input_trim;      % Initial control input now trimmed

% Loop through simulation
for i = 2: length(time)
    U_temp = Controls(i,U_input,U_input_trim); % Check Control
    % Integrate at this time step to get new state vector
    X(:,i) = Integrate(Flight_Data, X(:,i-1), U_temp, time(i), dt);
    U(:,i) = U-temp;
end

% Copy results from the integration into matrices for plotting
X_data{1} = X;
U_data{1} = U;

% Plot the simulation results for each state rate variable against time
PlotData(X_data, U_data, time_data, Flight_Condition);






