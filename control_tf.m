%% Control TF (Transfer function)
% @brief:
%   Get the temporal response of the transfer function in Laplace:
%   H(s) =  b_n*s^n + b_{n-1}*s^{n-1} + ... + b_1*s + b_0
%           ---------------------------------------------
%           a_n*s^n + a_{n-1}*s^{n-1} + ... + a_1*s + a_0
%
% @args:
%   * num: [a_n, a_(n-1), ... , a_1, a_0]. Constants that multiply
%   the output's derivatives.
%   * den: [b_n, b_(n-1), ... , b_1, b_0]. Constants that multiply
%   the input's derivatives.
%   * t (optional): Time vector. Default value is 0:0.01:20.
%   * input_function (optional): The expression for x(t), as a
%   function_handle @(t) <math_expression>. Default value is the step
%   function u(t).
%
% @Author: 
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_tf (num, den, t, input_function)
    arguments
        num                 (1,:) double
        den                 (1,:) double
        t                   (1,:) double = 0:0.01:20
        input_function      function_handle = @(t) heaviside(t)
    end

    control_tf2(tf(num,den),t,input_function);
end