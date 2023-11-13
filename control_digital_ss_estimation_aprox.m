%% Control SS Estimation Aprox
% @brief:
%   Get the "Kd", "g00d" and "Ked" for the Digital Aprox Estimated 
%   state vector feedback's Simulink block.
%
% @args:
%   * A, B, C: State-Space (SS) matrixes.
%   * PLC: Desired closed loop poles for the system. If the amount of states
%  is not equal to the amount of poles, this vector is filled with poles
%  five times away from the most significant one.
%   * Which output to follow, corresponds to a single row of the C matrix.
%   * T: sampling time.
%
% @return:
%   * Kd: state feedback vector.
%   * g00d: gain for null step response error.
%   * Ked: estimated state feedback vector.
%   * WO: Which output. Row vector used to select the C matrix's row and output.
%   * T: sampling time.
%   * G, H: digital state space matrixes.
%   * PLCd: Closed loop digital poles.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function [Kd, g00d, Ked, WO, T, G, H, PLCd] = control_ss_estimation_aprox(A, B, C, PLC, which_output, T)
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

    [Kd, ~, PLCd, T, G, H] = control_digital_ss_feedback(A,B,C,PLC, which_output, T);

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

    % Calculate g00
    % Get transfer for the SS system alone
    [n, d] = ss2tf(A,B,Cn,0);
    Gd = tf(n, d);
    [n, d] = c2d(Gd, T);
    Gd = tf(n, d, T);

    % Get transfer of the ss observer
    % x~[k+1] = (G - Ked*C - H*K)*X[k] + Ked*Y(t)
    % Y(t) = Kd*(-U(t))  
    [n, d] = ss2tf(G-Ked*Cn-H*Kd,Ked,Kd,0);
    Hd = tf(n, d, T);
    Md = feedback(Gd,Hd);
    [num,den] = tfdata(Md,'v');
    g00d = polyval(den,1)/polyval(num,1)

end