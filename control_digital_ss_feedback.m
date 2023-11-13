%% Control Digital SS Feedback
% @brief:
%   Get the "Kd" and "k0" for the simulink's digital state vector feedback diagram.
% @args:
%  * A, B, C: State Space (SS) matrixes.
%  * PLC: Desired closed loop poles for the system. If the amount of states
%  is not equal to the amount of poles, this vector is filled with poles
%  five times away from the most significant one.
%  * which_output: Which row to use from the "C matrix" as output to
%  calculate "g0d".
%  * Sample time. Can be ommited.
%
% @return: 
%   * Kd: state feedback vector.
%   * god: gain for null step response error.
%   * PLCd, after adding the new ones five times away from the dominant
%   one, and converted to Z plane.
%   * T: Sample time.
%   * G, H: digital ss matrixes.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function [Kd, g0d, PLCd, T, G, H] = control_digital_ss_feedback(A, B, C, PLC, which_output, T)
    arguments
        A                   (:,:) double
        B                   (:,:) double
        C                   (:,:) double
        PLC                 (1,:) double
        which_output        double = 1
        T                   double = -1
    end

    % Fill the PLC array until it has the same size as the amount of states
    amount_of_states = width(A);
    if (length(PLC) ~= amount_of_states)
        for i = (length(PLC)+1):amount_of_states
            PLC(i) = real(PLC(1)) * 5;
        end
    end

    % Calculte sample time, if not passed as argument
    if (T == -1)
        T = abs(0.1 / real(PLC(1)));
    end
    disp("Tiempo de muestreo")
    T = T

    disp("Closed loop poles:")
    PLCd = exp(PLC.*T)

    % Get "G" and "H" matrix for digital space state
    [G, H] = c2d(A, B, T);
    
    % Check if matrix is controllable
    if (rank(ctrb(G,H)) ~= amount_of_states)
        error("SS is not controllable. States: %d; Rank_control_matrix: %d", ...
            amount_of_states, rank(ctrb(G,H)))
    end

    % Return K
    disp("SS feedback matrix:")
    Kd = acker(G,H,PLCd)

    % Return g0d
    g0d = 1/(C(which_output,:)*inv(eye(amount_of_states) + H*Kd - G)*H);
    fprintf("Pre-amplifier for null step error for output %d:", which_output);
    g0d = g0d
end
