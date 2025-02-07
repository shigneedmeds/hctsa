set = "ECG200";
dataset = "Normalized/HCTSA_" + set + "_N.mat";
dataset = convertStringsToChars(dataset);

[TS_DataMat,TimeSeries,Operations,~] = TS_LoadData(dataset);

no_groups = max(double(TimeSeries.Group));

figure('Position', [10,10,550, 300*no_groups])

axs = [];
for i = 0:no_groups - 1
    ts = cell2mat(transpose(TimeSeries(TimeSeries.Group == string(i), :).Data));
    col = size(ts);
    col = col(2);
    cols = 1:10;

    %figure();

    subplot(no_groups,1, i + 1);
    a = subplot(no_groups,1, i + 1);
    
    plot(ts(:, [cols]), "LineWidth", 0.5, "Color", "b");
    hold on;
    plot(mean(ts, 2), "LineWidth", 2, "Color", "r");
    
    hold off;
    xlabel("time");
    ylabel("x(t)");
    title(sprintf("%s class %d", set, i + 1));

    axs = [axs; a];

    %legend({"mean", string(i)}, {"r", "b"})

end

if ~isfolder("DatsetPlots/")
    mkdir("DatasetPlots/")
end


linkaxes(axs, 'y');

saveas(gcf, "DatasetPlots/" + set + ".png")
close(gcf);


figure('Position', [10,10,550, 300*no_groups])

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
    a = subplot(no_groups,1, i + 1);
    
    plot(time(:, [cols]), "LineWidth", 0.5, "Color", "b");
    hold on;
    plot(mean(time, 2), "LineWidth", 2, "Color", "r");
    
    hold off;

    xlabel("time");
    ylabel("w(t)");
    title(sprintf("Walker %d on %s class %d", m , set, i + 1));
    axs = [axs; a];
    %legend({"mean", string(i)}, {"r", "b"})

end

if ~isfolder("WalkerPlots")
    mkdir("WalkerPlots/")
end


linkaxes(axs, 'y');

saveas(gcf, sprintf("WalkerPlots/%s_walker_%d.png", set, m));
close(gcf);

stats_mass = zeros(100, 21, no_groups);

for i = 0:no_groups - 1
    ts = cell2mat(transpose(TimeSeries(TimeSeries.Group == string(i), :).Data));
    col = size(ts);
    row = col(1);
    col = col(2);

    for m = 1:100
        stats = zeros(col, 21);

        for j = 1:col
            s = PH_Walker(ts(:, j), "momentum", m);
            stats(j, :) = cell2mat(struct2cell(s)); %2663
        end

        stats_mass(m, :, i + 1) = mean(stats);

    end

    

end

if ~isfolder("StatsvsMass/")
    mkdir("StatsvsMass/")
end

if ~isfolder(sprintf("StatsvsMass/%s/", set))
    mkdir(sprintf("StatsvsMass/%s/", set))
end


names = ["w_mean", "w_median", "w_std", ...
"w_ac1", "w_ac2", "w_tau", "w_min", "w_max", ...
"w_propzcross", "sw_meanabsdiff", "sw_taudiff", ...
"sw_stdrat", "sw_ac1rat", "sw_minrat", "sw_maxrat",...
"sw_propcross", "sw_ansarib_pval", "sw_distdiff"];

names = transpose(names);

for i = 1:18
    figure();
    %axs = [];
    for j = 0:no_groups-1
        %a = subplot(no_groups,1, j + 1);
        plot(stats_mass(:, i, j + 1));
        hold on;
        %xlabel("mass");
        %ylabel("stat");
        %title(sprintf("%s of walker vs increasing mass (%s class %d)", names(i), set, j + 1));
        %axs = [axs; a];
    end
    %linkaxes(axs, 'y');
    hold off;

    xlabel("mass");
    ylabel("stat");
    title(sprintf("%s of walker vs increasing mass (%s)", names(i), set));
    legend(string(1:no_groups));

    saveas(gcf, sprintf("StatsvsMass/%s/%s-%s.png", set, set, names(i)));
    
    close(gcf);
end

%legend({"1", "2"})
