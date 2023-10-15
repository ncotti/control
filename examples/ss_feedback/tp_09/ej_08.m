clc; clear;

A = [0 1 0; 0 0 1; -1 -5 -6];
B = [0; 0; 1];
C = [1 0 0; 0 1 0; 0 0 1];
X0 = [1 0 0];

PLC = [-2+4i, -2-4i, -10];

[K, ~, PLC] = control_ss_feedback(A,B,C,PLC);
g0 = 0;
control_simulink("ej_08_simulink", 0:0.01:3, @(t) 0, X0);
