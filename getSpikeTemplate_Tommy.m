function [currentSpikeTemplate, isItASpike, similarity, similarityNeg, originalTemplate, all_trace] = getSpikeTemplate_Tommy(spikeMatrix, filteredData, thresholds, fs, metadata, c, k, tempLength, sType)



%% select the spikes to average waveform of

% spikeTrain = spikeMatrix(:,electrode_to_plot);
spikeTrain = spikeMatrix; % only one channel used by function

sp_times=find(spikeTrain( tempLength : length(spikeTrain) - (tempLength))==1)+(tempLength+1); % starts search at 1001 so no error selecting negative values, then adds on 20000 so still correct number from start
  
n_spikes_to_average = length(sp_times); 

%% take snippets from around each
% filteredData = filteredData(:, electrode_to_plot);

    all_trace = zeros(n_spikes_to_average, tempLength); % make now to avoid error later

    for i=1:n_spikes_to_average
        all_trace(i,:) = normalize(filteredData( sp_times(i)-((tempLength-1)/2) : sp_times(i)+((tempLength-1)/2)), 'range', [0 1]); % dont need to calculate 'peak time' like in spike overlay as already peak values
    end   

%% extract template for this dataset

currentSpikeTemplate = normalize(mean(all_trace, 1), 'range', [0 1]); % should probably output this to be visually inspected
originalTemplate = currentSpikeTemplate';
%% validate template by comparing to a known spike template

[isItASpike, cstNEW, similarity, similarityNeg] = validateSpikeTemplate_Tommy(currentSpikeTemplate, fs, metadata, c, k,tempLength, sType);

currentSpikeTemplate = cstNEW;
end