function []=plotData(X,X_dot,U,time)

%Plot the data
for i=1:1:length(time)
    u(i)=X(1,i);
    v(i)=X(2,i);
    w(i)=X(3,i);
    p(i)=X(4,i).*(180/pi);
    q(i)=X(5,i).*(180/pi);
    r(i)=X(6,i).*(180/pi);
    phi(i)=X(7,i);
    theta(i)=X(8,i);
    psi(i)=X(9,i);
    x(i)=X(11,i);
    y(i)=X(12,i);
    z(i)=X(13,i);
    dT(i) = U(1,i);
    de(i) = U(2,i).*(180/pi);
    da(i) = U(3,i).*(180/pi);
    dr(i) = U(4,i).*(180/pi); 
end
%-------------Sate Variable Plot
%%U
figure(1);
plot(time,u,'*-','LineWidth',2,'Color', 'm');
xlabel("time (sec)");
ylabel("Velocity in X (m/s)");
%%V
figure(2);
plot(time,v,'*-','LineWidth',2,'Color', 'b');
xlabel("time (sec)");
ylabel("Velocity in Y (m/s)");
%%W
figure(3);
plot(time,w,'*-','LineWidth',2,'Color', 'g');
xlabel("time (sec)");
ylabel("Velocity in Z (m/s)");
%%Roll
figure(4);
plot(time,p,'o-','LineWidth',2,'Color', 'c');
xlabel("time (sec)");
ylabel("Roll rate (degrees/s)");
%%Pitch
figure(5);
plot(time,q,'o-','LineWidth',2,'Color', 'orange');
xlabel("time (sec)");
ylabel(" Pitch rate (degrees/s)");
%%Yaw
figure(6);
plot(time,r,'o-','LineWidth',2,'Color', 'y');
xlabel("time (sec)");
ylabel("Yaw rate (degrees/s)");

%%-----------------Attitude 
%%%Roll angle
figure(7);
plot(time,phi,'o-',LineWidth',2,'Color', 'r');    
xlabel('Time(s)');
ylabel('Roll Angle (degrees)');
%%%Pitch Angle
figure(8);
plot(time,theta,'o-',LineWidth',2,'Color', 'b');    
xlabel('Time(s)');
ylabel('Pitch Angle (degrees)');
%%%Pitch Angle
figure(9);
plot(time,psi,'o-',LineWidth',2,'Color', 'y');    
xlabel('Time(s)');
ylabel('Yaw Angle (degrees)');
Yaw Angle
%%%Position X
figure(10);
plot(time,x,'o-',LineWidth',2,'Color', 'purple');    
xlabel('Time(s)');
ylabel('Position in X-axis (m)');
%%%Position Y
figure(11);
plot(time,y,'o-',LineWidth',2,'Color', 'c');    
xlabel('Time(s)');
ylabel('Position in Y-axis (m)');
%%%Position Z
figure(12);
plot(time,-z,'o-',LineWidth',2,'Color', 'c');    
xlabel('Time(s)');
ylabel('Position in Z-axis (m)');
%%% Thrust Setting
figure(13);
plot(time,dT,'o-',LineWidth',2,'Color', 'g');    
xlabel('Time(s)');
ylabel('Thrust Setting (deg)');
%%% Elevator Deflection 
figure(14);
plot(time,de,'o-',LineWidth',2,'Color', 'r');    
xlabel('Time(s)');
ylabel('Elevator Deflection (deg)');
%%% Aileron Deflection 
figure(15);
plot(time,da,'o-',LineWidth',2,'Color', 'm');    
xlabel('Time(s)');
ylabel('Aileron Deflection (deg)');
%%% Rudder Deflection
figure(16);
plot(time,dr,'o-',LineWidth',2,'Color', 'y');    
xlabel('Time(s)');
ylabel('Rudder Deflection (deg)');
end 





