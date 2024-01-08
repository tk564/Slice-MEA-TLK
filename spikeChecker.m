function spikeCheck = spikeChecker(recording_data, thresholds, tSpikes)

% this script is just to automate when I want to check a channel's spikes
% againt the threshold levels to make sure it it spikes not noise being
% picked up, and that no spikes are being missed    2    10    31    37    52    59    61

%% load the recording data and tSpikes manually to proceed


    for i = [3 8 15]
        channel = i; % change this to the number of the channel you want to check
        % generally either do the spikiest, or one from different groups - e.g. 1,
        % 3, or 8
        
        data = downsample(table2array(recording_data(:,channel+1)), 20);
        
        data = data(120*1000:size(data,1)-15*1000, :);
        
        %% filter the data - taken from detectSpikes
        
        fs = 20000/20;

        lowpass = 1; % 1 taken from Palani's report (can do future analysis of SWRs hopefully with 0.1)
            highpass = 200; % 200Hz as per Tanja
            wn = [lowpass highpass] / (fs / 2); % Create the window to define the Butterworth function.
            filterOrder = 3; % A suitable order, could be increased but be cautious as this may result in excessive and irrelevant roll-off.
            [b, a] = butter(filterOrder, wn); % Defines the transfer function coefficients of the filter
            filteredData = filtfilt(b, a, data); % Filter data using a Butterworth Function.
        
             d = designfilt('bandstopiir','filterOrder',2, ... % removes the 50Hz noise, neglegible benefit from repeating for 100/150/200
                      'HalfPowerFrequency1',49,'HalfPowerFrequency2',51, ...
                     'DesignMethod','butter','SampleRate',fs);
            filteredData = filtfilt(d, filteredData);
        
        %% make the threshold lines
        
         
        %% plot the graphs
        
       
         if i == 3

              threshold = thresholds(i);
        threshVec = ones(size(data));
        thresh5 = threshVec*threshold;
    

        spikeTrain = full(tSpikes(:,i));
        spikePlot = spikeTrain*threshold;

            subplot(3,1,1) 
            plot(filteredData)
            hold on
            plot(thresh5)
            hold on
            plot(spikePlot)
            hold on

            
        
         elseif i == 8

              threshold = thresholds(i);
        threshVec = ones(size(data));
        thresh5 = threshVec*threshold;
    

        spikeTrain = full(tSpikes(:,i));
        spikePlot = spikeTrain*threshold; 

             subplot(3,1,2) 
            plot(filteredData)
            hold on
            plot(thresh5)
            hold on
            plot(spikePlot)
            hold on
           
         elseif i == 15

              threshold = thresholds(i);
        threshVec = ones(size(data));
        thresh5 = threshVec*threshold;
    

        spikeTrain = full(tSpikes(:,i));
        spikePlot = spikeTrain*threshold; 
        
             subplot(3,1,3) 
       %}
      
            plot(filteredData)
            hold on
            plot(thresh5)
            hold on
            plot(spikePlot)
            
         end
       
    end