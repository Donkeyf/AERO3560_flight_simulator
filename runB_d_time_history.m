function runB_d_time_history(S) 

% If user forgets the input, auto-load the MAT.

if nargin == 0
    if exist('PartB_c_soln.mat','file')
        tmp = load('PartB_c_soln.mat'); S = tmp.S;
    else
        error('No input S and PartB_c_soln.mat not found.');
    end
end

for k = 1:numel(S)
    if ~isstruct(S(k)), continue; end
    t  = S(k).t;
    V  = S(k).meta.V;
    CG = S(k).meta.CG;

   % Longitudinal (elevator): [du, dw, q, theta, dh]
    X = S(k).lon.elev.X;

    du     = X(:,1);    % m/s
    dw     = X(:,2);    % m/s
    q      = X(:,3);    % rad/s
    theta  = X(:,4);    % rad
    dh     = X(:,5);    % m (delta altitude)

    figure('Name', sprintf('Longitudinal %s V=%g', CG, V));
    tiledlayout(2,2,'Padding','compact');

    % Angles panel: use theta only, or theta + approx alpha if you want
    nexttile;
    plot(t, rad2deg(theta)); 
    grid on;
    ylabel('\theta [deg]'); 
    title('Pitch angle');

    % Rates panel
    nexttile;
    plot(t, rad2deg(q));
    grid on;
    ylabel('q [deg/s]');
    title('Pitch rate');

    % Velocity panel
    nexttile;
    plot(t, du);
    grid on;
    ylabel('u [m/s]');
    xlabel('t [s]');
    title('Forward speed');

    % Altitude panel
    nexttile;
    plot(t, dh);
    grid on;
    ylabel('\Delta h [m]');
    xlabel('t [s]');
    title('Altitude');

    % == Lateral Aileron: [beta, p, r, phi, psi]
    Xa = S(k).lat.ail.X;
    figure('Name', sprintf('Lateral Aileron %s V=%g', CG, V));
    tiledlayout(2,2,'Padding','compact');

    nexttile; plot(t, rad2deg(Xa(:,4))); hold on; plot(t, rad2deg(Xa(:,1)));
    grid on; ylabel('\phi / \beta [deg]'); title('Angles'); legend('\phi','\beta','location','best');

    nexttile; plot(t, rad2deg(Xa(:,2))); grid on; ylabel('p [deg/s]'); title('Rates');

    nexttile; plot(t, rad2deg(Xa(:,3))); grid on; ylabel('r [deg/s]'); title('Rates');

    nexttile; plot(t, rad2deg(Xa(:,5))); grid on; ylabel('\psi [deg]'); title('Sideslip'); xlabel('t [s]');

    % == Lateral Rudder: [beta, p, r, phi, psi]
    Xr = S(k).lat.rud.X;
    figure('Name', sprintf('Lateral Rudder %s V=%g', CG, V));
    tiledlayout(2,2,'Padding','compact');

    nexttile; plot(t, rad2deg(Xr(:,4))); hold on; plot(t, rad2deg(Xr(:,3)));
    grid on; ylabel('\phi / r [deg]'); title('Angles'); legend('\phi','r','location','best');

    nexttile; plot(t, rad2deg(Xr(:,2))); grid on; ylabel('p [deg/s]'); title('Rates');

    nexttile; plot(t, rad2deg(Xr(:,3))); grid on; ylabel('r [deg/s]'); title('Rates');

    nexttile; plot(t, rad2deg(Xr(:,1))); grid on; ylabel('\beta [deg]'); title('Sideslip'); xlabel('t [s]');
end
end
