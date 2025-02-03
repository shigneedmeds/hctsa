inp = load("CustomTimeSeries\INP_1000ts.mat");

inp = inp.timeSeriesData;

y = inp{1,100};

y = (y - mean(y)) / std(y);


x = PH_Walker(y, "momentum", 500)