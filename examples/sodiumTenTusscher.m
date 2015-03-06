function val = sodiumTenTusscher(V)

c1   = 1.0./(1.0+exp((V + 71.55)/7.43));
h_ss = c1.*c1;
j_ss = h_ss;
val = h_ss.*j_ss;
