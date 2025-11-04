function runB_d_time_history(S)

    % If user forgets the input, auto-load the MAT file
    if nargin == 0
        if exist('PartB_c_soln.mat','file')
            tmp = load('PartB_c_soln.mat'); 
            S   = tmp.S;
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
        du    = X(:,1);         % m/s
        dw    = X(:,2);         % m/s (unused in plots, but kept)
        q     = X(:,3);         % rad/s
        theta = X(:,4);         % rad
        dh    = X(:,5);         % m (delta altitude)

        figure('Name', sprintf('Longitudinal %s V=%g', CG, V));
        tiledlayout(2,2,'Padding','compact');

        % Pitch angle panel
        nexttile;
        plot(t, rad2deg(theta));
        grid on;
        ylabel('\theta [deg]');
        title('Pitch angle');

        % Pitch rate panel
        nexttile;
        plot(t, rad2deg(q));
        grid on;
        ylabel('q [deg/s]');
        title('Pitch rate');

        % Forward speed panel
        nexttile;
        plot(t, du);
        grid on;
        ylabel('u [m/s]');
        xlabel('t [s]');
        title('Forward speed');

        % Altitude panel (your reference style)
        nexttile;
        plot(t, dh);
        grid on;
        ylabel('\Delta h [m]');
        xlabel('t [s]');
        title('Altitude');

        % ===== Lateral – Aileron impulse: [beta, p, r, phi, psi] =====
        Xa = S(k).lat.ail.X;

        figure('Name', sprintf('Lateral Aileron %s V=%g', CG, V));
        tiledlayout(2,2,'Padding','compact');

        % Angles: roll phi and sideslip beta
        nexttile;
        plot(t, rad2deg(Xa(:,4))); hold on;
        plot(t, rad2deg(Xa(:,1)));
        grid on;
        ylabel('angle [deg]');
        legend('\phi','\beta','Location','best');
        title('Angles');

        % Roll rate p
        nexttile;
        plot(t, rad2deg(Xa(:,2)));
        grid on;
        ylabel('p [deg/s]');
        title('Roll rate');

        % Yaw rate r
        nexttile;
        plot(t, rad2deg(Xa(:,3)));
        grid on;
        ylabel('r [deg/s]');
        xlabel('t [s]');
        title('Yaw rate');

        % Heading psi
        nexttile;
        plot(t, rad2deg(Xa(:,5)));
        grid on;
        ylabel('\psi [deg]');
        xlabel('t [s]');
        title('Heading');

        % ===== Lateral – Rudder impulse: [beta, p, r, phi, psi] =====
        Xr = S(k).lat.rud.X;

        figure('Name', sprintf('Lateral Rudder %s V=%g', CG, V));
        tiledlayout(2,2,'Padding','compact');

        % Angles: roll phi and yaw rate r (as in your version)
        nexttile;
        plot(t, rad2deg(Xr(:,4))); hold on;
        plot(t, rad2deg(Xr(:,3)));
        grid on;
        ylabel('angle [deg]');
        legend('\phi','r','Location','best');
        title('Angles');

        % Roll rate p
        nexttile;
        plot(t, rad2deg(Xr(:,2)));
        grid on;
        ylabel('p [deg/s]');
        title('Roll rate');

        % Yaw rate r
        nexttile;
        plot(t, rad2deg(Xr(:,3)));
        grid on;
        ylabel('r [deg/s]');
        xlabel('t [s]');
        title('Yaw rate');

        % Sideslip beta
        nexttile;
        plot(t, rad2deg(Xr(:,1)));
        grid on;
        ylabel('\beta [deg]');
        xlabel('t [s]');
        title('Sideslip');
    end
end
