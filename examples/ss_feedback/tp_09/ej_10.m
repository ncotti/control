clc; clear;

num = 1
den = conv([1 0.5], conv([1 0.1], [1 2]))
PLC = [(-0.8 + 1.1i), (-0.8 - 1.1i), -5];

[A, B, C, ~] = control_tf2ss(num, den)
[K, g0, PLC] = control_ss_feedback(A,B,C,PLC);
control_simulink("ej_10_simulink", 0:0.01:5, @(t) heaviside(t), [0 0 0]);
