function MED_Analysis_Tommy(recording_ref, redetect, data_and_scripts_dir)

%% SET DIRECTORY AND LOAD FILES

%% SET DIRECTORY

% LOAD FILES

cd('RecFiles')

files = dir(strcat('*', recording_ref, '*', '.mat')); % Loads all files in the directory from a given culture preparation

files = files(~contains({files.name}, 'Spikes')); % Removes tSpikes files.
files = files(~contains({files.name}, 'analysed')); % Removes analysed files
files = files(~contains({files.name}, 'template'));
files = files(~contains({files.name}, 'finalData'));
files = files(~contains({files.name}, 'concurrency'));
files = files(~contains({files.name}, 'adjacency'));
files = files(~contains({files.name}, 'hub_stuff'));

recording_files = files(~contains({files.name}, 'TTX'));


    method = {'Tommy'};
    multiplier = 6; % Standard deviation multiplier, used to generate threshold.
    voidPeriod_ms = 200; % void period after spike detection so no each spike produces only one entry to spike matrix (in ms).
    % including here for legacy, but actually gets redefined later on
    fs = 20000; % sampling frequency


%% DETECT SPIKES

for f = 1:length(recording_files)
    
    file = recording_files(f);
    disp(file.name)


    if ~isempty(dir(strcat(file.name(1:end-4), '*' , 'Spikes_', '*', '.mat'))) && redetect == 0 % if redetecting then will be set to 1
        %only checking for tSpikes atm, prepare for suSpikes incoming!
        disp(strcat('already detected spikes for', " ", file.name(1:end-4)))
    else %detect spikes if not done alreadyt
    
    % EXTRACT PARAMETERS FOR WHOLE SIGNAL, SPIKES, NOISE (SIGNAL WITHOUT SPIKES) AND CORRESPONDING TTX FILE
    

   cd(data_and_scripts_dir)
    batchGetSpike_Tommy(file, method, multiplier, voidPeriod_ms, fs); % Perfroms spike detection using default parameters, generating an rSpikes file.
    
    
    end
end    


