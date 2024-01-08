function fixSMs


    data_and_scripts_dir = 'C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy'; % Changed to a directory containing both your scripts and files.
    cd(data_and_scripts_dir)

    %% analyse the spike` matrix
    % LOAD FILES

    tSpikeFiles = dir(strcat('*', '_tSpikes_*.mat')); % Loads all files in the directory from a given culture preparation
    dataFiles = dir(strcat('*', 'finalData', '*', '.mat'));

    % runs downstream analysis and produces the output struct with any data
    % gathered. Update the output variables as more are added

    for f = 1:length(tSpikeFiles)

        clearvars -except data_and_scripts_dir f tSpikeFiles voidPEriod_ms fs
voidPeriod_ms = 200;
fs = 1000;
fileName = tSpikeFiles(f).name(1:11);
load(tSpikeFiles(f).name);
spikeMatrix = or(tSpikes, spikeMatrixFT);
%spikeMatrix = spikeMatrixFT; % ideally just want the template matched version to avoid FPs from threshold method
% spikeMatrix = tSpikes;
% spikeMatrixFT = 0;

spikeMatrix = full(spikeMatrix);
for i = 1:size(spikeMatrix,2)
    positions = find (spikeMatrix(:,i) == 1);  
    
    for j = 1:length(positions) % -VPMS at end to avoid error
        spikeMatrix(positions(j)+1:positions(j)+voidPeriod_ms,i) = 0; 
    end
end
spikeMatrix = sparse(spikeMatrix);

load(strcat(tSpikeFiles(f).name(1: length(tSpikeFiles(f).name) - 13), 'finalData_6.mat'));

traces = getAllTraces(fs, spikeMatrix, finalData);


        save(tSpikeFiles(f).name, 'tSpikes','channels','thresholds', 'timeInterval', 'signalToNoise', 'metadata', 'spikeMatrixFT', 'traces', 'spikeMatrix');
    end