dataset = 'Normalized/HCTSA_Herring_N.mat';

[TS_DataMat,TimeSeries,Operations,~] = TS_LoadData(dataset);

no_groups = max(double(TimeSeries.Group));



for i = 0:no_groups - 1
    ts = cell2mat(transpose(TimeSeries(TimeSeries.Group == string(i), :).Data));
    col = size(ts);
    col = col(2);
    cols = 1:10;

    %figure();

    subplot(no_groups,1, i + 1);
    
    plot(ts(:, [cols]), "LineWidth", 0.5, "Color", "b");
    hold on;
    plot(mean(ts, 2), "LineWidth", 2, "Color", "r");
    
    hold off;
    %legend({"mean", string(i)}, {"r", "b"})

end

figure();

for i = 0:no_groups - 1
    ts = cell2mat(transpose(TimeSeries(TimeSeries.Group == string(i), :).Data));
    col = size(ts);
    N = col(1);
    col = col(2);
    %cols = randperm(col, 10);

    time = zeros(size(ts));

    for j = 1:col
        m = 5;
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
    %figure();

    subplot(no_groups,1, i + 1);
    
    plot(time(:, [cols]), "LineWidth", 0.5, "Color", "b");
    hold on;
    plot(mean(time, 2), "LineWidth", 2, "Color", "r");
    
    hold off;
    %legend({"mean", string(i)}, {"r", "b"})

end


figure();

for i = 0:no_groups - 1
    ts = cell2mat(transpose(TimeSeries(TimeSeries.Group == string(i), :).Data));
    col = size(ts);
    row = col(1);
    col = col(2);

    stats_mass = zeros(100, 1);

    for m = 1:100
        stats = zeros(col, 1);

        for j = 1:col
            stats(j) = PH_Walker(ts(:, j), "momentum", m).w_tau; %2663
        end

        stats_mass(m) = mean(stats);

    end

    subplot(no_groups,1, i + 1);
    plot(stats_mass);



end
%legend({"1", "2"})
