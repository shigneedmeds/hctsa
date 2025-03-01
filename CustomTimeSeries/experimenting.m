tpf = readmatrix("CustomTimeSeries\sin_noisy.csv");


x = PH_Walker(tpf(:,5), "momentum", 2);