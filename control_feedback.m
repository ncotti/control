%% Control feedback
% @brief:
%   Given a simple feedback loop as:
%                G(S)
%   M(S) =  ---------------
%            1 + G(S)*H(s)
%
%   This function analizes:
%   - Bode diagram of the closed loop transfer function M(S).
%   - Bode diagram of the feedback G(s)*H(s), with gain and phase margins.
%   - Nyquist plot for the feedback G(s)*H(s).
%   - Root locus of G(s)*H(s)
%
% @args:
%   * G(s)
%   * H(s)
%
% @Author: 
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_feedback(G, H)
    arguments
        G   tf
        H   tf
    end
    M = G / (1 + G*H);
    
    figure();
    bode(M);
    title("M(s) = G / (1 + G*H) bode diagram");
    grid on;
    
    figure();
    margin(G*H);
    title("G(s)*H(s) Bode diagram, with phase and gain margins");
    grid on;
    
    [gm, pm, wg, wp] = margin(G*H);
    fprintf("Gain margin:  %f dB at wg = %f\n", 20*log10(gm), wg);
    fprintf("Phase margin: %f° at wp = %f\n", pm, wp)
    
    figure();
    rlocus(G*H);
    sgrid;
    title("Rlocus of G(s)*H(s)");
    
    figure();
    nyquist(G*H, {1, 1e9});
    grid on;
end
