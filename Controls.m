% File: Controls.m
%
% Description: Generate the control vector at the current time step by
% combining the trimmed controls (U_trim) with a time-scheduled input
% (U_input, T_input). Elevator, aileron and rudder schedules are assumed
% to be in degrees and are converted to radians. Throttle is a 0–1 fraction
% and is not converted. By default the schedule is treated as a delta to be
% added to the trim controls and is zero outside its active time window.
%
% Instructions to the user: This function is called inside the time loop
% in Main.m. Ensure Initialisation.m has loaded U_input and T_input.

function [U, t] = Controls()
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
            U_input = data.U_filter;
            T_input = data.T_filter;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 6
            data = load('Simulations/2g_turn_U_input.mat');
            U_input = data.U_filter;
            T_input = data.T_filter;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 7
            data = load('Simulations/5deg_sideslip_U_input.mat');
            U_input = data.U_filter;
            T_input = data.T_filter;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 8
            data = load('Simulations/4point_hesitation_U_input.mat');
            U_input = data.U_filter;
            T_input = data.T_filter;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');

        case 9
            data = load('Simulations/barrel_roll_U_input.mat');
            U_input = data.U_filter;
            T_input = data.T_filter;
            Flight_Condition = 2;
            Flight_Data = aero3560_LoadFlightDataPC9_nominalCG1();
            % High speed nominal condition selected
            State_Vector = load('AircraftData/Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat');


    end
end

