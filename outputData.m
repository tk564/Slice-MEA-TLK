function outputData

%%
clear; close all

folder = 'E:/Slice_MEA';

cd(folder)
cd .\RecFiles\
%cd 'Analysed\'; % do this if getting the overall analysis output

files = dir('*analysed.mat*');
files = files(~contains({files.name}, 'su'));

cd(folder)

allData = readtable('(AD and Epilepsy) Total MED64 Data.xlsx', 'VariableNamingRule','preserve');
exR = readtable('Exclude Recordings.xlsx', 'VariableNamingRule', 'preserve');
exR = table2array(exR(:,1));

slicepics = readtable("slice pic analysis.xlsx", 'VariableNamingRule', 'preserve'); % load the table with channel info
slicepics = table2cell(slicepics);
cd .\RecFiles   


sampling_fr = 20000;

%% loop through
for file = 1:length(files)

    %% check if a recording to be excluded from analyses (for now)

    present = find(exR ==  str2num(files(file).name(1:11)) );

    if ~isempty(present)
        exclude = 1;
    else
        exclude = 0;
    end
    %% output the data

    if exclude == 0
        cd(folder)
        cd .\RecFiles
        data = load(files(file).name);
       
        output(file).recording = files(file).name(1:end-13); % assuming all have the same naming scheme, may need to modify

        recording = files(file).name(1:end-13);
        
        cd(folder)
        [line, condition, age, slice, side] = getMetadata(recording, allData);
        

        % number of HPC electrodes
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
        % finish finding number of electrodes




        output(file).line = line; % placeholder for later where will add mouse line
        output(file).condition = condition; % placeholder for later where will add condition
        output(file).age = age; % as above but for age
        output(file).slice = slice; % slice number
        output(file).side = side; % as above but for side, if data available


       


        if data.spikesTot ~=0
            try
             HPCelectrodes = [str2num(slicepics{row,5}), str2num(slicepics{row,6}),  str2num(slicepics{row,7}), str2num(slicepics{row,12})]; % get channels of DG/CA3/CA1all/EC
     
             activeChannels = nnz((data.fullData.spikesPerChannel_full));
        output(file).proportionActive = activeChannels / nnz(HPCelectrodes);
            catch
            end

            output = wholeSliceOutput(file, data, output);

            output = regionalOutput(file,recording,output, folder);

            try

            output = propagationOutput(file, recording, folder, output);
            catch
            end
           


            disp(strcat('data output for', ' ', recording))
        else
            disp(strcat('no data to output for', ' ', recording))

        end
        cd(folder)
        cd .\RecFiles
    end

    %% replace blank spaces with 0

    for i = 1:length(output)
        rec = output(i);
        replace = structfun(@isempty, rec);
        fieldNames = fieldnames(rec);
        for j = 1:length(fieldNames)
            if replace(j) == 1
                toRep = char(fieldNames(j));

                output(i).(toRep) = 0;
            end
        end
    end

        %% save data

        cd(folder)
       cd .\OutputData
        when = datenum(date);
        fileName = strcat('MEA_Data_Analysed_' , date, '.mat');
        save(fileName, 'output', 'when');
        xldata = struct2table(output);
        writetable(xldata, strcat(fileName(1:end-4), '.xlsx'));

        cd(folder)

end