tpf = readmatrix("CustomTimeSeries\normalised.txt");

tpf = transpose(tpf);

x = PH_Walker(tpf(:, 1275), "momentum", 2)