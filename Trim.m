function [Xtrim, Utrim, alpha] = Trim(Flight_Data, X0)
% TRIM - Computes the trim state and control inputs for steady flight.
% ---------------------------------------------------------
% 1. Compute flow properties (density, dynamic pressure, etc.)
% ---------------------------------------------------------
[~, Q_0] = FlowProperties(Flight_Data, X0);

% ---------------------------------------------------------
% 2. Make initial guesses for trim variables
%    AlphaTrim: angle of attack (rad)
%    DtTrim   : throttle setting
%    DeTrim   : elevator deflection (rad)
% ---------------------------------------------------------
% Hint: Use lift equation to balance aircraft weight at AltTrim, VelTrim.
% Calculate lift coefficient
C_L = (Flight_Data.Inertial.m*Flight_Data.Inertial.g)/(Q_0*Flight_Data.Geo.S);

% Initial guesses for trimmed state
alpha_0 = (C_L - Flight_Data.Aero.CLo)/(Flight_Data.Aero.CLa);
delta_T_0 = 0.5;
delta_e_0 = 0;

% Initialise the augmented state vector x_bar and control vector
x_i = [alpha_0; delta_T_0; delta_e_0];
u0 = [delta_T_0; delta_e_0; 0; 0];

% ---------------------------------------------------------
% 3. Define solver settings
% ---------------------------------------------------------   
error = 1;              % Initial error large arbitrary value
eps = 1e-12;            % Error tolerance
i = 1;               % Iteration counter
max_iter = 1000;        % Maximum number of iterations

% Initialise Jacobian matrix
J = zeros(length(x_i));
dx = 1e-7;

% Compute the sideslip angle using the state vector
[~, beta_0] = AeroAngles(X0);

% ---------------------------------------------------------
% 4. Iterative solver: Newton–Raphson loop
% ---------------------------------------------------------
while error > eps && i < max_iter
    
    % Initialise state variables
    x_trim = X0;            % Aircraft state
    u_trim = u0;            % Control state

    % Get the trimmed state with the values for alpha previously determined
    v = norm(X0(1:3));
    x_trim(1) = v*cos(x_i(1));
    x_trim(2) = v*sin(-beta_0);
    x_trim(3) = v*sin(x_i(1));

    % Get the control trim state with the previous iteration values
    u_trim(1) = x_i(2);
    u_trim(2) = x_i(3);

    % Get the state vector rates at the current iteration
    x_doti = StateRates(Flight_Data, x_trim, u_trim);

    % Store the relevant state vector rates for u, v, p
    fx_i = [x_doti(1); x_doti(3); x_doti(5)];
    
    % ---------------------------------------------------------
    % 4c. Numerical Jacobian: perturb each trim variable
    % ---------------------------------------------------------
    for i = 1:length(x_i)

        % Construct a perturbaion vector, perturbing a single element
        pert_vec = zeros(length(x_i), 1);
        pert_vec(i) = dx;
        
        % Positive Perturbation
        x_ip = x_i + pert_vec;
        x_trim_dp = x_trim;         % Positive perturbation aircraft state
    
        % Construct the trim state for the positive perturbation case
        v = norm(x_trim(1:3));
        x_trim_dp(1) = v*cos(x_ip(1));
        x_trim_dp(2) = v*sin(-beta_0);
        x_trim_dp(3) = v*sin(x_ip(1));

        % Get the control state for the positive perturbation
        u_dp = zeros(size(u_trim));
        u_dn = zeros(size(u_trim));

        % If the control settings are being perturbed, construct perturbed
        % control state vectors, using the convention u = [delta_T,
        % delta_e, 0, 0], so if the variable delta_T is being perturbed, we
        % need to access the first element of the control state, even
        % though the index of the construction loop is 2
        if i ~= 1
            u_dp(i-1) = u_trim(i-1) + dx;
            u_dn(i-1) = u_trim(i-1) - dx;
        end
        
        % Get the positive perturbation state rates
        x_dotip = StateRates(Flight_Data, x_trim_dp, u_dp);
        fx_ip = [x_dotip(1); x_dotip(3); x_dotip(5)];
    
        % Negative Perturbation
        x_in = x_i - pert_vec;
        x_trim_dn = x_trim;         % Positive perturbation aircraft state
    
        % Get the trim state for the negatively perturbed case
        v = norm(x_trim(1:3));
        x_trim_dn(1) = v*cos(x_in(1));
        x_trim_dn(2) = v*sin(-beta_0);
        x_trim_dn(3) = v*sin(x_in(1));

        % Get the state vector rates for the negatively perturbed case
        x_dotin = StateRates(Flight_Data, x_trim_dn, u_dn);
        fx_in = [x_dotin(1); x_dotin(3); x_dotin(5)];

        % Assemble the relevant column of the Jacobian with the positive
        % and negative perturbations
        J(:, i) = (fx_ip - fx_in)/(2*dx);
    end
    
    % ---------------------------------------------------------
    % 4d. Newton–Raphson update
    % ---------------------------------------------------------
    x_new = x_i - pinv(J)*fx_i;

    % Check that the determined control inputs lie within the control 
    % limits of the aircraft, if not then set them to be at the limit

    % Throttle setting control limit
    if x_new(2) > Flight_Data.ControlLimits.Upper(1)
        x_new(2) = Flight_Data.ControlLimits.Upper(1);
    elseif x_new(2) < Flight_Data.ControlLimits.Lower(1)
        x_new(2) = Flight_Data.ControlLimits.Lower(1);
    end
    
    % Elevator setting control limit
    if x_new(3) > Flight_Data.ControlLimits.Upper(2)
        x_new(3) = Flight_Data.ControlLimits.Upper(2);
    elseif x_new(3) < Flight_Data.ControlLimits.Lower(2)
        x_new(3) = Flight_Data.ControlLimits.Lower(2);
    end

    % Compute the error as the deviation in iterations
    error = norm(x_new - x_i);

    % Reset the vector for the next iteration
    x_i = x_new;
    
    % Update the iteration counter
    i = i + 1;
end

% ---------------------------------------------------------
% 5. Construct final trimmed state and control vectors
% ---------------------------------------------------------
Xtrim = X0;
Utrim = u0;

% u, v, w velocity components
v = norm(X0(1:3));
Xtrim(1) = v*cos(x_i(1));
Xtrim(2) = v*sin(-beta_0);
Xtrim(3) = v*sin(x_i(1));

% Control vector components
alpha = x_i(1);
Utrim(1) = x_i(2);
Utrim(2) = x_i(3);
end 