%% Control TF2SS
% @brief:
%   Get the logical state representation of the transfer function:
%   H(s) =  b_n*s^n + b_{n-1}*s^{n-1} + ... + b_1*s + b_0
%           ---------------------------------------------
%           a_n*s^n + a_{n-1}*s^{n-1} + ... + a_1*s + a_0
%
%   For example, for a fourth degree equation:
%   A = [ 0      1      0      0   ]    B = [ 0 ]
%       [ 0      0      1      0   ]        [ 0 ]
%       [ 0      0      0      1   ]        [ 0 ]
%       [ -a0   -a1    -a2    -a3  ]        [ 1 ]
%
%   C = [ b0 - b4*a0 | b1 - b4*a1 | b2 - b4*a2 | b3 - b4*a3 ]  D = [ b4 ]
function [A,B,C,D] = control_tf2ss(num, den)
    [A, B, C, D] = tf2ss(num, den); % [num, den] = tfdata(SYS, "v")
    A = rot90(A,2);
    B = flipud(B);
    C = fliplr(C);
end