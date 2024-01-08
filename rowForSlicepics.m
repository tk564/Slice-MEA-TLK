function [slicepics, row] = rowForSlicepics(file)


slicepics = readtable("slice pic analysis.xlsx", 'VariableNamingRule', 'preserve'); % load the table with channel info
    slicepics = table2cell(slicepics);
    allData = readtable('(AD and Epilepsy) Total MED64 Data.xlsx', 'VariableNamingRule','preserve');
    recording = file.name(1:11); % gets the recording name
    [~, ~, ~, slice, ~] = getMetadata(recording, allData); % gets the slice number from big table

    
    indexer = cell2mat(slicepics(:,1:2));
    date = str2num(recording(1:8));
    row = 0;
    for i = 1:size(slicepics,1)
        
        if indexer(i,1) == date
           
            if indexer(i,2) == slice
                row = i;
            end
        end
    end