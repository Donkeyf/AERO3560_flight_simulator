function [U_t] = Controls(i,U_input)
    % Determines the control vector for a given timestep
    U_t = U_input(:,i);
end