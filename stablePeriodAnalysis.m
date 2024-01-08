function [TimeChanMatrix, stableData] = stablePeriodAnalysis(data, timeInterval)
    [stableMatrix, stableBins, stableRange] = getStableSpikes(data, timeInterval);

    spikesPerChannel_stable = sum(stableMatrix);
    spikesTot_stable = nnz(stableMatrix);

    [posTime, posChan] = find(stableMatrix);
    TimeChanMatrix = [posTime,posChan];

    [frequencyData_stable] = tSpikeFrequencyAnalysis_Tommy(stableMatrix, timeInterval);
    [spikeIntervalData_stable] = tSpikeIntervalFinder_Tommy(timeInterval, TimeChanMatrix, data); % finds average interval between any two consecutive spikes within the same channel, in seconds
        
    stableData.spikesPerChannel_stable = spikesPerChannel_stable;
    stableData.spikesTot_stable = spikesTot_stable;
    stableData.frequencyData_stable = frequencyData_stable;
    stableData.spikeIntervalData_stable = spikeIntervalData_stable;
    stableData.stableBins = stableBins;
    stableData.stableRange = stableRange;
end