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

function [Flight_Data, X_0, U_input, T_input, Flight_Condition, ...
    Flight_Simulation] = Initialisation()

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
    disp (State_Vector.X0);
    quaternion = e2q(State_Vector.X0(7:9));
    disp (quaternion);
    X_0 = [State_Vector.X0(1:6); quaternion; State_Vector.X0(10:12)];
    disp (X_0);

    % Select simulation choice: Present choice to the user
    simulation_selection = {'Trimmed flight check', ...
        '0.5 second 5deg elevator impulse', '0.5 second 5deg aileron impulse',...
        '0.5 second 5deg rudder impulse', '3.5g loop and return to level flight',...
        '2g zero sideslip turn', 'Steady-heading with sideslip 5deg', ...
        '4 point hesitation roll', 'Barrel roll'};

    [Flight_Simulation, ok] = listdlg ('PromptString','Make a selection:', ...
        'SelectionMode','single', 'ListString', simulation_selection);

    % Simulation selection and U control vector
    switch Flight_Simulation
        case 1
            data = load('Simulations/SteadyLevel_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;

        case 2
            data = load('Simulations/Elevator_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;

        case 3
            data = load('Simulations/Aileron_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;
 
        case 4
            data = load('Simulations/Rudder_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;

        case 5
            data = load('Simulations/3.5g_loop_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 6
            data = load('Simulations/2g_turn_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 7
            data = load('Simulations/5deg_sideslip_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 8
            data = load('Simulations/4point_hesitation_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 9
            data = load('Simulations/barrel_roll_U_input.mat');
            U_input = data.U_linear;
            T_input = data.T_linear;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');


    end
end


