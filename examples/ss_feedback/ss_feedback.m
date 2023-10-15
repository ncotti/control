clc; clear; close all;

M = 2;
m = 0.5;
l = 0.5;
g = 9.81;

A = [0 1 0 0;
     (M+m)*g/(M*l) 0 0 0;
     0 0 0 1;
     -m*g/M 0 0 0];
B = [0;-1/(M*l);0;1/M];
C = [1 0 0 0;0 0 1 0];

Mp = 16.3;
ts = 4;

PLC = control_get_plc(Mp, ts);

[K, g0, ~] = control_ss_feedback(A, B, C, PLC, 2);

control_simulink("ss_feedback_simulink", 0:0.01:5);
