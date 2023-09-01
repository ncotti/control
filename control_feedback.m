%% Control feedback
% @brief:
%   Given a simple feedback loop as:
%                G(S)
%   M(S) =  ---------------
%            1 + G(S)*H(s)
%
%   This function analizes:
%   - Bode diagram of the characteristic function G(s)*H(s), with gain and phase margins.
%   - Nyquist plot for the feedback G(s)*H(s).
%   - Root locus of G(s)*H(s).
%   - Temporal plot of the system to a step and a ramp.
%
% @args:
%   * G(s)
%   * H(s)
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_feedback(G, H, t, input_function)
    arguments
        G                   tf
        H                   tf = 1
        t                   (1,:) double = 0:0.01:20
        input_function      function_handle = @(t) heaviside(t)
    end
    M = G / (1 + G*H);

    figure();
    margin(G*H);
    grid on;

    figure();
    rlocus(G*H);
    sgrid;

    figure();
    nyquist(G*H, {1, 1e9});
    grid on;

    control_tf2(M, t, input_function);
    polos = pole(M)
    ceros = pole(M^-1)
end
