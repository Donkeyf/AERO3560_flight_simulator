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

function U_t = Controls(t, U_trim, U_input, T_input, opts)

    % Defaults for optional settings
    if nargin < 5, opts = struct(); end
    if ~isfield(opts, 'units'),       opts.units = 'deg';  end     % 'deg' or 'rad' for E/A/R
    if ~isfield(opts, 'asDelta'),     opts.asDelta = true; end     % true → add to trim
    if ~isfield(opts, 'holdLast'),    opts.holdLast = false; end   % false → zero outside window
    if ~isfield(opts, 'saturations'), opts.saturations = [0 1; -inf inf; -inf inf; -inf inf]; end

    % If no schedule is provided, hold trim
    if isempty(U_input) || isempty(T_input)
        U_t = U_trim(:);
        return
    end

    % Make schedule 4xN; time as 1xN
    if size(U_input,1) == 4
        Us = U_input;
    elseif size(U_input,2) == 4
        Us = U_input.';                % Nx4 → 4xN
    else
        error('U_input must be 4xN or Nx4 with columns [thr elev ail rud].');
    end
    T = T_input(:).';

    % Sort by time in case the file is unordered
    [T, idx] = sort(T, 'ascend');
    Us = Us(:, idx);

    % Convert elevator/aileron/rudder if schedules are in degrees
    if strcmpi(opts.units, 'deg')
        Us(2:4, :) = deg2rad(Us(2:4, :));   % throttle untouched
    elseif ~strcmpi(opts.units, 'rad')
        error('opts.units must be ''deg'' or ''rad''.');
    end

    % Interpolate the schedule at time t
    if opts.holdLast
        % Zero-order hold with clamping at the ends
        u = interp1(T, Us.', t, 'previous', 'extrap').';
        if t < T(1),  u = Us(:,1);  end
        if t > T(end), u = Us(:,end); end
    else
        % Linear interpolation; outside window → zero (delta schedule)
        u = [interp1(T, Us(1,:), t, 'linear', 0);   % throttle (0..1)
             interp1(T, Us(2,:), t, 'linear', 0);   % elevator (rad)
             interp1(T, Us(3,:), t, 'linear', 0);   % aileron  (rad)
             interp1(T, Us(4,:), t, 'linear', 0)];  % rudder   (rad)
    end

    % Combine with trim (delta vs absolute)
    if opts.asDelta
        U_t = U_trim(:) + u;
    else
        U_t = u;
    end

    % Apply per-channel saturations
    for k = 1:4
        U_t(k) = min(max(U_t(k), opts.saturations(k,1)), opts.saturations(k,2));
    end
end

