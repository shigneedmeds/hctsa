tab = readtable('classes.txt');

for i = 1:93
    n = tab(i, :).numberOfClasses;
    n = n - 1;
    nums = [0:n];
    classes = cellstr(string(nums));

    name = "Normalized/" + string(tab(i,:).filename);
    name = convertStringsToChars(name);

    TS_LabelGroups(name, classes);
end