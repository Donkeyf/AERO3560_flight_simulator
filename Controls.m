% Generates a pop-up menu that asks the user to select one of nine
% different manoeuveres to perform, featuring; impulse deflections, a
% steady pull-up loop, a steady no-sideslip turn, a steady-heading
% sideslip flight, a four-point hesitation roll, a complete barrel roll and
% a steady-level flight to confirm that the trim setting is correct.
%
% Inputs
% None
%
% Outputs
% U - The complete control array 

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
        % Trimmed Flight-Check
        case 1
            data = load('Simulations/SteadyLevel_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));
        
        % Elevator Impulse Deflection
        case 2
            data = load('Simulations/Elevator_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));

            
        % Aileron Impulse Deflection
        case 3
            data = load('Simulations/Aileron_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));

        % Rudder Impulse Deflection
        case 4
            data = load('Simulations/Rudder_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));
            
        % 3.5g Loop
        case 5
            data = load('Simulations/3.5g_loop_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));

        % 2g Steady Turn
        case 6
            data = load('Simulations/2g_turn_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));

        % Steady-Heading Sideslip Flight
        case 7
            data = load('Simulations/5deg_sideslip_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));

        % 4-Point Hesitation Roll
        case 8
            data = load('Simulations/4point_hesitation_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));

        % Barrel Roll
        case 9
            data = load('Simulations/barrel_roll_U_input.mat');
            % Loading Simulation End Time & Timestep
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;

            % Calculating No. of Timesteps
            nt = tf/dt + 1;

            % Creating Simulation Time Vector
            t = linspace(0,tf,nt);

            % Generating Control Array
            U = extract_control_vector(data,t);

            % Converting Control Surface Deflections to Radians
            U(2:4,:) = deg2rad(U(2:4,:));
    end
end

function [u] = extract_control_vector(data,time)
% Interpolates between the known control vectors generated by the GUI to
% generate the control array.
% 
% Outputs
% u - The complete control array for each timestep.

    % Extracting Known Control Data Points & Times
    throttle_times = data.GUI_save.X_dt;
    throttle_inputs = data.GUI_save.Y_dt;
    el_times = data.GUI_save.X_de;
    el_defs = data.GUI_save.Y_de;
    ail_times = data.GUI_save.X_da;
    ail_defs = data.GUI_save.Y_da;
    rud_times = data.GUI_save.X_dr;
    rud_defs = data.GUI_save.Y_dr;

    % Interpolating Controls for the Manoeuvre
    dt = interp1(throttle_times,throttle_inputs,time);
    de = interp1(el_times,el_defs,time);
    da = interp1(ail_times,ail_defs,time);
    dr = interp1(rud_times,rud_defs,time);

    % Constructing Manouevre Control Array
    u = [dt; de; da; dr];

end
