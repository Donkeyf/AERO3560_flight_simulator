% Generates a pop-up menu that asks the user to select one of four
% flight-conditions to simulate, a combination of two different speeds and CG
% locations.
%
% Inputs
% None
%
% Outputs
% Flight_Data - A structure storing all aerodynamic, geometric, inertial,
% propulsive information required to simulate the aircraft dynamics, also
% includes the maximum control surface deflections.
% X0 - The initial aircraft state featuring quaternions instead of Euler
% angles.

function [Flight_Data, X0] = Initialisation()

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
    X0 = [State_Vector.X0(1:6); quaternion; State_Vector.X0(10:12)];
end


