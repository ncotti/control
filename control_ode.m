%% Control Ode
% @brief:
%   Solve the differential equation for output y(t) and input x(t) as:
%   a_n * d(n)/dt(n) y(t) + a_(n-1) * d(n-1)/dt(n-1) y(t) +...+ a_1 * d/dt y(t) + a_0 =
%   b_n * d(n)/dt(n) x(t) + b_(n-1) * d(n-1)/dt(n-1) x(t) +...+ b_1 * d/dt x(t) + b_0
%
% @args:
%   * output_vector: [a_n, a_(n-1), ... , a_1, a_0]. Constants that multiply
%   the output's derivatives (H(s) = input_vector/output_vector).
%   * input_vector: [b_n, b_(n-1), ... , b_1, b_0]. Constants that multiply
%   the input's derivatives.
%   * t (optional): Time vector [T0, TF]. Default value is [0, 10]. 
%   * input_function (optional): The expression for x(t), as a
%   function_handle @(t) <math_expression>. Default value is the step
%   function u(t).
%   * initial_conditions (optional): [d(n-1)/dt(n-1) y(t=0),..., d/dt y(t=0), y(t=0)].
%   Initial conditions of the system. Default value is [0,0,...,0].
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_ode (output_vector, input_vector, t, input_function, initial_conditions)
    arguments
        output_vector       (1,:) double
        input_vector        (1,:) double
        t                   (1,:) double = [0, 10]
        input_function      function_handle = @(t) heaviside(t)
        initial_conditions  (1,:) double = zeros(1,max(length(output_vector), length(input_vector)) - 1)
    end

    t = [t(1), t(length(t))];
    [A, B, C, D] = control_tf2ss(input_vector, output_vector);
    [t, X] = ode45(@(t,X) odefun(t,X,A,B), t, initial_conditions);
    Y = C*X' + D*input_function(t)';

    input=zeros(size(t));
    for i=1:length(t)
        input(i) = input_function(t(i));
    end

    control_plot(Y, input, t);

    function dx_dt = odefun (t, X, A, B)
        dx_dt = A*X + B*input_function(t);
    end
end






