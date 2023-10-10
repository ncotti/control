%% Control SS Feedback Full
% @brief:
%   Get the temporal response of the transfer function in Laplace:
%   H(s) =  b_n*s^n + b_{n-1}*s^{n-1} + ... + b_1*s + b_0
%           ---------------------------------------------
%           a_n*s^n + a_{n-1}*s^{n-1} + ... + a_1*s + a_0
%
% @args:
%   * A, B, C, D: State Space (SS) matrixes.
%   * Mp: Overshoot, in percentage (40%) or proportional (0.4)
%   * ts: Establishment time to the 2%.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_ss_feedback_full (A, B, C, D, Mp, ts)
    arguments
        A                   (:,:) double
        B                   (:,:) double
        C                   (:,:) double
        D                   (:,:) double
        Mp                  double
        ts                  double
    end

    % Check if matrix is controllable
    [~, amount_of_states] = size(A);
    if (rank(ctrb(A,B)) ~= amount_of_states)
        sprintf("SS is not controllable. States: %d; Rank_control_matrix: %d", ...
            amount_of_states, rank(ctrb(A,B)))
        return;
    end

    % Get closed loops poles (PLC)
    if (Mp > 1)
        Mp = Mp / 100;
    end
    xi = abs(log(Mp)) / sqrt(pi^2 + (log(Mp))^2);
    wo = 4 / (xi*ts);
    re = -wo*xi;
    im = wo*sin(acos(xi));

    PLC = zeros(1, amount_of_states);
    PLC(1,1) = re + 1i*im;
    PLC(1,2) = re -1i*im;
    for i = 3:amount_of_states
        PLC(1,i) = 5*re;
    end
    disp("Closed loop poles:")
    PLC

    % Devolver g, k y PLC
    disp("SS feedback matrix:")
    K = acker(A,B,PLC)

    [amount_of_outputs, ~] = size(C);
    g0 = zeros(1, amount_of_outputs);
    for i = 1:amount_of_outputs
        g0(1,i) = 1/(C(i,:)*inv(B*K-A)*B);
    end
    disp("Pre-amplifier for null step error for each output:")
    g0
end
