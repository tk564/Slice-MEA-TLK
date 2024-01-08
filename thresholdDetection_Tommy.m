function [spikeMatrix, filteredData, thresholds, timeInterval, metadata, fs] = thresholdDetection_Tommy(data, method, multiplier, voidPeriod_ms, fs, frequencyRange, name, sType)
% runs the first round of spike detection by the threshold method

%% note excessively noisy channels


   for i = 1:size(data, 2)
    unfilteredSDs(i) = std(data(:,i));
   end
    metadata.channels.unfilteredSDs = unfilteredSDs;

%histogram(unfilteredSDs)

%% noisy and nonHPC
try % tries ideally do do this only consideirng the valid electrodes so not unecessarily influenced by very noisy extraHPC electrodes
    file.name = name;
    HPCelectrodes = getHPCelectrodes(file);
    metadata.HPCelectrodes = HPCelectrodes;

    for i = 1:size(data,2)
        if nnz(i == HPCelectrodes) == 0
            unfilteredSDs(i) = 0; % sets to zero if not HPC so ignored, but still output in metadata
        end
    end
    
    SD_iqr = iqr(nonzeros(unfilteredSDs));
    SD_uq = quantile(nonzeros(unfilteredSDs), 0.75);
    SD_outlierThreshold = SD_uq + 2.5*SD_iqr; % modification of established method in matlab for outliers when not normally distributed, note however modified as only want to remove top tail
    
    noisyChannels = find(unfilteredSDs > SD_outlierThreshold); % reports while testing
    metadata.channels.noisyChannels = noisyChannels;  

catch    
    disp(strcat('ERROR - NO PIC ANALYSIS FOR', " ", name))
  SD_iqr = iqr(nonzeros(unfilteredSDs));
    SD_uq = quantile(nonzeros(unfilteredSDs), 0.75);
    SD_outlierThreshold = SD_uq + 1.5*SD_iqr; % modification of established method in matlab for outliers when not normally distributed, note however modified as only want to remove top tail
    
     noisyChannels = find(unfilteredSDs > SD_outlierThreshold); % reports while testing
    metadata.channels.noisyChannels = noisyChannels;  
end

%% 
% Loop Through detectspikes.m for Each Channel
 
% downsampling, may remove polarity bit
% only downsample for the first pass...

if strcmp(method, 'Tommy')
    if strcmp(sType, 'mu')
        outputsize = ceil(size(data,1)/20); % accomodates downsampling to 1kHz
        polarity = 1;
    elseif strcmp(sType, 'su')
        outputsize = ceil(size(data,1)/2); % don't want to have to do this, but simply dont have the memory not to
        polarity = -1;
    else
        outputsize = ceil(size(data,1));
        polarity = 1;
    end
else
    outputsize = ceil(size(data,1));
    polarity = 1;
end


    spikeMatrixPos = zeros(outputsize, size(data,2)); % Initialises the spike matrix to be filled in as this script loops through detectSpikes.m for each channel.
    filteredData = zeros(outputsize, size(data,2)); % Without initialising you get an error.
    spikeMatrixNeg = zeros(outputsize, size(data,2)); % does the same but for using a negative threshold
    thresholds = zeros(1, size(data,2));
    % as downsampled 20x
%% detect spikes


    for j = 1:size(data, 2)    
        [spikeMatrixPos(:, j), spikeMatrixNeg(:,j), filteredData(:,j), thresholds(j), timeInterval] = detectSpikes_Tommy(data(:, j), method, multiplier, fs, voidPeriod_ms, frequencyRange, sType); % Creates spike matrix.
           % fs must be output as here the downsampling occurs
    end


    if strcmp(sType, 'mu') % only does downsampling if mu, for su keep at 20kHz
        fs = fs/20; % accomodates downsampling to 1kHz
    elseif strcmp(sType,'su')
        fs = fs/2;
    end
   
    
    metadata.spikes.totDetectedPos = nnz(spikeMatrixPos);
    metadata.spikes.totDetectedNeg = nnz(spikeMatrixNeg);
    
   
%% get noise matrix
noiseMatrix = zeros(outputsize, size(data,2));
%noiseMatrixNeg = zeros(outputsize, size(data,2));

if strcmp(sType, 'mu')
    noiseMultiplier = 4.5;
elseif strcmp(sType, 'su')
    noiseMultiplier = 2;
end

 for j = 1:size(data, 2)    
        [noiseMatrix(:, j), ~, ~, ~, ~] = detectSpikes_Tommy(filteredData(:, j), 'noise', noiseMultiplier, fs, voidPeriod_ms, frequencyRange, sType); % detect spikes but using a lower threshold to get subthreshold noise to be removed
           
 end

%% multi channel noise removal

    % eliminates events from positive and negative spike matrices - one at
    % a time due to memory errors
    try 
    
    numberToReach = length(HPCelectrodes);
    catch
        numberToReach = 45;
    end

    if strcmp(sType, 'mu')
        w = (fs/1000)*10; % window of 10ms for coincidence in other channels
    elseif strcmp(sType, 'su')
        w = (fs/20000)*2*10; % 2ms window for coincidence for su - not certain correct but lessgo
    end


 if strcmp(sType, 'mu')
    [spikeMatrixPos, multiEventsRemovedPos] = multiChannelNoiseRemoval_Tommy(spikeMatrixPos, noiseMatrix, noisyChannels, 0, numberToReach, w);  
    metadata.spikes.multichannelPos = metadata.spikes.totDetectedPos - nnz(spikeMatrixPos);
    metadata.spikes.multiEventsRemovedPos = multiEventsRemovedPos;

 elseif strcmp(sType, 'su')
    [spikeMatrixNeg, multiEventsRemovedNeg] = multiChannelNoiseRemoval_Tommy(spikeMatrixNeg, noiseMatrix, noisyChannels, 0, numberToReach, w);
    metadata.spikes.multichannelNeg = metadata.spikes.totDetectedNeg - nnz(spikeMatrixNeg);
    metadata.spikes.multiEventsRemovedNeg = multiEventsRemovedNeg;
 end
 
%% long noise removal

% then remove anything which spends too long above baseline
%checker = [0];

if strcmp(sType, 'mu')
    maxL = (fs/1000)*300;
elseif strcmp(sType, 'su')
    maxL = (fs/20000)*3*10;
end

 for j = 1:size(data,2)
     if nnz(spikeMatrixPos(:,j)) > 0 && nnz(spikeMatrixNeg(:,j)) > 0
     [spikeMatrixPos(:,j), spikeMatrixNeg(:,j), checkLP] = longNoiseRemoval_Tommy(spikeMatrixPos(:,j), spikeMatrixNeg(:,j), fs, filteredData(:,j), maxL);
    % checker = [checker;checkLP];
     else
   %   checker = [checker; 0];
     end
  
 end

 if strcmp(sType, 'mu')
metadata.spikes.longremovalPos = metadata.spikes.totDetectedPos - metadata.spikes.multichannelPos - nnz(spikeMatrixPos);
 elseif strcmp(sType, 'su')
metadata.spikes.longremovalNeg = metadata.spikes.totDetectedNeg - metadata.spikes.multichannelNeg - nnz(spikeMatrixNeg);
 end
%metadata.spikes.longremovalChecker = checker;
 %checker
%% remove repetetive events
% this script is early days, but aims to remove events which occur
% repetitively and are not spikes. Currently configured to remove a roughly
% 1/16Hz event


if strcmp(sType, 'mu')
    remInt = (fs/1000)*33;
elseif strcmp(sType, 'su')
    remInt = (fs/20000)*33*10;
end

if strcmp(sType, 'mu')
    for i = 1:size(spikeMatrixPos, 2)
        [spikeMatrixPos(:,i)] = removeRepetitiveEvent(spikeMatrixPos(:,i), fs, remInt);
        metadata.spikes.repetitivePos = metadata.spikes.totDetectedPos - nnz(spikeMatrixPos) - metadata.spikes.longremovalPos - metadata.spikes.multichannelPos;

    end
elseif strcmp(sType, 'su')
    for i = 1:size(spikeMatrixNeg, 2)
        [spikeMatrixNeg(:,i)] = removeRepetitiveEvent(spikeMatrixNeg(:,i), fs, remInt);
        metadata.spikes.repetitiveNeg = metadata.spikes.totDetectedNeg - nnz(spikeMatrixNeg) - metadata.spikes.longremovalNeg - metadata.spikes.multichannelNeg;
    end
end


%%

if strcmp(sType, 'mu')
[metadata.spikes.upDownAmpRemovalsPos, spikeMatrixPos] = updownamp_Tommy(spikeMatrixPos, fs, filteredData, metadata, polarity);
elseif strcmp(sType, 'su')
[metadata.spikes.upDownAmpRemovalsNeg, spikeMatrixNeg] = updownamp_Tommy(spikeMatrixNeg, fs, filteredData, metadata, polarity);
end


%%

% as within this range we detect multi-unit activity which should have
% positive deflections
if strcmp(sType, 'mu')
    spikeMatrix = spikeMatrixPos;
    thresholds = abs(thresholds);
    metadata.polarity = polarity;
elseif   strcmp(sType, 'su')  % here we might look at single unit activity with negative deflections
    spikeMatrix = spikeMatrixNeg;
    thresholds = -abs(thresholds);
    metadata.polarity = polarity;
else % backup takes the positive
    spikeMatrix = spikeMatrixPos;
    thresholds = abs(thresholds);
    metadata.polarity = polarity;
end    
