%% This example makes a feedback of a fully accessible and known state vector.
clc; clear; close all;

M = 2;
m = 0.5;
l = 0.5;
g = 9.81;

A = [0 1 0 0;
     (M+m)*g/(M*l) 0 0 0;
     0 0 0 1;
     -m*g/M 0 0 0];
B = [0;-1/(M*l);0;1/M] ;
C = [1 0 0 0;0 0 1 0];
D = [0;0];

Mp = 16.3;
ts = 4;

[K, g0] = control_ss_feedback(A, B, C, D, Mp, ts);
g0 = g0(2);

control_simulink("state_vector_feedback");
