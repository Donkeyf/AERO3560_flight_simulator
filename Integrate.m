function [] = Integrate(FlightData, X0, Xdot0, U0, time, dt)
    
    % Save data from the angular rate converging file into here (AngularRateConvergence needs to be checked)
    
    x_n = AngularRateConvergence(FlightData, X0, Xdot0, U0, time, dt);

    % Calculating the gradient at each step
    x1 = x_n;
    a1 = x1 .* dt;

    x2 = x1 + (a1./2);
    a2 = x2 .* dt;

    x3 = x1 + (a2./2);
    a3 = x3 .* dt;

    x4 = x1 + a3;
    a4 = x4 .* dt;

    % Working out the vector at each respective step
    xn = X0 + ((1/6).*(a1 + (2.*a2) + (2.*a3) + a4));
end