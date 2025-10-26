function [X0,U0] = Trim(VelTrim,AltTrim,PsiTrim, Flight_Data)
% TRIM - Computes the trim state and control inputs for steady flight.
% ---------------------------------------------------------
% 1. Compute flow properties (density, dynamic pressure, etc.)
% ---------------------------------------------------------
W = Flight_Data.Inertial.g * Flight_Data.Inertial.m;

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
max = 1000;
XTrim = zeros(3, max);

XDot = zeros(13, 1);

% ---------------------------------------------------------
% 3. Define solver settings
% ---------------------------------------------------------
Tol     = 1e-6;        % convergence tolerance
dXTrim  = 1e-6;         % small perturbation for finite differences
i       = 0;          % iteration counter
Error     = 1;          % initial error 
J       = zeros(3, 3);        % Initilise Jacobian

% ---------------------------------------------------------
% 4. Iterative solver: Newton–Raphson loop
% ---------------------------------------------------------
while Error > Tol
    
    q = e2q([0, AlphaTrim, 0]');

    % Build state vector X from current guess
    X =  zeros(1, 13);           % initialise state vector
    X(1)  = VelTrim * cos(AlphaTrim);        % u-component
    X(3)  = VelTrim * sin(AlphaTrim);        % w-component
    x(7)  = q(1);
    X(8)  = q(2);
    X(9)  = q(3);
    X(10)  = q(4);
    X(13) = -AltTrim;        % altitude
    
    % 4b. Build control vector U
    U = zeros(1, 4);                % initialise control vector
    U(1) = DtTrim;             % throttle
    U(2) = DeTrim;             % elevator
    
    
    % get the state vector rates at current iteration
    
    Xdot = XDot;

    % Store the relevant state vector rates for u, v, p
    F_b = BodyForces(X, U, Flight_Data, Xdot);
    XDot = StateRates(X, F_b, Flight_Data);
    XTrimDot = [XDot(1), XDot(3), XDot(5)]';
    
    % ---------------------------------------------------------
    % 4c. Numerical Jacobian: perturb each trim variable
    % ---------------------------------------------------------

    % Perturb Alpha
    AlphaPert = XTrim(1) + dXTrim;
    AlphaPertM = XTrim(1) - dXTrim;
    % (rebuild X, U, and evaluate dynamics here...)
    q_p = e2q([0, AlphaPert + PsiTrim, 0]');
    q_m = e2q([0, AlphaPertM + PsiTrim, 0]');
    u_p = VelTrim * cos(AlphaPert);
    u_m = VelTrim * cos(AlphaPertM);
    w_p = VelTrim * sin(AlphaPert);
    w_m = VelTrim * sin(AlphaPertM);

    X_p = [u_p, 0, w_p, 0, 0, 0, q_p(1), q_p(2), q_p(3), q_p(4), 0, 0, -AltTrim];
    X_m = [u_m, 0, w_m, 0, 0, 0, q_m(1), q_m(2), q_m(3), q_m(4), 0, 0, -AltTrim];


    F_p = BodyForces(X_p, U, Flight_Data, Xdot);
    Xdotp = StateRates(X_p, F_p, Flight_Data);
    XPDot = [Xdotp(1), Xdotp(3), Xdotp(5)]';
    F_m = BodyForces(X_m, U, Flight_Data, Xdot);
    Xdotm = StateRates(X_m, F_m, Flight_Data);
    XMDot = [Xdotm(1), Xdotm(3), Xdotm(5)]';

    J(:,1) = (XPDot - XMDot)./(2 * dXTrim);

    % J(:,1) = (XTrimDotAlpha - XTrimDot)/dXTrim;
    
    % Perturb Throttle
    DtPert = XTrim(2) + dXTrim;
    DtPertM = XTrim(2) - dXTrim;
    % (rebuild X, U, and evaluate dynamics here...)
    u_p = VelTrim * cos(AlphaTrim);
    u_m = VelTrim * cos(AlphaTrim);
    w_p = VelTrim * sin(AlphaTrim);
    w_m = VelTrim * sin(AlphaTrim);

    X_p = [u_p, 0, w_p, 0, 0, 0, q(1), q(2), q(3), q(4), 0, 0, -AltTrim];
    X_m = [u_m, 0, w_m, 0, 0, 0, q(1), q(2), q(3), q(4), 0, 0, -AltTrim];
    
    U_p = zeros(1, 4);
    U_p(1) = DtPert;
    U_m = zeros(1, 4);
    U_m(1) = DtPertM;


    F_p = BodyForces(X_p, U_p, Flight_Data, Xdot);
    Xdotp = StateRates(X_p, F_p, Flight_Data);
    XPDot = [Xdotp(1), Xdotp(3), Xdotp(5)]';
    F_m = BodyForces(X_m, U_m, Flight_Data, Xdot);
    Xdotm = StateRates(X_m, F_m, Flight_Data);
    XMDot = [Xdotm(1), Xdotm(3), Xdotm(5)]';

    J(:,2) = (XPDot - XMDot)./(2 * dXTrim);

    % J(:,2) = (XTrimDotDt - XTrimDot)/dXTrim;
    
    % Perturb Elevator
    DePert = XTrim(3) + dXTrim;
    DePertM = XTrim(3) - dXTrim;
    % (rebuild X, U, and evaluate dynamics here...)
    u_p = VelTrim * cos(AlphaTrim);
    u_m = VelTrim * cos(AlphaTrim);
    w_p = VelTrim * sin(AlphaTrim);
    w_m = VelTrim * sin(AlphaTrim);

    X_p = [u_p, 0, w_p, 0, 0, 0, q(1), q(2), q(3), q(4), 0, 0, -AltTrim];
    X_m = [u_m, 0, w_m, 0, 0, 0, q(1), q(2), q(3), q(4), 0, 0, -AltTrim];
    
    U_p = zeros(1, 4);
    U_p(1) = DePert;
    U_m = zeros(1, 4);
    U_m(1) = DePertM;

    F_p = BodyForces(X_p, U_p, Flight_Data, Xdot);
    Xdotp = StateRates(X_p, F_p, Flight_Data);
    XPDot = [Xdotp(1), Xdotp(3), Xdotp(5)]';
    F_m = BodyForces(X_m, U_m, Flight_Data, Xdot);
    Xdotm = StateRates(X_m, F_m, Flight_Data);
    XMDot = [Xdotm(1), Xdotm(3), Xdotm(5)]';
  
    J(:,3) = (XPDot - XMDot)./(2 * dXTrim);

    % J(:,3) = (XTrimDotDe - XTrimDot)/dXTrim;
    
    % ---------------------------------------------------------
    % 4d. Newton–Raphson update
    % ---------------------------------------------------------
    % Update guesses for Alpha, Throttle, Elevator
    d_X = J\XTrimDot;
    AlphaTrim = AlphaTrim - d_X(1);
    DtTrim = DtTrim - d_X(2);
    DeTrim = DeTrim - d_X(3);
    XTrim(:,i+1) = [AlphaTrim, DtTrim, DeTrim];
    
    % Compute error (the normalised error)
    Error = norm(d_X);
     
    % iterate the counter (may want to include a maximum iteration)
    i = i + 1;
    if i > max
        break
    end
    
end

% ---------------------------------------------------------
% 5. Construct final trimmed state and control vectors
% ---------------------------------------------------------
X0 = zeros(13, 1);             % initialise state vector
U0 = zeros(4, 1);               % initialise control vector

% Fill in final states
X0(1)  = VelTrim * cos(AlphaTrim);        % u-component
X0(3)  = VelTrim * sin(AlphaTrim);        % w-component
X0(7)  = q(1);
X0(8)  = q(2);
X0(9)  = q(3);
X0(10)  = q(4);
X0(13) = -AltTrim;        % altitude

% Fill in controls
U0(1) = DtTrim;            % throttle
U0(2) = DeTrim;            % elevator

end

