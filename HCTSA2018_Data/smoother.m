set = "StarLightCurves";
dataset = "Normalized/HCTSA_" + set + "_N.mat";
dataset = convertStringsToChars(dataset);

[TS_DataMat,TimeSeries,Operations,~] = TS_LoadData(dataset);

ts = cell2mat(transpose(TimeSeries.Data));
labels = double(TimeSeries.Group);
test = contains(TimeSeries.Keywords, "TRAIN");


time = zeros(size(ts));
col = size(ts);
N = col(1);
col = col(2);
m = 1;

for j = 1:col

    w = time(:, j);
    y = ts(:, j);

    w(1) = y(1);
    w(2) = y(2);
    for k = 3:N
        w_inert = w(k-1) + (w(k-1)-w(k-2));
        w(k) = w_inert + (y(k)-w_inert)/m;
    end

    time(:, j) = w;

end

time = transpose(time);

result = [labels, test, time];

writematrix(result, sprintf("Smoothed/%s_smoothed.csv", set));


