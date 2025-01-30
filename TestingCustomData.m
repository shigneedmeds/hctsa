tpf = readmatrix("CustomTimeSeries\sin_noisy.csv");

n = 100;


mea = nan(n);
medi = nan(n);
stds = nan(n);
absdiff = nan(n);
freq = nan(n);

%increasing frequency
for i = 1:100
    x = PH_Walker(tpf(:, i), "momentum", 200);
    mea(i) = x.w_mean;
    medi(i) = x.w_median;
    stds(i) = x.w_std;
    absdiff(i) = x.sw_meanabsdiff;
    freq(i) = 0.01 +(i-1) * (0.29/100);

end

figure(1);
plot(freq, mea);
title("mean");
xlabel("frequency");
ylabel("statistic");

figure(2);
plot(freq, medi);
title("median");
xlabel("frequency");
ylabel("statistic");

figure(3);
plot(freq, stds);
title("standard deviation");
xlabel("frequency");
ylabel("statistic");

figure(4);
plot(freq, absdiff);
title("mean absolute difference");
xlabel("frequency");
ylabel("statistic");

%figure(5)
%plot(tpf(:, 10));