%% Control TF (Transfer function)
% @brief:
%   Get the temporal response of the transfer function in Laplace:
%   H(s) =  b_n*s^n + b_{n-1}*s^{n-1} + ... + b_1*s + b_0
%           ---------------------------------------------
%           a_n*s^n + a_{n-1}*s^{n-1} + ... + a_1*s + a_0
%
% @args:
%   * sys: Transfer function tf(num, den);
%   * t (optional): Time vector. Default value is 0:0.01:20.
%   * input_function (optional): The expression for x(t), as a
%   function_handle @(t) <math_expression>. Default value is the step
%   function u(t).
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_tf2 (sys, t, input_function)
    arguments
        sys                 tf
        t                   (1,:) double = 0:0.01:20
        input_function      function_handle = @(t) heaviside(t)
    end

    input=zeros(size(t));
    for i=1:length(t)
        input(i) = input_function(t(i));
    end

    y = lsim(sys, input, t);

    str = strcat( ...
        sprintf("TrueError = %.4f\n", input(end) - y(end)), ...
        sprintf("Bandwidth = %.4f [rad/seg]\n", bandwidth(sys)), ...
        sprintf("Overshoot = %.4f\n", stepinfo(sys).Overshoot), ...
        sprintf("SettlingTime 2%% = %.4f\n", stepinfo(sys).SettlingTime) ...
    );
    control_plot(y, input, t, str);

end