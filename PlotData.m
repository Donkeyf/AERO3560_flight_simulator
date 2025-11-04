function PlotData(t, x, u)
% Convert current states and controls into presentable units (e.g. radians
% to degrees) and generate plots of all variables relevant to the
% manoeuvre.
% Inputs:
    % t - time vector for simulation
    % x - state vector array over entire simulation
    % u - control vector array over entire simulation
    % save_figs - boolean option to save all figures
    % CG, V, sim_number - used with save_figs for figure naming and saving
% Plotting Parameters
% Colour Definition
myred           = [216 30 49]/255;
myblue          = [27 99 157]/255;
myblack         = [0 0 0]/255;
mygreen         = [0 128 0]/255;
mycyan          = [2 169 226]/255;
myyellow        = [251 194 13]/255;
mygray          = [89 89 89]/255;
set(groot,'defaultAxesColorOrder', ...
    [myblack;myblue;myred;mygreen;myyellow;mycyan;mygray]);

%Parameter Definition
alw             = 1;                        % AxesLineWidth
fsz             = 14;                       % Fontsize
lw              = 1;                        % LineWidth
msz             = 1;                        % MarkerSize
int             = 'latex';                  % Interpreter

set(0,'defaultLineLineWidth',lw);       % set the default line width to lw
set(0,'defaultLineMarkerSize',msz);     % set the default line marker size to msz
set(0,'defaultLineLineWidth',lw);           % set the default line width to lw
set(0,'defaultLineMarkerSize',msz);         % set the default line marker size to msz
set(0,'defaultTextInterpreter', int);
set(0,'defaultAxesTickLabelInterpreter', int);
set(0,'defaultLegendInterpreter', int);

% Convert quaternions in the state array to euler angles
quats = x(7:10, :);
euler_angles = q2e(quats);
euler_angles = rad2deg(euler_angles);

% Compute normal load factor with body rates
p = x(4,:);
q = x(5,:);
r = x(6,:);
nz_q = q.*x(1,:)/9.81 + 1;

% sideslip 
sideslip = x(2,:)./sqrt((x(1,:).^2 + x(2,:).^2 + x(3,:).^2));
beta = rad2deg(asin(sideslip));

% Flip height
x(end,:) = -x(end,:);

% Plot all key results 
% Plotting Velocity Components
hFig            = figure(1); clf;
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
hold on;
plot(t, x(1,:))
plot(t, x(2,:))
plot(t, x(3,:))

grid on

xlabel('Time [s]')
ylabel('Velocity [m/s]')
xlim([0,t(end)])
box on
set(gca,'GridLineStyle','-')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridColor','k')
set(gca,'MinorGridColor','k')
set(findall(hFig, '-property', 'FontSize'), 'FontSize', fsz)

[hleg] = legend('$u$', '$v$', '$w$');
set(hleg,'EdgeColor',hleg.Color);
set(hleg,'Location','best');

% Plotting Body Rates
hFig            = figure(2); clf;
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
hold on;
plot(t, x(4,:))
plot(t, x(5,:))
plot(t, x(6,:))

grid on

xlabel('Time [s]')
ylabel('Body Rates [rad/s]')
xlim([0,t(end)])
box on
set(gca,'GridLineStyle','-')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridColor','k')
set(gca,'MinorGridColor','k')
set(findall(hFig, '-property', 'FontSize'), 'FontSize', fsz)

[hleg] = legend('$p$', '$q$', '$r$');
set(hleg,'EdgeColor',hleg.Color);
set(hleg,'Location','best');

% Plotting Euler Angles
hFig            = figure(3); clf;
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
hold on;
plot(t, euler_angles(1,:))
plot(t, euler_angles(2,:))
plot(t, euler_angles(3,:))

grid on

xlabel('Time [s]')
ylabel('Euler Angles [$^\circ$]')
xlim([0,t(end)])
box on
set(gca,'GridLineStyle','-')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridColor','k')
set(gca,'MinorGridColor','k')
set(findall(hFig, '-property', 'FontSize'), 'FontSize', fsz)

[hleg] = legend('$\phi$', '$\theta$', '$\psi$');
set(hleg,'EdgeColor',hleg.Color);
set(hleg,'Location','best');

% Plotting Positions
hFig            = figure(4); clf;
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
hold on;
plot(t, x(11,:))
plot(t, x(12,:))
plot(t, x(13,:))

grid on

xlabel('Time [s]')
ylabel('Positions [m]')
xlim([0,t(end)])
box on
set(gca,'GridLineStyle','-')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridColor','k')
set(gca,'MinorGridColor','k')
set(findall(hFig, '-property', 'FontSize'), 'FontSize', fsz)

[hleg] = legend('$x$', '$y$', '$z$');
set(hleg,'EdgeColor',hleg.Color);
set(hleg,'Location','best');

% Plotting Load Factors
hFig            = figure(5); clf;
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
hold on;
plot(t, nz_q)

grid on

xlabel('Time [s]')
ylabel('Load Factor')
xlim([0,t(end)])
box on
set(gca,'GridLineStyle','-')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridColor','k')
set(gca,'MinorGridColor','k')
set(findall(hFig, '-property', 'FontSize'), 'FontSize', fsz)

[hleg] = legend('$n_z$');
set(hleg,'EdgeColor',hleg.Color);
set(hleg,'Location','best');


figure(Name='3D Position');
plot3(x(11,:), x(12,:), x(13,:), '-o', 'LineWidth', lw, 'MarkerSize', msz); 
xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');
xlim([0,t(end)])
grid on; 
axis equal;
hold off

% Plotting Positions
hFig            = figure(7); clf;
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
hold on;
plot(t, u(1,:))
plot(t, rad2deg(u(2,:)))
plot(t, rad2deg(u(3,:)))
plot(t, rad2deg(u(4,:)))

grid on

xlabel('Time [s]')
ylabel('Control Inputs')
xlim([0,t(end)])
box on
set(gca,'GridLineStyle','-')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridColor','k')
set(gca,'MinorGridColor','k')
set(findall(hFig, '-property', 'FontSize'), 'FontSize', fsz)

[hleg] = legend('$\delta_T$ [\%]','$\delta_e$ [$^\circ$]','$\delta_a$ [$^\circ$]','$\delta_r$ [$^\circ$]');
set(hleg,'EdgeColor',hleg.Color);
set(hleg,'Location','best');

% Plotting Positions
hFig            = figure(8); clf;
set(gcf, 'Color', [1 1 1]);
set(gca, 'Color', [1 1 1]);
hold on;
plot(t, beta)

grid on

xlabel('Time [s]')
ylabel('Sideslip Angle ($\beta$) [$^\circ$]')
xlim([0,t(end)])
box on
set(gca,'GridLineStyle','-')
set(gca,'MinorGridLineStyle','-')
set(gca,'GridColor','k')
set(gca,'MinorGridColor','k')
set(findall(hFig, '-property', 'FontSize'), 'FontSize', fsz)
end

