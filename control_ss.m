%% Control SS (State Space)
% @brief:
%   Solve the state space equation system given by:
%   [x1' x2' ... xn']T = A*[x1 x2 ... xn]T + B*[u1 u2 ... um]T
%   [y1  y2 ...  yr ]T = C*[x1 x2 ... xn]T + D*[u1 u2 ... um]T
% @args:
%   * num: [a_n, a_(n-1), ... , a_1, a_0]. Constants that multiply
%   the output's derivatives.
%   * den: [b_n, b_(n-1), ... , b_1, b_0]. Constants that multiply
%   the input's derivatives.
%   * t (optional): Time vector. Default value is 0:0.01:20.
%   * input_function (optional): The expression for x(t), as a
%   function_handle @(t) <math_expression>. Default value is the step
%   function u(t).
%   * initial_conditions (optional): [x1(0) x2(0) ... xn(0)]. Initial
%   values of the state variables.
%
% @Author: 
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_ss (A, B, C, D, t, input_function, initial_conditions)
    arguments
        A (:,:) double
        B (:,:) double
        C (:,:) double
        D (:,:) double
        t                   (1,:) double = 0:0.01:20
        input_function      function_handle = @(t) heaviside(t)
        initial_conditions  (1,:) double = zeros(1, height(B))
    end

    input=zeros(size(t));
    for i=1:length(t)
        input(i) = input_function(t(i));
    end

    y = lsim(ss(A,B,C,D), input, t, initial_conditions);
    control_plot(y, input, t);
end