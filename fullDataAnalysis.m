function [TimeChanMatrix, fullData] = fullDataAnalysis(data, timeInterval, activePeriod)
    spikesPerChannel_full = sum(data);
    
    spikesTot_full = nnz(data);   
    
    %% full length recording
    [posTime, posChan] = find(data);
    TimeChanMatrix = [posTime,posChan];
    

    [frequencyData_full] = tSpikeFrequencyAnalysis_Tommy(data, timeInterval, activePeriod);
    [spikeIntervalData_full] = tSpikeIntervalFinder_Tommy(timeInterval, TimeChanMatrix, data); % finds average interval between any two consecutive spikes within the same channel, in seconds
        

    
    fullData.spikesPerChannel_full = spikesPerChannel_full;
    fullData.spikesTot_full = spikesTot_full;
    fullData.frequencyData_full = frequencyData_full;
    fullData.spikeIntervalData_full = spikeIntervalData_full;


    %% only the interictal periods

    


end