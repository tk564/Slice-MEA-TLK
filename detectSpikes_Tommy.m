function [spikeTrainPos, spikeTrainNeg, filteredData, threshold, timeInterval] = detectSpikes_Tommy(data, method, multiplier, fs, voidPeriod_ms, frequencyRange, sType)

% input 
    % data: a n x 1 vector containing the signal, where n is the number of
    % samples 
    % method: string value specifying the spike detection method to use 
    % multiplier: the threshold multiplier to use for your chosen method 
    % L: loss parameter for wavelet method, won't matter if other methods
    % used. Default is zero as recommended by the creator.

% Original Author: Tim Sit, sitpakhang@gmail.com 
% Edits from AD, Prez, Manuel, Rich, Tommy
% https://www.mathworks.com/matlabcentral/fileexchange/55227-automatic-objective-neuronal-spike-detection?focused=8345812&tab=function
% http://gaidi.ca/weblog/extracting-spikes-from-neural-electrophysiology-in-matlab
% http://cbmspc.eng.uci.edu/SOFTWARE/SPIKEDETECTION/tutorial/tutorial.html
% Last update: 20180503
 


   	

%% Rich's Spike Detection Procedure 

% This is functionally the same as Manuel's method, however, the median
% rather than the mean of the data is used when creating the threshold.
% Although somewhat subtle, this approach avoids an unnecessarily decreased
% (more negative) threshold when there is a high frequency of
% large-amplitude spikes in the recording. 

% A threshold multiplier of 5 is still recomended. However, a decreased
% refractory period, below the 2 ms used in the Schroter et al., 2015
% paper, has been shown to decrease the number of false negatives in 
% recording traces. That is, if you wish to consider that data are infact
% representative of MUA; a 2 ms refractory period somewhat biases detected 
% spikes to be considered as SUA. That being said, either the multiplier or
% imposed refractory period should be changed in the main script rather
% than this funtion.
% I have just changed the method name to Tommy temporarily, but it is
% largely still Rich's work. I intent to remove 'method' references to
% clean up at some point

%% General paramters


%% 
if strcmp(method,'Tommy') % only do the filtering and fs adjustment i
    
    % Create Butterworth Filter and Apply it to MEA Data
    % Dhyrfjeld-Johnson, 2010 uses 1-100Hz to get rid of fast ripples, when
    % this is used I encounter "Warning: Matrix is close to singular or
    % badly scaled. Results may be inaccurate" but not with 500Hz
    % Zhang, 2021 used 2-500Hz when plotting, noting were embedded in fast ripples
    % For now will use 200Hz as suggested by Tanja but can be looked into
    % further


    filteredData = filterData_Tommy(frequencyRange, fs, data, sType);
    if strcmp(sType, 'mu')
       filteredData = downsample(filteredData, 20); % downsampled to 1kHz 
       fs = fs/20; % modify sampling rate based on downsampling, within the detect only section as for noise it is already modified in thresholdDetection_Tommy.m
    elseif strcmp(sType, 'su')
        filteredData = downsample(filteredData,2);
        fs = fs/2;
    end
    
else
    filteredData = data;
end

    timeInterval = 1000/fs; % time interval for metadata
    %% Create Threshold for Channel
    
    m = mean(filteredData); % Finds mean of filtered recording data. Note that filteredData is from one channel, indexed in the batchGestSpike.m function. 
    s = std(filteredData); % more robust and proper
    

    %% find negative deflections
    
    
    thresholdNegative = m - multiplier*s; % Creates threshold for fliltered data. The multiplier can be changed in the main script.
   

    if ~strcmp(method,'noise') && strcmp(sType, 'mu')
        if thresholdNegative > -0.01
       thresholdNegative = -0.01; % Removes data with an amplitude below 8 uV, at this level "spikes" are indistinguishable from noise. This effectively removes "spikes" from the reference and grounded electrodes.
        end
    end


    % Create Preliminary Binary Spike Train
    
    spikeTrainNeg = filteredData < thresholdNegative; % Removes data more positive than negative threshold.
    
    
    
    
    %% find positive spikes
    
    thresholdPositive = m + multiplier*s; % creates positive threshold for positive spike deflections

    if ~strcmp(method,'noise') && strcmp(sType, 'mu')
        if thresholdPositive < 0.01
        thresholdPositive = 0.01; % removes data with amplitude below 8uV
        end   
    end


    spikeTrainPos = filteredData > thresholdPositive; % removes data less than positive threshold

%% void period etc

%% impose void period and shift tSpike to the peak of the spike

if strcmp(sType, 'mu')
    voidPeriod_ms = 200;
elseif strcmp(sType, 'su')
    voidPeriod_ms = 2;
end

if ~strcmp(method, 'template')
for j = 1:size(data, 2)
    [spikeTrainPos] = voidPeriod_Tommy(spikeTrainPos, filteredData, voidPeriod_ms, fs, thresholdPositive);
    [spikeTrainNeg] = voidPeriod_Tommy(spikeTrainNeg, filteredData, voidPeriod_ms, fs, thresholdNegative);
end
end



%% set buffer periods at edges of matrix
% spikes in fringes cannot be analysed by moving windows which are
% implemented sometimes, so at the cost of a small number of spikes better
% to implement a buffer of 0s either side of the recording

spikeTrainPos(1:fs/2) = 0;
spikeTrainPos(length(spikeTrainPos)-fs/2:length(spikeTrainPos)) = 0;

spikeTrainNeg(1:fs/2) = 0;
spikeTrainNeg(length(spikeTrainNeg)-fs/2:length(spikeTrainNeg)) = 0;




    if strcmp(sType, 'mu')
        threshold = thresholdPositive;
    elseif strcmp(sType, 'su')
        threshold = thresholdNegative;
    else
        threshold = thresholdPositive; % most common on inspection
    end

    if strcmp(method, 'noise')
        spikeTrainPos = or(spikeTrainPos, spikeTrainNeg);
    end


end
    
    



 