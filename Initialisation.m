% Function Initialisation
% This function asks user to select one of four flight configurations,
% followed by asking user to select one of 8 control input sets or a
% further two options, option 1, straight and level, to check that the trim
% function is working, or Option 10, direct control entry for the graphical
% user interface.

% Initialisation.m will extract the following outputs from AircraftData
% Flight_Data which includes aircraft specifications and control
% coefficients and other flight control parameters.
% X_0, the initial state vector.
% Extract GUI generated control inputs from Simulations
% U_input which is the user selected control input.
% T_input which is the time vector corresponding to the control input.
% Flight_Condition: one of four flight conditions (AircraftData)
% Flight_Simulation: one of 10 flight simulations (Simulations)

% Group: Wingtip Warriors

function [Flight_Data, X_0, X0] = Initialisation()

    % File folder for aircraft data
    addpath('AircraftData/');

    % Prompt user for flight condition using a dialog box
    flight_condition = {'CG1 at 100kts', 'CG1 at 180kts', 'CG2 at 100kts',...
    'CG2 at 180kts'};
    [Flight_Condition, ~] = listdlg('PromptString', 'Choose Flight Condition:', ...
    'SelectionMode','single','ListString', flight_condition);

    % Load Flight_Data and State_Vector for the selected flight condition
    switch Flight_Condition
        case 1 
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            State_Vector = load ('AircraftData/ICs_PC9_nominalCG1_100Kn_1000ft.mat');
        case 2 
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            State_Vector = load ('AircraftData/ICs_PC9_nominalCG1_180Kn_1000ft.mat');
        case 3 
            Flight_Data = aero3560_LoadFlightDataPC9_CG2();
            State_Vector = load ('AircraftData/ICs_PC9_CG2_100Kn_1000ft.mat');
        case 4
            Flight_Data = aero3560_LoadFlightDataPC9_CG2();
            State_Vector = load ('AircraftData/ICs_PC9_CG2_180Kn_1000ft.mat');
    end

    % Convert euler angles to quaternions and display results for checking
    X0 = State_Vector.X0;
    quaternion = e2q(State_Vector.X0(7:9));
    X_0 = [State_Vector.X0(1:6); quaternion; State_Vector.X0(10:12)];
end


