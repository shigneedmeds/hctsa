listing = dir("Data/*.mat");
tbl = struct2table(listing);
tbl.date = datetime(tbl.datenum,ConvertFrom="datenum");
tbl = removevars(tbl,"datenum");

files = tbl(~tbl.isdir,:);

namedFiles = files(~endsWith(files.name, '_N.mat'),:);

filenames = namedFiles.name;

for i = 1:93
    loaded = convertStringsToChars("Data/" + string(filenames(i))) %load(string(filenames(i)));
    TS_Normalize('mixedSigmoid' ,[0.70,1] ,loaded);
end

movefile('Data/*_N.mat', 'Normalized')


