function [spikeIntervalData] = tSpikeIntervalFinder_Tommy(timeInterval, TimeChanMatrix, data)

%% 
% this function will run through the matrix of positions and channel
% numbers
% it will compare those of the same channel to create a list of the time
% intervals between them but only chronologically spaced ones
% function may be modified later to become base of the 'find correlations
% between channels' script

spikeInterval = zeros(size(TimeChanMatrix,1),size(data,2));

for i = 1:(size(TimeChanMatrix, 1)-1)
    pos1 = [TimeChanMatrix(i, 1:2)];
    pos2 = [TimeChanMatrix(i+1, 1:2)];
    
    if pos1(1,2) == pos2(1,2)
        newInterval = pos2(1,1) - pos1(1,1);
        spikeInterval(i,pos1(1,2)) = newInterval; % outputs with each interval in corresponding channel column but idk if usefuls
    end
end

%% per channel analysis

spikeIntervalMeanPerChannel_s = zeros(1,size(data,2)); % more efficient to set up matrix first
spikeIntervalSTDPerChannel_s = zeros(1,size(data,2));
spikeIntervalSEMPerChannel_s = zeros(1,size(data,2));

for i = 1:size(data,2) % go through each channel separately
    
        dat = nonzeros(spikeInterval(:,i));
        dat = rmoutliers(dat, 'percentiles', [0 90]); % experimental, accounts for any v long intervals between 'bursts' of activity. Lose some data but applied uniformly to all

    if nnz(spikeInterval(:,i)) == 0 % avoids dividing by 0 errors for SEM and makes future analysis easier
        spikeIntervalMeanPerChannel_s(i) = 0;
        spikeIntervalSTDPerChannel_s(i) = 0;
        spikeIntervalSEMPerChannel_s(i) = 0;
    else
        spikeIntervalMeanPerChannel_s(i) = mean(dat)*(timeInterval/1000); % mean of each channel
        spikeIntervalSTDPerChannel_s(i) = std(dat)*(timeInterval/1000); % std of each channel
        spikeIntervalSEMPerChannel_s(i) = spikeIntervalSTDPerChannel_s(i) / sqrt(nnz(spikeInterval(:,i))); % sem of each channel

    end
end    

%% between channel analysis

spikeIntervalSTDBetweenChannels_s = std(nonzeros(spikeIntervalMeanPerChannel_s)); % STDev of mean time intervals of each channel

if nnz(spikeIntervalMeanPerChannel_s) == 0 % avoids a dividing by 0 error in event that no spikes were detected
    spikeIntervalSEMBetweenChannels_s = 0;
else    
spikeIntervalSEMBetweenChannels_s = spikeIntervalSTDBetweenChannels_s / sqrt(nnz(spikeIntervalMeanPerChannel_s));
end

%% analysis of whole sample

spikeIntervalMean_s = mean(nonzeros(spikeIntervalMeanPerChannel_s)); % average time interval in seconds from across all channels
spikeIntervalSTD_s = std(nonzeros(spikeInterval))*(timeInterval/1000); % STDev of time interval in seconds
spikeIntervalSEM_s = spikeIntervalSTD_s / sqrt(nnz(spikeInterval)); % SEM of time interval in seconds

%% save in a struct

spikeIntervalData.spikeIntervalMeanPerChannel_s = spikeIntervalMeanPerChannel_s;
spikeIntervalData.spikeIntervalSTDPerChannel_s = spikeIntervalSTDPerChannel_s;
spikeIntervalData.spikeIntervalSEMPerChannel_s = spikeIntervalSEMPerChannel_s;

spikeIntervalData.spikeIntervalSTDBetweenChannels_s = spikeIntervalSTDBetweenChannels_s;
spikeIntervalData.spikeIntervalSEMBetweenChannels_s = spikeIntervalSEMBetweenChannels_s;

spikeIntervalData.spikeIntervalMean_s = spikeIntervalMean_s;
spikeIntervalData.spikeIntervalSTD_s = spikeIntervalSTD_s;
spikeIntervalData.spikeIntervalSEM_s = spikeIntervalSEM_s;


end     
   

