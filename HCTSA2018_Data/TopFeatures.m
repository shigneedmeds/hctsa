tab = readtable('classes.txt');
filenames = tab.filename;
%reads in table and files

z_scores = zeros(93, 1);
ops = string(zeros(93, 1));
accuracy = zeros(93,1);

%just looking at z_scores of momentum walker with mass 2 for now (specifically the mean)

for i = 1:93
    loaded = convertStringsToChars("Normalized/" + string(filenames(i)));
    [ifeat, testStat, x, y] = TS_TopFeatures(loaded, "classification", struct(), 'whatPlots',{});
    ordered = sort(ifeat);

    %t = testStat((2638 <= ordered) & (ordered <= 2657)); %just the mean of a mass 2 walker for now, later try to include all of the different stats
    t = testStat((2658 <= ordered) & (ordered <= 2677));
    z_scores(i) = (max(t) - mean(testStat))/std(testStat);

    %walker_ops = ordered((2638 <= ordered) & (ordered <= 2657)); %mass 2
    walker_ops = ordered((2658 <= ordered) & (ordered <= 2677));

    op = walker_ops(t == max(t));
    op = string(op);
    ops(i) = join(op, " ");
    accuracy(i) = max(t);


end

%scatter(1:93, z_scores);
T = table(filenames, z_scores, accuracy, ops, 'VariableNames',{'filename', 'z_score of walker',...
'accuracy', 'operation'});
writetable(sortrows(T, 2),'TopFeatures/walker_5_performance-maxstat.txt');

histogram(z_scores, 10);
xlabel("Z\_scores");
ylabel("Counts");
title("Max Z\_scores (across stats) of mass 5 walker");