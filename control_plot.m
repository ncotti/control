%% Control plot
% @brief:
%   Plot ouput and input temporal functions.
% 
% @args:
%   output: y(t), output values as vector.
%   input: x(t), input function values as vector.
%   t: temporal vector used for y(t) and x(t).
function control_plot(output, input, t)
    H1=figure();
    set(H1,"name","Respuesta temporal");
    subplot(2,1,1);
        plot(t, output, "b");
        xlabel("t [seg]");
        ylabel("y(t)");
        title("Output");
        grid;
    subplot(2,1,2);
        plot(t, input, "b");
        xlabel("t [seg]");
        ylabel("x(t)");
        title("Input");
        grid;
end