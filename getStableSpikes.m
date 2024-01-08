function [stableMatrix, stableBins, stableRange] = getStableSpikes(data, timeInterval)

%% analyses frequency of a number of bins to determine which period of minimum x% of recording is relatively stable

bins = 20; % number of bins recording divided into while finding stabnlest period
minStableRange = 0.3;
stableMatrix = zeros(size(data));

%% get analysis windows
analysisWindows = zeros(bins, 2);

for i = 1:bins
    analysisWindows(i, 1) = (100/bins)*(i-1);
    analysisWindows(i, 2) = (100/bins)*(i);
end


%% analyse each window

frequencyPerBin = zeros(bins,size(data,2));


for j = 1:bins

    [windowMatrix] = getXRangeofSpikes(data, analysisWindows(j,1), analysisWindows(j,2));
    [frequencyData] = tSpikeFrequencyAnalysis_Tommy(windowMatrix, timeInterval);
    frequencyPerBin(j,:) = frequencyData.freqPerChannel_Hz;
   
end

%% determine the stable period of the frequency in each channel of the recording
% will take the mean of the frequency across the whole recording then
% select longest continguous period within 3SD of the mean

stableBins = zeros(bins, size(data,2));
stableRange = zeros(size(data,2),2);

for i = 1:size(data,2) % go through each channel

    if nnz(data(:,i)) >= bins
        m = mean(frequencyPerBin(:, i)); % mean of the frequencies of each bin
        s = std(frequencyPerBin(:,i)); % STD of the frequencies of each bin
        multiplier = 1.5; % for standard 95% significance
    
        highCutoff = m+multiplier*s;
        lowCutoff = m-multiplier*s;
    
        belowCutoff = frequencyPerBin(:,i) < highCutoff;
        aboveCutoff = frequencyPerBin(:,i) > lowCutoff;
    
        binsInWindow = and(belowCutoff, aboveCutoff);
        binsInWindow = [binsInWindow; 0]; % need to add a 0 in at end for length detection, removes after 
    
        stableLengths = zeros(bins, 1);
    
        for j = 1:bins
            
            if binsInWindow(j) == 1
    
                firstBin = j;
                stableLength = find( ~binsInWindow(firstBin:length(binsInWindow)), 1, 'first' )-1; % looks for the first 0 and thus tells what the length of the run of 1s is, hence why 0 concatenated to the end
                stableLengths(j) = stableLength;
            end
        end
    
        stableStart = find(stableLengths == max(stableLengths));
        if length(stableStart) > 1
            stableStart = stableStart(length(stableStart)); % if multiple of same length, selects the latest as in experience later recordings tend to be more stable
        end    
        stableEnd = stableStart + stableLengths(stableStart)-1;
        stableLengthChosen = stableLengths(stableStart);
        
    
        if (stableLengthChosen/bins) < minStableRange % if less than a desired proportion of bins selected
           
            toAdd = (minStableRange - (stableLengthChosen/bins))*10;
    
            addtobottom = ceil(toAdd/2);
            addtotop = ceil(toAdd/2);
    
            if stableStart - addtobottom < 1 % these two little codes make sure that if more bins are needed they dont try and select a -1 or >n(bins) bin
                addtotop = addtotop - (stableStart - addtobottom);
                addtobottom = addtobottom + (stablestart - addtobottom);
            end
    
            if stableEnd + addtotop > bins
                addtotop = addtotop - (stableEnd + addtotop - bins);
                addtobottom = addtobottom + (stableEnd + addtotop - bins);
            end
    
        stableStart = stableStart - addtobottom;
        stableEnd = stableEnd + addtotop; % adds on the necessary bins to meet the minimum proprotion of recording required
    
        end
       
       minNth = (100/bins)*(stableStart-1) + 1;
       maxNth = (100/bins)*stableEnd;
       [stableTrain] = getXRangeofSpikes(data(:,i), minNth, maxNth); 
        stableMatrix( size(stableMatrix,1)-size(stableTrain,1)+1:size(stableMatrix,1),i) = stableTrain;

       stableRange(i,1) = stableStart/bins;
       stableRange(i,2) = stableEnd/bins; % divide each by number of bins so can see what % of the data has been included in this
    else
        stableMatrix(:,i) = data(:,i);
        

    end    
end

    
end





%%