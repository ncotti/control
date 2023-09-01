%% Control Design RRF (Red Retardo de Fase) in frequency
% @brief:
%   Given a unity feedback loop as:
%              G(S)
%   M(S) =  -----------
%            1 + G(S)
%
%   This function designs a RRF to satisfy Phase Margin, Gain Margin, and
%   error in static conditions.
%                   s + 1/T
%   Gc(S) =  Kc * -----------------   alpha > 1
%                   s + 1/(alpha*T)
%
% @args:
%   * G: Open loop gain of the system.
%   * pm: Phase margin desired.
%   * gm: Gain margin desired.
%   * kv: Type I system gain desired (inverse of error to velocity).
%   * extra_phase: Extra phase added to ensure the mf desired (5-12°).
%   * w: Vector of angular frequency, for higher resolution in the bode
%   plot
%
% @Author:
%   Nicolas Gabriel Cotti (ngcotti@gmail.com)
function control_design_rrf_f(G, pm, gm, kv, extra_phase, w)
    arguments
        G           tf
        pm          double
        gm          double
        kv          double
        extra_phase double = 10
        w           (:,1) = 0.01:0.01:100
    end
    
    % Kv = lim (s->0) s*kc*alpha*G(s)
    % kc_alpha = kv / lim (s->0) s * G(s)
    [num, den] = tfdata(G);
    kc_alpha = kv / (num{1}(end)/den{1}(end-1));

    % Angulo a agregar
    theta = -180 + pm + extra_phase;
    
    % Se busca el punto de frecuencia donde el angulo es igual al margen de
    % fase
    [mag, phase] = bode(kc_alpha*G, w);
    diff = 100;
    index = 1;
    for i = 1:length(w)
        if (abs(phase(i) - theta) < diff  )
             diff = abs(phase(i) - theta);
             index = i;
        end
    end

    alpha = mag(index)

    zero = w(index)/10
    pole = zero/alpha
    kc = kc_alpha/alpha
    RRF = tf(kc*[1 zero], [1 pole])

    figure_rrf=figure();
    set(figure_rrf, 'NumberTitle','off', 'name','Bode for RRF Gc(s)*G(s)');
    margin(RRF*G);
    t = 0:0.01:50;
    u = @(t) t*heaviside(t);
    control_tf2(G*RRF/(1+RRF*G), t, u);
end