% Extract variables of interest
oldVariables = whos('-file', 'Normalized/HCTSA_Adiac_N.mat');
newVariables = whos('-file', 'adiac.mat');
% Compare variable sizes
for i = 1:length(oldVariables)
    oldSize = oldVariables(i).bytes;
    newSize = 0;  % Initialize new size
    
    % Find corresponding variable in new version
    for j = 1:length(newVariables)
        if strcmp(oldVariables(i).name, newVariables(j).name)
            newSize = newVariables(j).bytes;
            break;
        end
    end
    
    if newSize == 0
        fprintf('%s:\n', oldVariables(i).name);
        fprintf('  Variable not found in new version\n\n');
    else
        sizeChange = newSize - oldSize;
        percentageChange = (sizeChange / oldSize) * 100;
        
        fprintf('%s:\n', oldVariables(i).name);
        fprintf('  Old Size: %d bytes\n', oldSize);
        fprintf('  New Size: %d bytes\n', newSize);
        fprintf('  Size Change: %d bytes (%.2f%%)\n\n', sizeChange, percentageChange);
    end
end

%apparently if i load the .mat files and then save them seperately i save space????
%but they seem to be the same size???