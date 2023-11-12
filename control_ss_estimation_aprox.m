%% Control SS Feedback
% @brief:
%   Get the "K", "g00" and "Ke" for the Aprox Estimated state vector 
%   feedback's Simulink block.
%
% @args:
%   * A, B, C: State-Space (SS) matrixes.
%   * PLC: Desired closed loop poles for the system. If the amount of states
%  is not equal to the amount of poles, this vector is filled with poles
%  five times away from the most significant one.
%   * Which output to follow, corresponds to a single row of the C matrix.
%
% @return:
%   * K: state feedback vector.
%   * g00: gain for null step response error.
%   * Ke: estimated state feedback vector.
%   * WO: Which output. Row vector used to select the C matrix's row and output.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function [K, g00, Ke, T] = control_ss_estimation_aprox(A, B, C, PLC, which_output)
    arguments
        A                   (:,:) double
        B                   (:,:) double
        C                   (:,:) double
        PLC                 (1,:) double
        which_output        double = 1
    end

    % Get C matrix's row
    Cn = C(which_output,:);
    T = zeros(1, height(C));
    T(which_output) = 1;

    % Check observability of the system
    amount_of_states = width(A);
    if (rank(obsv(A,Cn)) ~= amount_of_states)
        error("SS is not observable. States: %d; Rank_control_matrix: %d", ...
            amount_of_states, rank(obsv(A,Cn)))
    end

    [K, ~, PLC] = control_ss_feedback(A,B,C,PLC, which_output);

    % Poles of the estimator should be 4 times away from the dominant poles
    PLC_estimator = real(PLC(1))*4 * ones(1, length(PLC))
    
    Ke = acker(A', Cn', PLC_estimator)'

    % Calculate g00
    % Get transfer for the SS system alone
    [n, d] = ss2tf(A,B,Cn,0);
    G = tf(n, d);

    % Get transfer of the ss observer
    % x~'(t) = (A - Ke*C - B*K)*X~(t) + Ke*Y(t)
    % Y(t) = K*(-U(t))  
    [n, d] = ss2tf(A-Ke*Cn-B*K, Ke, K, 0);
    H = tf(n, d);
    M = feedback(G,H);
    [num,den] = tfdata(M,'v');
    num_tinf = num(end);
    den_tinf = den(end);
    g00 = den_tinf/num_tinf

end