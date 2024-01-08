function [spikeMatrix, eventsRemoved] = multiChannelNoiseRemoval_Tommy(spikeMatrix, noiseMatrix, noisyChannels, neglectGroupRemoval, numberToReach, w)

% this function detects if there is a concurrent event across all the
% electrodes of the array under the assumption following observation that
% such an event will be noise
% a window will be used rather than an exact moment but the result ought to
% be the same

% w = window size for checking multichannel coincidences
%n = numberToReach-nnz(noisyChannels)-19*neglectGroupRemoval; % number of channels event needs to be in to get removed, - noisy channels as set to 0 and - the 19 neglected channels if they have been set to be neglected (19x as 19 channels, and ==1 if neglecting turned on)
n = numberToReach;
% 1000 / 10 = 100ms

%%  for threshold method


eventsRemoved = zeros(1, size(spikeMatrix,2)+2); % makes room for location of event, number of channels, and the channels it was detected in
maxIndex = floor( (length(noiseMatrix)-w)/w)*w;

for i = w+1:w/2:maxIndex % runs down entire length of the spikeMatrix row by row, from w+1 to avoid error of checking if noise exists within period 0-w

    if nnz(sum(noiseMatrix(i-w:i+w,:))) > n % checks if sufficient events have occured within the window
        eventsRemoved = [eventsRemoved; i nnz(sum(noiseMatrix(i-w:i+w,:))) sum(noiseMatrix(i-w:i+w,:))];

        spikeMatrix(i-w:i+w, :) = 0; % sets the window to 0
    end



end



end









