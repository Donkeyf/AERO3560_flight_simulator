function [X0,U0] = Trim_Scaffold(VelTrim,AltTrim,PsiTrim, FlightData)
% TRIM - Computes the trim state and control inputs for steady flight.
% ---------------------------------------------------------
% 1. Compute flow properties (density, dynamic pressure, etc.)
% ---------------------------------------------------------


% ---------------------------------------------------------
% 2. Make initial guesses for trim variables
%    AlphaTrim: angle of attack (rad)
%    DtTrim   : throttle setting
%    DeTrim   : elevator deflection (rad)
% ---------------------------------------------------------
% Hint: Use lift equation to balance aircraft weight at AltTrim, VelTrim.
AlphaTrim = 0;        
DtTrim    = 0.5;        
DeTrim    = 0;

% Initial trim vector (state variables to solve for)
XTrim = zeros(1, 12);

% ---------------------------------------------------------
% 3. Define solver settings
% ---------------------------------------------------------
Tol     = 1e-6;        % convergence tolerance
dXTrim  = 1e-6;         % small perturbation for finite differences
i       = 0;          % iteration counter
Error     = 1          % initial error 
J       = zeros(3, 3);        % Initilise Jacobian

% ---------------------------------------------------------
% 4. Iterative solver: Newton–Raphson loop
% ---------------------------------------------------------
while Error > Tol
    
    % Build state vector X from current guess
    X =             % initialise state vector
    X(1)  = VelTrim * cos(AlphaTrim);        % u-component
    X(3)  = VelTrim * sin(AlphaTrim);        % w-component
    X(8)  =         % angle of attack
    X(12) = -h        % altitude
    
    % 4b. Build control vector U
    U =                 % initialise control vector
    U(1) =              % throttle
    U(2) =              % elevator
    
    % Convert Euler angles to quaternion
    X = 
    
    % get the state vector rates at current iteration
    Xdot     = 

    % Store the relevant state vector rates for u, v, p
    XTrimDot =  
    
    % ---------------------------------------------------------
    % 4c. Numerical Jacobian: perturb each trim variable
    % ---------------------------------------------------------
    
    % Perturb Alpha
    AlphaPert = XTrim(1,i) + dXTrim;
    % (rebuild X, U, and evaluate dynamics here...)

    % J(:,1) = (XTrimDotAlpha - XTrimDot)/dXTrim;
    
    % Perturb Throttle
    DtPert = XTrim(2,i) + dXTrim;
    % (rebuild X, U, and evaluate dynamics here...)

    % J(:,2) = (XTrimDotDt - XTrimDot)/dXTrim;
    
    % Perturb Elevator
    DePert = XTrim(3,i) + dXTrim;
    % (rebuild X, U, and evaluate dynamics here...)

    % J(:,3) = (XTrimDotDe - XTrimDot)/dXTrim;
    
    % ---------------------------------------------------------
    % 4d. Newton–Raphson update
    % ---------------------------------------------------------
    % Update guesses for Alpha, Throttle, Elevator
    XTrim(:,i+1) = 
    
    % Compute error (the normalised error)
    Error = 
    
    % iterate the counter (may want to include a maximum iteration)
    i = i + 1;
end

% ---------------------------------------------------------
% 5. Construct final trimmed state and control vectors
% ---------------------------------------------------------
X0 =                % initialise state vector
U0 =                % initialise control vector

% Fill in final states
X0(1)  =            % u-component
X0(3)  =            % w-component
X0(8)  =            % angle of attack
X0(9)  =            % heading angle (rad)
X0(12) =            % altitude

% Fill in controls
U0(1) =             % throttle
U0(2) =             % elevator

end

