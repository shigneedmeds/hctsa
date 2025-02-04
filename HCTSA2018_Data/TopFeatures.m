tab = readtable('classes.txt');
filenames = tab.filename;
%reads in table and files

z_scores = zeros(93, 1);

%just looking at z_scores of momentum walker with mass 2 for now (specifically the mean)

for i = 1:93
    loaded = convertStringsToChars("Normalized/" + string(filenames(i)));
    [ifeat, testStat, x, y] = TS_TopFeatures(loaded, "classification", struct(), 'whatPlots',{});
    ordered = sort(ifeat);

    t = testStat(ordered == 2638); %just the mean of a mass 2 walker for now, later try to include all of the different stats
    z_scores(i) = (t - mean(testStat))/std(testStat);


end

%scatter(1:93, z_scores);
T = table(filenames, z_scores,'VariableNames',{'filename', 'z_score of walker'});
writetable(T,'walker_performance.txt');

histogram(z_scores, 10);
xlabel("Z\_scores");
ylabel("Counts");
title("Z\_scores of mean of mass 2 walker");