function [finSpikeTrain] = templateTrains(filteredData, metadata, sType, refinedSpikeTemplate,c,fs, tempL, void)


warning('off')
xcorrMatrix = zeros(size(filteredData));

    if sum(refinedSpikeTemplate) ~= 0
        tempL = length(refinedSpikeTemplate)-1;
        b = normxcorr2(refinedSpikeTemplate, normalize(filteredData, 'range', [0 1]));
        b = b(tempL/2+1: length(b)-tempL/2);
        xcorrMatrix = b;
    else
        xcorrMatrix = zeros(size(filteredData,1),1);
    end

clearvars b % memory issues

 if metadata.polarity == 1
     tempThresh = 0.01; 
     %tempThresh = mean(filteredData)+1*std(filteredData);
     %   if tempThresh < 0.01 && strcmp(sType, 'mu')
      %      tempThresh = 0.01;
       % end
    elseif metadata.polarity == -1
        tempThresh = mean(filteredData) - 3*std(filteredData);
    end



    % move to the peaks
    spikeTrain = xcorrMatrix > c;
    spikeTrain( length(spikeTrain)-fs:length(spikeTrain)) = 0; % add buffer at the end to avoid errors, means could miss 1s of spiking which is not significant
    spikeTrain(1:fs) =0; %1s buffer at start also
    for j = 1:length(spikeTrain)
        if spikeTrain(j)==1
            spikeTrain(j+1:j+void) = 0;
        end
    end
    %



    peakTrain = zeros(size(spikeTrain));
    for j = 1:length(spikeTrain)

        if spikeTrain(j) == 1
            startTrain = j;
            trainLength = void;

            if metadata.polarity == 1 % centres the train around the max/min depending on if a positive or negative polarity spike
                spikePosition = find(filteredData(startTrain-tempL/2:startTrain+trainLength+tempL/2) == max(filteredData(startTrain-tempL/2:startTrain+trainLength+tempL/2)))+startTrain-tempL/2;
            elseif metadata.polarity == -1
                spikePosition = find(filteredData(startTrain-tempL/2:startTrain+trainLength+tempL/2) == min(filteredData(startTrain-tempL/2:startTrain+trainLength+tempL/2)))+startTrain-tempL/2;
            end
            if length(spikePosition) > 1 % only selects 1 position if there are mutliple of the same height
                spikePosition = spikePosition(1);
            end
            peakTrain(spikePosition) = 1;
            spikeTrain(startTrain:startTrain+trainLength) = 0; % so dont reanalyse same spike
        end
    end
    clearvars spikeTrain % memory issues
    ampTrain = peakTrain.*filteredData;
    clearvars peakTrain % memory issues

    if metadata.polarity == 1
        finSpikeTrain = ampTrain > tempThresh;
    elseif metadata.polarity == -1
        finSpikeTrain = ampTrain < tempThresh;
    end
end
