function [U_t] = Controls(i,U_input,U_trim)
    % Determines the control vector for a given timestep
    U_t = U_trim + U_input(:,i);
end