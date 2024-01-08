function sixtyData = highestSixtyAnalysis(data,timeInterval)

 % spikiest 60 s
            close all
          for i = 1:size(data,2)  
            
            time_win        = 	60; % in s
            spikeTrain = data;
            fs = 1000;   
                              
              
                sample_win      = time_win * (fs); % because sampling freq, fs, is in seconds
                slidage         = 10 * fs; % fs = 1 s; so this slides every 10 s
                num_windows     = (length(spikeTrain)- sample_win) / slidage;
                num_done        = 0;
                
                %progressbar
                
                for i = 1:num_windows %-1 so that i can start from 0
                    spike_sums(i)   = sum(spikeTrain(1+slidage*num_done:slidage*num_done+sample_win));
                    num_done        = num_done + 1;
                    %progressbar(i/num_windows)
                end
                most_spikes_index = find(spike_sums == max(spike_sums))-1; % -1 is necessary
                %because if the first window had the most spikes, we need to start from
                %one; if the 2nd window had the most spikes, we need to start from
                %1+slidage*1
                
                if  length(most_spikes_index) > 1
                    most_spikes_index = most_spikes_index(2); %if it's a draw just take second one
                else
                end
                
                %get index of samples to plot
                samples_index = 1+slidage*most_spikes_index:slidage*most_spikes_index+sample_win;
     
     sixtyMatrix = data(samples_index);       
          end

    spikesPerChannel_sixty = sum(sixtyMatrix);
    spikesTot_sixty = nnz(sixtyMatrix);

    [posTime, posChan] = find(sixtyMatrix);
    TimeChanMatrix = [posTime,posChan];

    [frequencyData_sixty] = tSpikeFrequencyAnalysis_Tommy(sixtyMatrix, timeInterval);
    [spikeIntervalData_sixty] = tSpikeIntervalFinder_Tommy(timeInterval, TimeChanMatrix, data); % finds average interval between any two consecutive spikes within the same channel, in seconds
        
    sixtyData.spikesPerChannel_sixty = spikesPerChannel_sixty;
    sixtyData.spikesTot_sixty = spikesTot_sixty;
    sixtyData.frequencyData_sixty = frequencyData_sixty;
    sixtyData.spikeIntervalData_sixty = spikeIntervalData_sixty;
