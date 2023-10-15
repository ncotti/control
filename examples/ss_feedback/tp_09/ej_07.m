clc; clear;

A = [0 1; 3 0];
B = [0; 1];
C = [1,0; 0 1];
X0 = [-1 1];

[K, ~, PLC] = control_ss_feedback(A,B,C,[-2.75 -3.08]);
g0 = 0;
control_simulink("ej_07_simulink", 0:0.01:3, @(t) 0, X0);