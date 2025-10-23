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

function U_t = Controls(i, U_input)
    % Extracts the array of control inputs for the current timestep
    U_t = U_input(:,i);
end

