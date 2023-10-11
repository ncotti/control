%% Control plot
% @brief:
%   Plot ouput and input temporal functions.
%
% @args:
%   output: y(t), output values as vector.
%   input: x(t), input function values as vector.
%   t: temporal vector used for y(t) and x(t).
%   str: Additional text to add as an annotation
function control_plot(output, input, t, str)
    arguments
        output  (:,:) double
        input   (:,:) double
        t       (:,:) double
        str     string = ""
    end
    F1=figure();
    set(F1, 'NumberTitle','off',"name","Temporal response");
    plot(t, input, t, output);
    xlabel("t [seg]");
    ylabel("y(t)");
    title("Temporal Response");
    grid;
    legend("Input", "Output");
    if (str ~= "")
        annotation("textbox", "String", str, "FitBoxToText", "on");
    end
end