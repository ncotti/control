%% Frequency control examples
pm = 50;
kv = 20;
gm = 10;
G = tf(10, [1 1 0]);
control_design_raf_f(G, pm, gm, kv);
pm = 45;
kv = 20;
gm = 10;
G = tf(1, [1 2 0]);
control_design_rrf_f(G, pm, gm, kv);
pm = 50;
kv = 10;
gm = 10;
G = tf(2, conv([1 1 0], [1 4]));
control_design_rarf_f(G, pm, gm, kv, 5);
