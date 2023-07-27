function control_simulink(filename, t, input_function)
    arguments
        filename    string
        t           (1,:) double = 0:0.01:20
        input_function function_handle = @(t) heaviside(t)
    end

    [A, B, C, D] = linmod(filename);
    control_ss(A,B,C,D,t,input_function);
end