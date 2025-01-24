tpf = readmatrix("CustomTimeSeries\normalised.txt");

tpf = transpose(tpf);

x = PH_Walker(tpf(:, 1276), "momentum", 50) 