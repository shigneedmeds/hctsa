dataset = 'Normalized/HCTSA_ECG200_N.mat';

[TS_DataMat,TimeSeries,~,~] = TS_LoadData(dataset);

no_groups = max(double(TimeSeries.Group));



for i = 0:no_groups - 1
    ts = cell2mat(transpose(TimeSeries(TimeSeries.Group == string(i), :).Data));
    col = size(ts);
    col = col(2);
    cols = randperm(col, 10);

    %figure();

    subplot(no_groups,1, i + 1);
    
    plot(ts(:, [cols]), "LineWidth", 0.5, "Color", "b");
    hold on;
    plot(mean(ts, 2), "LineWidth", 2, "Color", "r");
    
    hold off;
    legend({"mean", string(i)})

end


%legend({"1", "2"})
