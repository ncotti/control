%% Control TF to PID
% @brief:
%   Get the constants "Kp, Ki, Kd" from a transfer function.
%
% @args:
%   * sys: Transfer function tf(num, den);
%
% @return:
%   Kp, Ki, Kd: Proportional, integral and derivate constants.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function [Kp, Ki, Kd] = control_tf2pid(sys)
    arguments
        sys tf
    end
    
    sys
    [num, den] = tfdata(sys, "v")

    % Transfer for PID:
    % PID(s) = ( s^2*Kd + s*Kp + KI ) / s
    if ((length(num) == 3) && (den(2) == 1) && (den(end) == 0))
        disp("PID (Proportional-integral-derivative)")
        Kp = num(2)
        Kd = num(1)
        Ki = num(3)

    % Transfer for PI:
    % PI(s) = ( s*Kp + KI ) / s
    elseif ((length(num) == 2) && (den(1) == 1) && (den(end) == 0))
        disp("PI (proportional-integral)")
        Kp = num(1)
        Ki = num(2)
        kd = 0
    % Transfer for PD:
    % PD(s) = s*Kd + Kp
    elseif ((length(num) == 2) && isempty(den))
        disp("PD (proportional-derivative)")
        Kd = num(1)
        kp = num(2)
        ki = 0

    % No match for PID
    else
        error("No PID detected")
    end
end