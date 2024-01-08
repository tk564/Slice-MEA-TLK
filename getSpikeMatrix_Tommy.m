function [spikeMatrix,filteredData,thresholds, timeInterval, metadata, spikeMatrixFT, tSpikes, traces] = getSpikeMatrix_Tommy(data, method, multiplier, voidPeriod_ms, fs, name, frequencyRange, sType)
% first runs through the threshold detection mechanism to extract waveform
% for spikes, then implements a template matching algorithm to increase the
% number of spikes detected and avoid detecting non-spike waveforms
%%


[tSpikes, filteredData, thresholds, timeInterval, metadata, fs] = thresholdDetection_Tommy(data, method, multiplier, voidPeriod_ms, fs, frequencyRange, name, sType);
disp('threshold detection done')
%%

[newmeta, spikeMatrixFT] = templateDetection_Tommy(tSpikes, filteredData, thresholds, fs, name, metadata, voidPeriod_ms, sType);
metadata = newmeta;
% WIP template detection method
disp('template deteciton done')
%%

spikeMatrix = or(tSpikes, spikeMatrixFT);
%spikeMatrix = spikeMatrixFT; % ideally just want the template matched version to avoid FPs from threshold method
% spikeMatrix = tSpikes;
% spikeMatrixFT = 0;
if strcmp(sType, 'mu')
    void = 200;
elseif strcmp(sType, 'su')
    void = 2*60;
end


spikeMatrix = full(spikeMatrix);
for i = 1:size(spikeMatrix,2)
    positions = find (spikeMatrix(:,i) == 1);  
    
    for j = 1:length(positions) % -VPMS at end to avoid error
        spikeMatrix(positions(j)+1:positions(j)+void,i) = 0; 
    end
end
spikeMatrix = sparse(spikeMatrix);


traces = getAllTraces(fs, spikeMatrix, filteredData, metadata);

%% get S/N for each channel

StoNPerChannel = zeros(1,size(filteredData,2));
for i = 1:size(filteredData,2)
    signal = nnz(spikeMatrix(:,i));
    noise = metadata.channels.unfilteredSDs(i);
    StoNPerChannel(i) = signal/noise;
end
metadata.channels.StoNPerChannel = StoNPerChannel;

SN_iqr = iqr(nonzeros(StoNPerChannel));
SN_lq = quantile(nonzeros(StoNPerChannel), 0.25);
SN_outlierThreshold = SN_lq - 1.5*SN_iqr; % modification of established method in matlab for outliers when not normally distributed, note however modified as only want to remove top tail

lowSNChannels = find(StoNPerChannel < SN_outlierThreshold); % reports while testing
metadata.channels.lowSNChannels = lowSNChannels; 



end

