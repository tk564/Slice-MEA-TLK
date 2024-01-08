function [spikeMatrixFT,prevpostLengthRemovals]  = prevspostpeakLength(metadata, spikeMatrixFT, filteredData, fs)

polarity = metadata.polarity;
prevpostLengthRemovals = [0,0,0,0];

for i = 1:size(spikeMatrixFT,2)
    movingmean = movmean(filteredData(:,i), 10*fs);
    
    for j = 2*fs+1:size(spikeMatrixFT,1)-2*fs % necessary sacrefice of perhaps checking some spikes so that can get a rolling mean for baseline
        if spikeMatrixFT(j,i) == 1
            trace = filteredData(j-2*fs:j+fs*2,i);

            
            baseline = movingmean(j);
            if polarity == 1
                prePeak = find(flip(trace(1:fs*2)) < baseline, fs/5, 'first'); % 40ms sample above baseline (Accounts for anomalous data which might stray below threshold when trace is not actually stable.   
                           
                if isempty(prePeak)
                    spikeMatrixFT(j,i) = 0;
                    prevpostLengthRemovals = [prevpostLengthRemovals; i, j, 0, 0]; % if never dips below baseline suggests this is not a positive deflection, thus remove
                    prePeak = 1;  % just a placeholder so script can continue, might mean is counted twice in prevpostLengthRemovals but c'est la vie
                end            
                 n = findRuns(prePeak, 10); % must have met above criteria for 10 consecutive datapoints
                prePeak = prePeak(n); % selects only the correct point


                endOfDownstroke = find( trace(fs/2:length(trace)) < baseline, fs/5, 'first');
                n = findRuns(endOfDownstroke,10);
                endOfDownstroke = endOfDownstroke(n); % choosing the last here does not introduce an error as the +40or so data points are negated by the next part starting later

                endOfRepol = find( trace(fs*2+endOfDownstroke:length(trace)) > baseline, fs/5, 'first' );
                
                % sometimes breaks as doesn't do the 'repolarisation' phase
                % in time, which is indicative the waveform is not what you
                % want so ok to remove these
                if isempty(endOfRepol)
                    spikeMatrixFT(j,i) = 0;
                    prevpostLengthRemovals = [prevpostLengthRemovals; i, j, prePeak, 0];
                    endOfRepol = 1;  % just a placeholder so script can continue, might mean is counted twice in prevpostLengthRemovals but c'est la vie
                end
                n = findRuns(endOfRepol, 10); 
                endOfRepol = endOfRepol(n);
                postPeak = endOfDownstroke+endOfRepol;



            else
                
                prePeak = find(flip(trace(1:fs*2)) > baseline, fs/5, 'first'); % 40ms sample above baseline (Accounts for anomalous data which might stray below threshold when trace is not actually stable. 
               if isempty(prePeak)
                    spikeMatrixFT(j,i) = 0;
                    prevpostLengthRemovals = [prevpostLengthRemovals; i, j, 0, 0]; % if never dips below baseline suggests this is not a positive deflection, thus remove
                    prePeak = 1;  % just a placeholder so script can continue, might mean is counted twice in prevpostLengthRemovals but c'est la vie
                end 
                n = findRuns(prePeak, 10); % must have met above criteria for 10 consecutive datapoints
                prePeak = prePeak(n); % selects only the correct point
                                               
                endOfDownstroke = find( trace(fs*2:length(trace)) > baseline, fs/5, 'first');
                n = findRuns(endOfDownstroke,10);
                endOfDownstroke = endOfDownstroke(n); % choosing the last here does not introduce an error as the +40or so data points are negated by the next part starting later

                endOfRepol = find( trace(fs*2+endOfDownstroke:length(trace)) < baseline, fs/5, 'first' );
                % sometimes breaks as doesn't do the 'repolarisation' phase
                % in time, which is indicative the waveform is not what you
                % want so ok to remove these
                if isempty(endOfRepol)
                    spikeMatrixFT(j,i) = 0;
                    prevpostLengthRemovals = [prevpostLengthRemovals; i, j];
                    endOfRepol = 1;  % just a placeholder so script can continue, might mean is counted twice in prevpostLengthRemovals but c'est la vie
                end
                n = findRuns(endOfRepol, 10); 
                endOfRepol = endOfRepol(n);
                postPeak = endOfDownstroke+endOfRepol;

            end
            
            if prePeak > 2*postPeak
                spikeMatrixFT(j,i) = 0;
                prevpostLengthRemovals = [prevpostLengthRemovals; i, j, prePeak, postPeak];
            end
        end
    end
end
end