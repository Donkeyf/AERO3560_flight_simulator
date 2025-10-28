function mat_struct = Get_Matrix(FlightData, lon_struct, IC)
    mat_struct.A_Lon = lon_struct.A_Lon;
    mat_struct.B_Lon = lon_struct.B_Lon;
    
    S = FlightData.Geo.S;
    c = FlightData.Geo.c;
    b = FlightData.Geo.b;

    g = FlightData.Inertial.g;
    m = FlightData.Inertial.m;

    Ixx = FlightData.Inertial.Ixx;
    Iyy = FlightData.Inertial.Iyy;
    Izz = FlightData.Inertial.Izz;
    Ixz = FlightData.Inertial.Ixz;


    X0 = IC.X0;
    U0 = IC.U0;
    u1 = X0(1);
    theta1 = X0(8);

    A1 = FlightData.Inertial.Ixz / FlightData.Inertial.Ixx;
    B1 = FlightData.Inertial.Ixz / FlightData.Inertial.Izz;

    [~, Q] = FlowProperties(X0, FlightData);

    Aero = FlightData.Aero;
    
    A_Lat = zeros(5, 5);
    B_Lat = zeros(5, 2);

    A_Lat(1, 1) = Q * S * c  * Aero.Cyb/ (m * u1);
    A_Lat(1, 2) = Q * S * c  * Aero.Cyp/ (m * u1);
    A_Lat(1, 3) = Q * S * c  * Aero.Cyr/ (m * u1) - 1;
    A_Lat(1, 4) = g * cos(theta1)/ u1;

    Lb = Q * S * b * Aero.Clb / Ixx;
    Lp = Q * S * b * Aero.Clp / (2 * Ixx * u1);
    Lr = Q * S * b * Aero.Clr / (2 * Ixx * u1);

    Yda = Q * S * Aero.Cyda / m;
    Nda = Q * S * b * Aero.Cnda / Izz;
    Lda = Q * S * b * Aero.Clda / Ixx;

    Nb = Q * S * b * Aero.Cnb / Izz;
    Np = Q * S * b^2 * Aero.Cnp / (2 * Izz * u1);
    Nr = Q * S * b^2 * Aero.Cnr / (2 * Izz * u1);
    
    Ydr = Q * S * Aero.Cydr / m;
    Ndr = Q * S * b * Aero.Cndr / Izz;
    Ldr = Q * S * b * Aero.Cldr;

    A_Lat(2, 1) = (Lb + A1 * Nb) / (1 - A1 * B1);
    A_Lat(2, 2) = (Lp + A1 * Np) / (1 - A1 * B1);
    A_Lat(2, 3) = (Lr + A1 * Nr) / (1 - A1 * B1);

    A_Lat(3, 1) = (Nb + B1 * Lb) / (1 - A1 * B1);
    A_Lat(3, 2) = (Np + B1 * Lp) / (1 - A1 * B1);
    A_Lat(3, 3) = (Nr + B1 * Lr) / (1 - A1 * B1);
    A_Lat(4, 2) = 1;
    A_Lat(4, 3) = tan(theta1);
    A_Lat(5, 3) = sec(theta1);

    B_Lat(1, 1) = Yda / u1;
    B_Lat(1, 2) = Ydr / u1;
    B_Lat(2, 1) = (Lda + A1 * Nda) / (1 - A1 * B1);
    B_Lat(2, 2) = (Ldr + A1 * Ndr) / (1 - A1 * B1);
    B_Lat(3, 1) = (Nda + A1 * Lda) / (1 - A1 * B1);
    B_Lat(2, 2) = (Ndr + A1 * Ldr) / (1 - A1 * B1);

    mat_struct.A_Lat = A_Lat;
    mat_struct.B_Lat = B_Lat;
end