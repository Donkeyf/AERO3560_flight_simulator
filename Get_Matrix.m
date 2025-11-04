function mat_struct = Get_Matrix(FlightData, lon_struct, IC)
    % Copy longitudinal matrices and trim data straight from the .mat file
    mat_struct.A_Lon = lon_struct.A_Lon;
    mat_struct.B_Lon = lon_struct.B_Lon;
    mat_struct.FD    = FlightData;
    mat_struct.U0    = IC.U0;
    mat_struct.X0    = IC.X0;

    % Geometry
    S = FlightData.Geo.S;
    c = FlightData.Geo.c; %#ok<NASGU>  % not used in lateral, but kept for completeness
    b = FlightData.Geo.b;

    % Inertial & mass properties
    g   = FlightData.Inertial.g;
    m   = FlightData.Inertial.m;
    Ixx = FlightData.Inertial.Ixx;
    Iyy = FlightData.Inertial.Iyy; %#ok<NASGU>
    Izz = FlightData.Inertial.Izz;
    Ixz = FlightData.Inertial.Ixz;

    % Trim state (IC.X0 contains the equilibrium)
    X0     = IC.X0;
    u1     = X0(1);       % forward speed [m/s]
    theta1 = X0(8);       % pitch angle [rad]

    % Inertial coupling factors
    A1 = Ixz / Ixx;
    B1 = Ixz / Izz;
    den = 1 - A1*B1;

    % Dynamic pressure at trim
    [~, Q] = FlowProperties(FlightData,X0);   % <-- X first, FlightData second

    Aero = FlightData.Aero;

    % Preallocate lateral matrices
    % State ordering: x_lat = [beta, p, r, phi, psi]^T
    % Inputs:        u_lat = [delta_a; delta_r]
    A_Lat = zeros(5,5);
    B_Lat = zeros(5,2);

    % ===== A-matrix coefficients =====
    % beta-dot row
    A_Lat(1,1) =  Q*S*Aero.Cyb /(m*u1);
    A_Lat(1,2) =  Q*S*b*Aero.Cyp /(2*m*u1^2);              % note b, u1^2
    A_Lat(1,3) =  Q*S*b*Aero.Cyr /(2*m*u1^2) - 1;
    A_Lat(1,4) =  g*cos(theta1)/u1;

    % Roll/yaw stability derivatives (using standard non-dim rates)
    Lb = Q*S*b   *Aero.Clb  / Ixx;
    Lp = Q*S*b^2 *Aero.Clp  /(2*Ixx*u1);
    Lr = Q*S*b^2 *Aero.Clr  /(2*Ixx*u1);

    Nb = Q*S*b   *Aero.Cnb  / Izz;
    Np = Q*S*b^2 *Aero.Cnp  /(2*Izz*u1);
    Nr = Q*S*b^2 *Aero.Cnr  /(2*Izz*u1);

    % p-dot and r-dot rows (with Ixz coupling)
    A_Lat(2,1) = (Lb + A1*Nb)/den;
    A_Lat(2,2) = (Lp + A1*Np)/den;
    A_Lat(2,3) = (Lr + A1*Nr)/den;

    A_Lat(3,1) = (Nb + B1*Lb)/den;
    A_Lat(3,2) = (Np + B1*Lp)/den;
    A_Lat(3,3) = (Nr + B1*Lr)/den;

    % phi-dot and psi-dot kinematics
    A_Lat(4,2) = 1;
    A_Lat(4,3) = tan(theta1);
    A_Lat(5,3) = sec(theta1);

    % ===== B-matrix coefficients =====
    % Sideforce control derivatives
    Yda = Q*S*Aero.Cyda / m;
    Ydr = Q*S*Aero.Cydr / m;

    % Roll/yaw control derivatives
    Lda = Q*S*b*Aero.Clda / Ixx;
    Ldr = Q*S*b*Aero.Cldr / Ixx;
    Nda = Q*S*b*Aero.Cnda / Izz;
    Ndr = Q*S*b*Aero.Cndr / Izz;

    % beta-dot inputs (divide by u1 as in A(1,*))
    B_Lat(1,1) = Yda/u1;
    B_Lat(1,2) = Ydr/u1;

    % p-dot inputs (with coupling)
    B_Lat(2,1) = (Lda + A1*Nda)/den;
    B_Lat(2,2) = (Ldr + A1*Ndr)/den;

    % r-dot inputs (with coupling)  <-- use B1 here, not A1
    B_Lat(3,1) = (Nda + B1*Lda)/den;
    B_Lat(3,2) = (Ndr + B1*Ldr)/den;

    % Store lateral matrices
    mat_struct.A_Lat = A_Lat;
    mat_struct.B_Lat = B_Lat;
end
