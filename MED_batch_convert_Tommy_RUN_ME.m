function MED_batch_convert_Tommy_RUN_ME
%% Change Directory into Data and Script Folder

folder = 'E:\Slice_MEA';
cd(folder) % Change directory to location of data and batch conversion files. Note separate directories can be called but this could be implemented at a later stage

%%e


% Code written by Tommy Kelly and Rich Turner who adapted this function
% (MED_batch_convert.m) and those that it calls (MED_load_csv.m and
% progressbar.m) from the MEAbatchConvert.m and MEA_load_bin.m functions
% developed by Tim Sit and Alex Dunn

% Last update: 211020

% Instructions

% This function converts MED64 files saved in a (excel).csv format into
% .mat files in a batch. It will attempt to convert all .csv files in the
% directory, so make sure they are all MED64 data files or enter an
% extension to select a few.


%% Select Conversion Mode

convertOption = 'whole'; % Save the entire grid as one variable
%convertOption = 'electrode'; % Save electrode by electrode in a recording specific folder. This was an option TS and AD already started to pursue, unsure whether it works though

%% Initialize


d=dir;
files=[];

ext='.csv';

for i=1:length(d)
    if ~(isempty(findstr(d(i).name,ext)))
        files=[files; i];
    end
end

files=d(files);
files=files(2:length(files)); %changed to 2:length(files) from just 2 as before only converted the first .csv found

%% Convert the Files

plt=0; % Required input inherited from AD, leave as 0 to turn plot off during analysis for speed

for i=1:length(files)
    % files(i).name
    skip=0;
    %find if file already converted
    for j=1:length(d)
        if endsWith(d(j).name, 'mat') %only compares against .mat files so it doesn't comapre against itself
            x = d(j).name(1:length(d(j).name)-4);
            if strcmp(files(i).name(1:length(files(i).name)-4),x)
                skip=1;
            end
        end
    end
    if skip==0
        files(i).name
             MED_load_data_Tommy(files(i).name, convertOption); % Ignore 'plt,' this is one of the required inputs of the function inherited from
    end


end

end

