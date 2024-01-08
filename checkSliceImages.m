function checkSliceImages

ref = strcat('201','*', '.mat');


search = dir(ref);



search = search(~contains({search.name}, 'Spikes')); % Removes tSpikes files.
search = search(~contains({search.name}, 'analysed')); % Removes tSpikes files.
search = search(~contains({search.name}, 'finalData')); % Removes tSpikes files.
search = search(~contains({search.name}, 'data')); % Removes tSpikes files.
search = search(~contains({search.name}, 'concurrency')); % Removes tSpikes files.
search = search(~contains({search.name}, 'matrix')); % Removes tSpikes files.
files=search;



slicepics = readtable("slice pic analysis.xlsx", 'VariableNamingRule', 'preserve'); % load the table with channel info
    slicepics = table2cell(slicepics);
     allData = readtable('(AD and Epilepsy) Total MED64 Data.xlsx', 'VariableNamingRule','preserve');


for i = 1:length(files)

    file = files(i);
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

    if row == 0

        disp(strcat('Do not have slice pic analysis for', " ", recording));
        disp(slice)
    end
end
