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

    % Font sizes
    fs_axes   = 12;   % tick labels
    fs_label  = 14;   % x/y labels
    fs_title  = 14;   % titles
    fs_legend = 12;   % legends

    for k = 1:numel(S)
        if ~isstruct(S(k)), continue; end

        t  = S(k).t;
        V  = S(k).meta.V;
        CG = S(k).meta.CG;

        % Longitudinal (elevator): [du, dw, q, theta, dh]
        X     = S(k).lon.elev.X;
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
        ax = gca; ax.FontSize = fs_axes;
        ylabel('\theta [deg]','FontSize',fs_label);
        title('Pitch angle','FontSize',fs_title);

        % Pitch rate panel
        nexttile;
        plot(t, rad2deg(q));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('q [deg/s]','FontSize',fs_label);
        title('Pitch rate','FontSize',fs_title);

        % Forward speed panel
        nexttile;
        plot(t, du);
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('u [m/s]','FontSize',fs_label);
        xlabel('t [s]','FontSize',fs_label);
        title('Forward speed','FontSize',fs_title);

        % Altitude panel (your reference style)
        nexttile;
        plot(t, dh);
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('\Delta h [m]','FontSize',fs_label);
        xlabel('t [s]','FontSize',fs_label);
        title('Altitude','FontSize',fs_title);

        % ===== Lateral – Aileron impulse: [beta, p, r, phi, psi] =====
        Xa = S(k).lat.ail.X;

        figure('Name', sprintf('Lateral Aileron %s V=%g', CG, V));
        tiledlayout(2,2,'Padding','compact');

        % Angles: roll phi and sideslip beta
        nexttile;
        plot(t, rad2deg(Xa(:,4))); hold on;
        plot(t, rad2deg(Xa(:,1)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('angle [deg]','FontSize',fs_label);
        lg = legend('\phi','\beta','Location','best');
        lg.FontSize = fs_legend;
        title('Angles','FontSize',fs_title);

        % Roll rate p
        nexttile;
        plot(t, rad2deg(Xa(:,2)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('p [deg/s]','FontSize',fs_label);
        title('Roll rate','FontSize',fs_title);

        % Yaw rate r
        nexttile;
        plot(t, rad2deg(Xa(:,3)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('r [deg/s]','FontSize',fs_label);
        xlabel('t [s]','FontSize',fs_label);
        title('Yaw rate','FontSize',fs_title);

        % Heading psi
        nexttile;
        plot(t, rad2deg(Xa(:,5)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('\psi [deg]','FontSize',fs_label);
        xlabel('t [s]','FontSize',fs_label);
        title('Heading','FontSize',fs_title);

        % ===== Lateral – Rudder impulse: [beta, p, r, phi, psi] =====
        Xr = S(k).lat.rud.X;

        figure('Name', sprintf('Lateral Rudder %s V=%g', CG, V));
        tiledlayout(2,2,'Padding','compact');

        % Angles: roll phi and yaw rate r (as in your version)
        nexttile;
        plot(t, rad2deg(Xr(:,4))); hold on;
        plot(t, rad2deg(Xr(:,3)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('angle [deg]','FontSize',fs_label);
        lg = legend('\phi','r','Location','best');
        lg.FontSize = fs_legend;
        title('Angles','FontSize',fs_title);

        % Roll rate p
        nexttile;
        plot(t, rad2deg(Xr(:,2)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('p [deg/s]','FontSize',fs_label);
        title('Roll rate','FontSize',fs_title);

        % Yaw rate r
        nexttile;
        plot(t, rad2deg(Xr(:,3)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('r [deg/s]','FontSize',fs_label);
        xlabel('t [s]','FontSize',fs_label);
        title('Yaw rate','FontSize',fs_title);

        % Sideslip beta
        nexttile;
        plot(t, rad2deg(Xr(:,1)));
        grid on;
        ax = gca; ax.FontSize = fs_axes;
        ylabel('\beta [deg]','FontSize',fs_label);
        xlabel('t [s]','FontSize',fs_label);
        title('Sideslip','FontSize',fs_title);
    end
end
