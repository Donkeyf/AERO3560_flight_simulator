clc

[FlightData_CG1] = aero3560_LoadFlightDataPC9_nominalCG1();
[FlightData_CG2] = aero3560_LoadFlightDataPC9_CG2();

IC_CG2_100kn = load("AircraftData\ICs_PC9_CG2_100Kn_1000ft.mat");
IC_CG2_180kn = load("AircraftData\ICs_PC9_CG2_180Kn_1000ft.mat");
IC_CG1_180kn = load("AircraftData\ICs_PC9_nominalCG1_180Kn_1000ft.mat");
IC_CG1_100kn = load("AircraftData\ICs_PC9_nominalCG1_100Kn_1000ft.mat");

Lon_CG2_100kn = load("AircraftData\Longitudinal_Matrices_PC9_CG2_100Kn_1000ft.mat");
Lon_CG2_180kn = load("AircraftData\Longitudinal_Matrices_PC9_CG2_180Kn_1000ft.mat");
Lon_CG1_100kn = load("AircraftData\\Longitudinal_Matrices_PC9_nominalCG1_100Kn_1000ft.mat");
Lon_CG1_180kn = load("AircraftData\\Longitudinal_Matrices_PC9_nominalCG1_180Kn_1000ft.mat");

mat_CG2_100kn = Get_Matrix(FlightData_CG2, Lon_CG2_100kn, IC_CG2_100kn);
mat_CG2_180kn = Get_Matrix(FlightData_CG2, Lon_CG2_180kn, IC_CG2_100kn);
mat_CG1_100kn = Get_Matrix(FlightData_CG1, Lon_CG1_100kn, IC_CG1_100kn);
mat_CG1_180kn = Get_Matrix(FlightData_CG1, Lon_CG1_180kn, IC_CG1_180kn);


[eV_CG1_100kn, eE_CG1_100kn] = eig(mat_CG1_100kn.A_Lon);
[Wn_CG1_100kn, Z_CG1_100kn] = damp(mat_CG1_100kn.A_Lon);
[eV_CG1_180kn, eE_CG1_180kn] = eig(mat_CG1_180kn.A_Lon);
[Wn_CG1_180kn, Z_CG1_180kn] = damp(mat_CG1_180kn.A_Lon);

[eV_CG2_100kn, eE_CG2_100kn] = eig(mat_CG2_100kn.A_Lon);
[Wn_CG2_100kn, Z_CG2_100kn] = damp(mat_CG2_100kn.A_Lon);
[eV_CG2_180kn, eE_CG2_180kn] = eig(mat_CG2_180kn.A_Lon);
[Wn_CG2_180kn, Z_CG2_180kn] = damp(mat_CG2_180kn.A_Lon);

dt = 0.1;
delta_u = zeros(3, 3);

while i < 1:1000
    
    
end