%% Control SS Feedback
% @brief:
%   Get the "K" and "g0" for the simulink state vector feedback diagram.
% @args:
%  * A, B, C: State Space (SS) matrixes.
%  * PLC: Desired closed loop poles for the system. If the amount of states
%  is not equal to the amount of poles, this vector is filled with poles
%  five times away from the most significant one.
%  * which_output: Which row to use from the "C matrix" as output to
%  calculate "g0".
%
% @return: 
%   * K: state feedback vector.
%   * g0: gain for null step response error.
%   * PLC, after adding the new ones five times away from the dominant one.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function [K, g0, PLC] = control_ss_feedback(A, B, C, PLC, which_output)
    arguments
        A                   (:,:) double
        B                   (:,:) double
        C                   (:,:) double
        PLC                 (1,:) double
        which_output        double = 1
    end

    % Fill the PLC array until it has the same size as the amount of states
    amount_of_states = width(A);
    if (length(PLC) ~= amount_of_states)
        for i = (length(PLC)+1):amount_of_states
            PLC(i) = real(PLC(1)) * 5;
        end
    end
    disp("Closed loop poles:")
    PLC

    % Check if matrix is controllable
    if (rank(ctrb(A,B)) ~= amount_of_states)
        error("SS is not controllable. States: %d; Rank_control_matrix: %d", ...
            amount_of_states, rank(ctrb(A,B)))
    end

    % Return K
    disp("SS feedback matrix:")
    K = acker(A,B,PLC)

    % Return g0
    g0 = 1/(C(which_output,:)*inv(B*K-A)*B);
    fprintf("Pre-amplifier for null step error for output %d:", which_output);
    g0
end
