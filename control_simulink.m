%% Control simulink
% @brief: Given a Simuink file ".slx", this function gets the state space
%   matrixes of the system (ABCD). After that, a temporal analysis is made.
%
%   All variables used in the ".slx" file must have been defined previously
%   in the script before calling this function.
%
% @args
%  * filename: Name of the simulink file, without ".slx".
%  * t: Time vector. If "t" only has one element, a discrete analysis will
%  be made.
%  * input_function: Time dependant iinput function.
%  * X0: Intial conditions for the state-space vector of the system.
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_simulink(filename, t, input_function, X0)
    arguments
        filename    string
        t           (1,:) double = 0:0.01:20
        input_function function_handle = @(t) heaviside(t)
        X0          (1,:) double = 0
    end
    
    if (length(t) == 1)
        [A, B, C, D] = dlinmod(filename, 0);
        t = 0:0.01:20;
    else
        [A, B, C, D] = linmod(filename);
    end

    if ((X0 == 0) & (length(X0) == 1))
        for i = 1:height(B)
            X0(i) = 0;
        end
    end

    control_ss(A, B, C, D, t, input_function, X0);
end