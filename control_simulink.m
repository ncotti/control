%% Control simulink
% @brief: Given a Simuink file ".slx", this functions gets the space state
%   matrixes of that system. After that, a temporal analisis is made with
%   the input function passed as argument. All variables used in the ".slx"
%   file must have been defined previously in the script before calling
%   this function.
function control_simulink(filename, t, input_function)
    arguments
        filename    string
        t           (1,:) double = 0:0.01:20
        input_function function_handle = @(t) heaviside(t)
    end

    [A, B, C, D] = linmod(filename);
    control_ss(A,B,C,D,t,input_function);
end