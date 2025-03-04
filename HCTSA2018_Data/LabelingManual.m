listing = dir("Normalized/*.mat");
tbl = struct2table(listing);
tbl.date = datetime(tbl.datenum,ConvertFrom="datenum");
tbl = removevars(tbl,"datenum");

files = tbl(~tbl.isdir,:);

namedFiles = files(endsWith(files.name, '_N.mat'),:);

filenames = namedFiles.name;


n = 100;
nums = [0:n];
classes = cellstr(string(nums));

max_classes = zeros(93, 1);

for i = 1:93
    loaded = convertStringsToChars("Normalized/" + string(filenames(i)));

    for j =1:n
        try
            TS_LabelGroups(loaded, classes(1:j));
            continue
        catch
            max_classes(i) = j;
            break
        end
    end
end

%x = max_classes(:, 1);
x = x - 1;
T = table(filenames, x,'VariableNames',{'filename', 'number of classes'});
writetable(T,'classes.txt');



