function val = sodiumGrandi(V)

h_ss = 1.0./(1.0+exp((V+71.55)/7.43)).^2.0;
j_ss = 1.0./(1.0+exp((V+71.55)/7.43)).^2.0;

val = h_ss.*j_ss;
