function val = sodiumOHara(V)

h_ss = 1.0./(1.0+exp((V+82.90)/6.086));

val = h_ss.*h_ss;
