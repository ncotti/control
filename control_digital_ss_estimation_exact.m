%% Control Digital SS Feedback
% @brief:
%   Get the "Kd", "g0d" and "Ked" for the Estimated state vector feedback's
%   digital Simulink block.
%
% @args:
%   * A, B, C: State-Space (SS) matrixes.
%   * PLC: Desired closed loop poles for the system. If the amount of states
%  is not equal to the amount of poles, this vector is filled with poles
%  five times away from the most significant one.
%   * Which output to follow, corresponds to a single row of the C matrix.
%   * T: Sample time. Can be omitted.
%
% @return:
%   * Kd: state feedback vector.
%   * g0d: gain for null step response error.
%   * Ked: estimated state feedback vector.
%   * WO: Which output. Row vector used to select the C matrix's row and output.
%   * T: Digital sample time.
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function [Kd, g0d, Ked, WO, T, G, H, PLCd] = control_digital_ss_estimation_exact(A, B, C, PLC, which_output, T)
    arguments
        A                   (:,:) double
        B                   (:,:) double
        C                   (:,:) double
        PLC                 (1,:) double
        which_output        double = 1
        T                   double = -1
    end

    % Get C matrix's row
    Cn = C(which_output,:);
    WO = zeros(1, height(C));
    WO(which_output) = 1;

    [Kd, g0d, PLCd, T, G, H] = control_digital_ss_feedback(A,B,C,PLC, which_output);

    % Check observability of the system
    amount_of_states = width(A);
    if (rank(obsv(G,Cn)) ~= amount_of_states)
        error("SS is not observable. States: %d; Rank_control_matrix: %d", ...
            amount_of_states, rank(obsv(G,Cn)))
    end

    % Poles of the estimator should be 4 times away from the dominant poles
    PLC_estimator = real(PLC(1))*4 * ones(1, length(PLC));
    PLCd_estimator = exp(PLC_estimator*T)
    
    Ked = acker(G', Cn', PLCd_estimator)'
end