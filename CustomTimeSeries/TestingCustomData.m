tpf = readmatrix("CustomTimeSeries\periodic.csv");

n = 100;


mea = nan(n);
medi = nan(n);
stds = nan(n);
absdiff = nan(n);
freq = nan(n);

%increasing mass
for i = 1:50
    x = PH_Walker(tpf(:, i), "momentum", 200); %frquency 0.0707 hz
    mea(i) = x.w_mean;
    medi(i) = x.sw_taudiff;
    stds(i) = x.w_std;
    absdiff(i) = x.sw_meanabsdiff;
    freq(i) = 0.01 +(i-1) * (0.29/100);
    freq(i) = 1/(freq(i) ^ 2);

end

figure(1);
semilogx(freq, mea);
title("mean");
xlabel("mass");
ylabel("statistic");

figure(2);
semilogx(freq, medi);
title("median");
xlabel("mass");
ylabel("statistic");

figure(3);
semilogx(freq, stds);
title("standard deviation");
xlabel("mass");
ylabel("statistic");

figure(4);
semilogx(freq, absdiff);
title("mean absolute difference");
xlabel("mass");
ylabel("statistic");

%figure(5)
%semilogx(tpf(:, 10));