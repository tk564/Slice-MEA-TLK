function [metadata, spikeMatrixFT] = templateDetection_Tommy(spikeMatrix, filteredData, thresholds, fs, ~, metadata, voidPeriod_ms, sType)
% extracts a template of what spikes look like in the recording so far,
% then uses this to reanalyse the data increasing (hopefully) the number of
% spikes detected and reducing noise events which slip through

%% smooth data
% template matching works better for smoothed traces hence:
% only do for multi-unit, as need to maintain high res for single-unit

if strcmp(sType, 'mu')
for i = 1:size(filteredData,2)
    filteredData(:,i) = movmean(filteredData(:,i),20); % replots as a moving average across 50ms which smooths but maintains spikiness of the spike itself
end
end
metadata = metadata; % because for some reason wasn't registering presence of metadata unless did this pointless =



%% set up some matrixes to fill
if ~exist('tempLength')
    if strcmp(sType, 'mu')
        tempLength = (fs/1000)*501; % multiunit template lengths of 501ms
    elseif strcmp(sType, 'su')
        tempLength = (fs/10000)*(2*10+1); % single unit template length of 3ms (centre +/- 1ms with 0.05ms segment in middle as must be odd)
    end
end

metadata.spikes.spikesRemovedByTemplate = [0 0 0];
validMatrix = zeros(3,size(spikeMatrix,2));
metadata.originalTemplates = zeros(tempLength,size(spikeMatrix,2));
metadata.usedSpikeTemplate = zeros(tempLength,size(spikeMatrix,2));
% metadata.allTraces = zeros(fs+2,1);

%%
k = 0;
c = 0.8; % cutoff of similarity which must be reached to be considered a spike = 80% similarity
for j = 1:size(spikeMatrix, 2) % channel by channel...

    if nnz(spikeMatrix(tempLength:length(spikeMatrix)-tempLength,j)) > 0

        [currentSpikeTemplate, isItASpike, similarity, similarityNeg, originalTemplate, ~] = getSpikeTemplate_Tommy(spikeMatrix(:,j), filteredData(:,j), thresholds, fs, metadata, c, k, tempLength, sType); % changed to do channel by channel so if one channel has a somewhat different but still close enough template its spikes are not removed
       
        metadata.originalTemplates(:,j) = originalTemplate';
        metadata.usedSpikeTemplate(:,j) = currentSpikeTemplate';

        validMatrix(1,j) = isItASpike;
        validMatrix(2,j) = similarity;
        validMatrix(3,j) = similarityNeg;
        toCheck = find(spikeMatrix(tempLength:length(spikeMatrix)-tempLength,j))+tempLength; % get the locations of spikes which need checking, avoid error

        for m = 1:length(toCheck)

            spikeSeq = normalize(filteredData( toCheck(m)-((tempLength-1)/2) : toCheck(m)+((tempLength-1)/2) , j), 'range', [0 1])'; % gets window around supposed spike#
            correlation = max(normxcorr2(currentSpikeTemplate,spikeSeq));

            if correlation < c % maybe make diff as each single is more irregular?
                spikeMatrix(toCheck(m),j) = 0;


                metadata.spikes.spikesRemovedByTemplate = [metadata.spikes.spikesRemovedByTemplate; toCheck(m) j correlation];

            end



        end
    else
        validMatrix(1,j) = NaN;
        validMatrix(2,j) = NaN;
        validMatrix(3,j) = NaN;
    end

end

metadata.validMatrix = validMatrix;

%% add in a refined template stage
% purpose of this is to make the spike template even less influenced by
% non-spikes such that can be better at picking up missed spikes

% several iterations of refining template then re-detecting spikes
% pass multiple times and get refined templates


if strcmp(sType, 'mu')
knownSpike = load("knownSpike.mat");
knownSpike = knownSpike.knownSpike; % loads a validated spike template, normalised from [0 1] from 20170820004 data
knownSpike = downsample(knownSpike, 20000/fs); % downsamples to whatever the new fs is
knownSpike = knownSpike(250:750);
elseif strcmp(sType, 'su')
    knownSpike = load("suSpike.mat");
    knownSpike = knownSpike.suSpike; % spike will already be correct length etc
    knownSpike = knownSpike(10:50);
    knownSpike = downsample(knownSpike,2);
end


spikeMatrixFT = spikeMatrix; % just does this once temporarily so can loop
n = 2; % currently only one more pass, as seems if there are two spike waveforms then too many iterations stops the other being detected, but can  look into this
spikesPerIteration = zeros(n, size(spikeMatrix,2));
%%
for k = 1:n
    refinedSpikeTemplate = zeros(size(metadata.usedSpikeTemplate));
    for j = 1:64
        if nnz(spikeMatrixFT(:,j)) > 0
            [refinedSpikeTemplate(:,j), ~, ~, ~, ~, ~] = getSpikeTemplate_Tommy(spikeMatrixFT(:,j), filteredData(:,j), thresholds, fs, metadata, c, k, tempLength, sType); % changed to do channel by channel so if one channel has a somewhat different but still close enough template its spikes are not removed
            if isnan(refinedSpikeTemplate(1,j))
                refinedSpikeTemplate(:,j) = knownSpike; % if there is no template as no spikes were initially detetced uses the known spike as a template in case some subthreshold
            end
        else
            refinedSpikeTemplate(:,j) = knownSpike;
        end

    end

    [spikeMatrixFT, metadata, seqChecker] = templateMatching_Tommy(filteredData, metadata, fs, refinedSpikeTemplate, voidPeriod_ms, spikeMatrixFT, c, sType);

    spikesPerIteration(k, :) = sum(spikeMatrixFT);

end

metadata.refinedSpikeTemplate = refinedSpikeTemplate; % only outputs the final iteration
metadata.spikesPerIteration = spikesPerIteration;
metadata.seqChecker = seqChecker;




spikeMatrixFT = sparse(spikeMatrixFT);







end






