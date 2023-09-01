%% Control Design RARF (Red Adelanto Retraso de Fase) in frequency
% @brief:
%   Given a unity feedback loop as:
%              G(S)
%   M(S) =  -----------
%            1 + G(S)
%
%   This function designs a RARF to satisfy Phase Margin, Gain Margin, and
%   error in static conditions.
%                     s + 1/T1          s + 1/T2
%   Gc(S) =  Kc * --------------- * -----------------  beta > 1
%                   s + beta/T1       s + 1/(beta*T2)
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
function control_design_rarf_f(G, pm, gm, kv, extra_phase, w)
    arguments
        G           tf
        pm          double
        gm          double
        kv          double
        extra_phase double = 10
        w           (:,1) = 0.01:0.01:100
    end
    
    % Kv = lim (s->0) s*kc*G(s)
    % kc = kv / lim (s->0) s * G(s)
    [num, den] = tfdata(G);
    kc = kv / (num{1}(end)/den{1}(end-1));

    % Se busca el punto de frecuencia donde la fase es -180.
    [mag, phase] = bode(kc*G, w);
    diff = 100;
    index = 1;
    for i = 1:length(w)
        if (abs(phase(i) - -180) < diff  )
             diff = abs(phase(i) - -180);
             index = i;
        end
    end
    w(index)
    mag(index)

    % Angulo a agregar
    theta = pm + extra_phase;
    
    % Se obtiene el valor de "beta"
    beta = ( 1 + sin(deg2rad(theta)) ) / (1 - sin(deg2rad(theta)))

    zero_rrf = w(index)/10
    pole_rrf = zero_rrf/beta
    zero_raf = w(index)*mag(index)/beta
    pole_raf = zero_raf*beta
    kc
    RARF = tf(kc*[1 zero_rrf], [1 pole_rrf]) * tf([1 zero_raf], [1 pole_raf])

    figure_raf=figure();
    set(figure_raf, 'NumberTitle','off', 'name','Bode for RAF Gc(s)*G(s)');
    margin(RARF*G);
    t = 0:0.01:50;
    u = @(t) t*heaviside(t);
    control_tf2(G*RARF/(1+RARF*G), t, u);
end