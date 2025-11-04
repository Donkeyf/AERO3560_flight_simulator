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

% Convert quaternions in the state array to euler angles
quats = x(7:10, :);
euler_angles = q2e(quats);
euler_angles = rad2deg(euler_angles);

% Compute normal load factor with body rates
q = x(5,:);
n_z_q = q.*x(1,:)/9.81 + 1;

% Define custom colours
myred           = [216 30 49]/255;
myblue          = [27 99 157]/255;
myblack         = [0 0 0]/255;
mygreen         = [0 128 0]/255;
mycyan          = [2 169 226]/255;
myyellow        = [251 194 13]/255;
mygray          = [89 89 89]/255;

% Plot all key results 
figure(Name='Velocity');
grid on
hold on
plot(t, x(1,:))
plot(t, x(2,:))
plot(t, x(3,:))
xlabel('Time (s)')
ylabel('Velocity (m/s)')
xlim([0,t(end)])
legend('$u$', '$v$', '$w$', Location='best')
hold off

figure(Name='Body Rates');
grid on
hold on
plot(t, x(4,:))
plot(t, x(5,:))
plot(t, x(6,:))
xlabel('Time (s)')
ylabel('Body rates (rad/s)')
xlim([0,t(end)])
legend('$p$', '$q$', '$r$', Location='best')
hold off

figure(Name='Euler Angles');
grid on
hold on
plot(t, euler_angles(1,:))
plot(t, euler_angles(2,:))
plot(t, euler_angles(3,:))
xlabel('Time (s)')
ylabel('Euler angles (deg)')
xlim([0,t(end)])
ylim([-180,180])
yticks([-180,-90,0,90,180])
legend('$\phi$', '$\theta$', '$\psi$', Location='best')
hold off

figure(Name='Positions');
grid on
hold on
plot(t, x(11,:))
plot(t, x(12,:))
plot(t, x(13,:))
xlabel('Time (s)')
ylabel('Positions (m)')
xlim([0,t(end)])
legend('$x$', '$y$', '$z$', Location='best')
hold off

figure(Name='Load Factor');
grid on
hold on
plot(t, n_z_q)
xlabel('Time (s)')
ylabel('Load factor (-)')
xlim([0,t(end)])
% legend('$x$', '$y$', '$z$', Location='best')
hold off

figure(Name='3D Position');
plot3(x(11,:), x(12,:), -x(13,:), '-o', 'LineWidth', 1.5, 'MarkerSize', 5); 
xlabel('x (m)');
ylabel('y (m)');
zlabel('z (m)');
xlim([0,t(end)])
% title('3D Position Plot');
grid on; 
axis equal;
hold off

figure(Name='Controls')
hold on
plot(t, u(1,:))
plot(t, rad2deg(u(2,:)))
plot(t, rad2deg(u(3,:)))
plot(t, rad2deg(u(4,:)))
% plot(t, filtered_signal)
xlabel('Time (s)')
ylabel('$U$')
xlim([0,t(end)])
legend('$\delta_T$', '$\delta_e$',"$\delta_a$",'$\delta_r$',Location='southeast')
hold off

% sideslip = x(2,:)./x(1,:);
sideslip = x(2,:)./sqrt((x(1,:).^2 + x(2,:).^2 + x(3,:).^2));
beta = rad2deg(asin(sideslip));

figure(Name='Sideslip');
grid on
hold on
plot(t, beta)
xlabel('Time (s)')
ylabel('Sideslip angle (deg)')
xlim([0,t(end)])
hold off

figure(Name='Lift coefficient');
grid on
hold on
plot(t, CL)
xlabel('Time (s)')
ylabel('$C_L$ (-)')
xlim([0,t(end)])
hold off

figure(Name='Deviations');
grid on
hold on
plot(t, x(12,:) - x(12,1), color=myred)
plot(t, x(13,:) - x(13,1), color=myyellow)
xlabel('Time (s)')
ylabel('Positions (m)')
xlim([0,t(end)])
legend('$\Delta y$', '$\Delta z$', Location='best')
hold off

end

