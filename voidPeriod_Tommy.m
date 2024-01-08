function [spikeTrainOutput] = voidPeriod_Tommy(spikeTrain, filteredData, voidPeriod_ms, fs, thresholds)

%% detect polarity of events

if mean(thresholds) > 0
    polarity = 1;
elseif mean(thresholds) < 0
    polarity = -1;
else
    disp('could not get polarity for channel - assuming positive')
    polarity = 1;
end

    %% Impose a Void Period to Create a Final Binary Spike Train.
   

    voidPeriod = voidPeriod_ms * 10^-3 * fs;  % Your chosen void period (in ms) will now be expressed as a window based on the sampling frequency.
    spikeTrain = double(spikeTrain); % Converts data to type double, contains preliminary spike times (1s) and non-spike times (0s), the spike train therefore becomes binary.
    
 spikeTrainOutput = spikeTrain; % must write changes onto different array else tracks along and end up with only 1 in the final position
    for i = 1:length(spikeTrain)
       if spikeTrain(i) == 1 % Where there is a data point below the threshold, it is considered a "spike" and is therefore a 1 in the binary spike train.
           refStart = i + 1; % Start of void period. 
           refEnd = round(i + voidPeriod); % End of void period.
           if refEnd > length(spikeTrain)
               spikeTrain(refStart:length(spikeTrain)) = 0; % Mitigates an error (extension of the vector) if a spike occurs close to the end of a recording.

           else 

               if polarity == 1
                  peak = find( filteredData(i:i+voidPeriod) == max(filteredData(i:i+voidPeriod))); % finds the peak of the data, using max in this case as the negative train
               else
                   peak = find( filteredData(i:i+voidPeriod) == min(filteredData(i:i+voidPeriod))); % finds the peak of the data, using min in this case as the negative train
               end
               
               peak = peak + i; % needed because find gives number relative to the window it searched in

               if length(peak) > 1
                   peak = peak(1); % avoids error in event of two points of same value'
               end

               spikeTrain(i:refEnd) = 0; % voids the next period to speed up the script, we know all subsequent 1s covered by this iteration

               spikeTrainOutput(i:refEnd) = 0; % Sets all data within the detected period of the spike to be 0 (i.e. not a spike) even if it was previosuly a 1 (due to having an amplitude below the threshold) in the preliminary binary spike train.
               spikeTrainOutput(peak) = 1; % reimposes a 1 to indicate a spike has been detected, specifically at the peak of the data
           end 
       end 
    end 

%    if nnz(spikeTrainOutput) > 10000 %value atm is arbitrary, discuss with Rich
%        spikeTrainOutput = zeros(size(spikeTrain)); % Removes data which due to some anomaly has an unrealistic number of detected spikes
%    end
%    
   
end   