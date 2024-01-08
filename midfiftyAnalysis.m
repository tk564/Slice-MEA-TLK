function midfiftyData = midfiftyAnalysis(data, timeInterval)
    [midfiftyMatrix] = getXRangeofSpikes(data, 25, 75);

    spikesPerChannel_midfifty = sum(midfiftyMatrix);
    spikesTot_midfifty = nnz(midfiftyMatrix);

    [posTime, posChan] = find(midfiftyMatrix);
    TimeChanMatrix = [posTime,posChan];

    [frequencyData_midfifty] = tSpikeFrequencyAnalysis_Tommy(midfiftyMatrix, timeInterval);
    [spikeIntervalData_midfifty] = tSpikeIntervalFinder_Tommy(timeInterval, TimeChanMatrix, data); % finds average interval between any two consecutive spikes within the same channel, in seconds
        
    midfiftyData.spikesPerChannel_midfifty = spikesPerChannel_midfifty;
    midfiftyData.spikesTot_midfifty = spikesTot_midfifty;
    midfiftyData.frequencyData_midfifty = frequencyData_midfifty;
    midfiftyData.spikeIntervalData_midfifty = spikeIntervalData_midfifty;
end