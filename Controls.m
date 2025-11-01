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
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 2
            data = load('Simulations/Elevator_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 3
            data = load('Simulations/Aileron_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 4
            data = load('Simulations/Rudder_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 5
            data = load('Simulations/3.5g_loop_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 6
            data = load('Simulations/2g_turn_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 7
            data = load('Simulations/5deg_sideslip_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 8
            data = load('Simulations/4point_hesitation_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);

        case 9
            data = load('Simulations/barrel_roll_U_input.mat');
            tf = data.GUI_save.SimTime;
            dt = data.GUI_save.TimeStep;
            nt = tf/dt + 1;
            t = linspace(0,tf,nt);
            U = extract_control_vector(data,t);


    end
end

function [u] = extract_control_vector(data,time)

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
