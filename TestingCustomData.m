tpf = readmatrix("CustomTimeSeries\sin.csv");

mea = nan(50);
medi = nan(50);
stds = nan(50);
absdiff = nan(50);

%increasing frequency
for i = 1:50
    x = PH_Walker(tpf(:, i), "momentum", 50);
    mea(i) = x.w_mean;
    medi(i) = x.w_median;
    stds(i) = x.w_std;
    absdiff(i) = x.sw_meanabsdiff;
end

figure(1);
plot(mea);
title("mean");
xlabel("frequency");
ylabel("statistic");

figure(2);
plot(medi);
title("median");
xlabel("frequency");
ylabel("statistic");

figure(3);
plot(stds);
title("standard deviation");
xlabel("frequency");
ylabel("statistic");

figure(4);
plot(absdiff);
title("mean absolute difference");
xlabel("frequency");
ylabel("statistic");

%figure(5)
%plot(tpf(:, 10));