function [spikeMatrixFT, metadata, seqChecker] = templateMatching_Tommy(filteredData, metadata, fs, refinedSpikeTemplate, voidPeriod_ms, spikeMatrixFT, c, sType)

seqChecker = 0;

if strcmp(sType, 'mu')
    tempL=500;
    void = 300;
elseif strcmp(sType, 'su')
    tempL = 20;
    void = 20;
end

%%

for i = 1:size(filteredData,2)
    [spikeMatrixFT(:,i)] = templateTrains(filteredData(:,i), metadata, sType, refinedSpikeTemplate(:,i),c,fs, tempL, void);
end


%% noise removal
% get the number of channels which could reasonably be recorded from
try
    HPCelectrodes = getHPCelectrodes(metadata.HPCelectrodes);
    thresh = length(HPCelectrodes);
catch
    thresh = 45;
end

%% check that overshoot is smaller amplitude than undershoot

%[upvdownstrokeRemovals, spikeMatrixFT] = upstrokevdownstroke_Tommy(spikeMatrixFT, fs, filteredData, metadata); % the upstroke should be shorter in duration than the downstroke
% dont think this is working as intended so removing for now
upvdownstrokeRemovals = 0;

[updownampRemovals, spikeMatrixFT] = updownamp_Tommy(spikeMatrixFT, fs, filteredData, metadata, metadata.polarity); % the upstroke should reach a higher amplitude than the downstroke, and should be more than intrinsic noise
metadata.updownampRemovalsTEMPLATE = updownampRemovals;
%% check up

%[spikeMatrixFT, prevpostLengthRemovals] = prevspostpeakLength(metadata, spikeMatrixFT, filteredData, fs);
%metadata.prevpostLengthRemovals = prevpostLengthRemovals;
%% long noise removal

if strcmp(sType, 'mu')
    maxL = (fs/1000)*300;
elseif strcmp(sType,'su')
    maxL = (fs/10000)*3*10;
end

if strcmp(sType, 'mu')
for i = 1:size(spikeMatrixFT,2)
    if nnz(spikeMatrixFT(:,i)) > 1 % only does for channels with spikes to avoid error

        [spikeMatrixFT(:,i), ~, checkLP] = longNoiseRemoval_Tommy(spikeMatrixFT(:,i), 0, fs, filteredData(:,i), maxL);
        metadata.templateLP(i) = checkLP;
    end
end
end

%%

finalTemplateRemovals = [0, 0, 0];

for i = 1:size(spikeMatrixFT,2) % for spikes in every channel

    for j = tempL+1:size(spikeMatrixFT,1)-tempL-1 % runs down the matrix

        if spikeMatrixFT(j,i) == 1 % checks if the position of a spike

            trace = filteredData(j-tempL/2:j+tempL/2,i); % gets the trace of the particular spike
            trace = normalize(trace, 'range', [0 1]); % normalizes for comparison to the refined template
            corr = normxcorr2(trace',refinedSpikeTemplate(:,i)');
            similarity = max(corr(tempL*2*0.25:tempL*2*0.75));

            if  similarity < c % runs a final check of the specific spike trace

                spikeMatrixFT(j,i) = 0;
                finalTemplateRemovals = [finalTemplateRemovals; i j similarity];
            end
        end
    end
end
metadata.finalTemplateRemovals = finalTemplateRemovals;



end










