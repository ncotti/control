%% Control Design RAF (Red Adelanto de Fase) in frequency
% @brief:
%   Given a unity feedback loop as:
%              G(S)
%   M(S) =  -----------
%            1 + G(S)
%
%   This function designs a RAF to satisfy Phase Margin, Gain Margin, and
%   error in static conditions.
%                   s + 1/T
%   Gc(S) =  Kc * -----------------   0 < alpha < 1
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
function control_design_raf_f(G, pm, gm, kv, extra_phase, w)
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

    % Margen de fase inicial
    [gmi, pmi] = margin(kc_alpha*G);

    % Angulo a agregar
    theta = pm - pmi + extra_phase;
    
    % Se obtiene el valor de "alpha"
    alpha = ( 1 - sin(deg2rad(theta)) ) / (1 + sin(deg2rad(theta)));

    % Se busca el punto de frecuencia donde |k*G| == sqrt(alpha)
    [mag, phase] = bode(kc_alpha*G, w);
    diff = 100;
    index = 1;
    for i = 1:length(w)
        if (abs(mag(i) - sqrt(alpha)) < diff  )
             diff = abs(mag(i) - sqrt(alpha));
             index = i;
        end
    end

    zero = w(index)*sqrt(alpha)
    pole = zero/alpha
    kc = kc_alpha/alpha
    RAF = tf(kc*[1 zero], [1 pole])

    figure_raf=figure();
    set(figure_raf, 'NumberTitle','off', 'name','Bode for RAF Gc(s)*G(s)');
    margin(RAF*G);
    t = 0:0.01:50;
    u = @(t) t*heaviside(t);
    control_tf2(G*RAF/(1+RAF*G), t, u);
end