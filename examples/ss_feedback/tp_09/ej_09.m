clc; clear;

PLC = [(-2 + 1i*2*sqrt(3)), (-2 - 1i*2*sqrt(3)), -12];
transfer = tf([1], conv([1 1 0], [1 2]))
X0 = 0;

[num, den] = tfdata(transfer, "v");
[A, B, C, ~] = control_tf2ss(num, den);
[K, g0, PLC] = control_ss_feedback(A, B, C, PLC);
control_simulink("ej_09_simulink", 0:0.01:4, @(t) heaviside(t), X0)