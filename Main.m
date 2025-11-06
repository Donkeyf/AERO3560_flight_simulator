% AERO3560 Flight Mechanics 1
% Assignment 3: Wingtip Warriors

% Description: The purpose of this project and code is a flight controller
% for the PC-9, military trainer for a set of eight maneouvres including
% perturbations, turns, rolls and sideslip steady heading.

% Instructions to the user: Select 'Editor', click 'run' and 
% follow the prompts.

% Clear the workspace, command window and close all figures
clear; clc; close all;

% Initialise the Flight Data 
[Flight_Data, X0] = Initialisation();

% Select Manoeuvre to Perform & Generate Control Array
[U, time] = Controls();

% Extracting timestep for integration
dt = time(2) - time(1);

% Trim aircraft for Steady Level Flight
[Xtrim, Utrim, alpha] = Trim(Flight_Data, X0);

% Initialising states array & adding initial state
X = zeros(length(X0),length(time));
X(:,1) = X0;

% Initialising state to loop with
X_i = X0;

% Adding trim settings to control array
U = Utrim + U;

% Loop through time array and integrate at each timestep
for i = 1:length(time)
    % Timestep specific control vector
    U_i = U(:,i);

    % Integrate state rates & update state
    X_new = Integrate(Flight_Data,X_i,U_i,dt);

    % Save new state to array and update
    X(:,i) = X_new;
    X_i = X_new;
end

% Plot Data
PlotData(time, X, U)







