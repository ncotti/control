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
    legend_str = "U(t)";
    for i = 1:width(output)
        legend_str(i+1) = sprintf("y_%d(t)", i);
    end
    legend(legend_str);
    if (str ~= "")
        annotation("textbox", "String", str, "FitBoxToText", "on");
    end
end