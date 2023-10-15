%% Control get PLC (Closed loop poles)
% @brief:
%   Given the overshoot (Mp) and the setting time (ts), this function
%   returns the pair of commplex conjugated poles.
%
% @args:
%   * Mp: Overshoot [% or proportional]
%   * ts: Setting time to 2%.
%
% @return:
%   Closed loop poles for second order underdamped system.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function PLC = control_get_plc(Mp, ts)
    if (Mp > 1)
        Mp = Mp / 100;
    end
    xi = abs(log(Mp)) / sqrt(pi^2 + (log(Mp))^2);
    wo = 4 / (xi*ts);
    re = -wo*xi;
    im = wo*sin(acos(xi));

    PLC = [(re + 1i*im), (re - 1i*im)];
end