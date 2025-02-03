tpf = readmatrix("CustomTimeSeries\normalised.txt");

tpf = transpose(tpf);

mea = nan(2500);

for i = 1:2500
    x = PH_Walker(tpf(:, i), "momentum", 20);
    mea(i) = x.w_mean;
end

scatter(mea);

