function [data] = commonAverageReferenceSub_Tommy(data, neglectGroupRemoval, noisyChannels)
% this basically adds a reference electrode for each group equal to the
% mean of the signal from the other group. Allows thus for the removal of
% all-channel noise such as mechanical disturbance or pump action, without
% reducing the amplitude of spike signals which are often concurrent in the
% same groups

% see https://journals.physiology.org/doi/full/10.1152/jn.90989.2008



% blackGroup = [2 3 4 5 6 7 10 11 12 13 14 20 21 22 29 36 44 45 51 52 53 59 60 61];
% redGroup = [8 15 16 23 24 30 31 32 37 38 39 40 46 47 48 54 55 56 62 63 64];
% neglectGroup = [1 9 17 18 19 25 26 27 28 33 34 35 41 42 43 49 50 57 58];
% 
% commonAverageBlack = median(data(:,blackGroup), 2); % calculates mean in a row-by-row manner, would this be improved by removing off gorup/extra noisy first?
% commonAverageRed = median(data(:,redGroup), 2);
% commonAverageNeglect = median(data(:,neglectGroup),2);
% 
% BxR = xcorr(commonAverageBlack,commonAverageRed,0,'coeff');
% BxN = xcorr(commonAverageBlack, commonAverageNeglect, 0, 'coeff');
% RxN = xcorr(commonAverageRed, commonAverageNeglect, 0, 'coeff'); % finds cross correlation coefficient for each of the three with eachother.

channelsToAverage = 1:64; % sets list of channels to average which can be subsequently modified

if neglectGroupRemoval == 1 % if neglect group has been removed then does not use these for common average
    channelsToAverage([1 9 17 18 19 25 26 27 28 33 34 35 41 42 43 49 50 57 58]) = 0; % have to set to 0 rather than [] as otherwise removing the noisy channels is too difficult
end
channelsToAverage(noisyChannels) = 0; % removes the noisy channels
channelsToAverage = nonzeros(channelsToAverage)';


commonAverage = median(data(:,channelsToAverage), 2);

%% select the common average to use
% can't simply use red average to subtract from black and vice versa
% because if one has high amplitude spikes and the other doesnt this will
% put antipolar spikes in the non-spiking group which will get picked up
% and confuse things due to use of both positive and negative thresholds
% if one channel is spikier than all others its correlation with B/R/N will
% be lower thus the highest correlation indicates the
% not-most-likely-to-confound common average

% if BxR > BxN && BxR > RxN
%     commonAverage = (commonAverageBlack*24 + commonAverageRed*21)/45; % if R and B are most highly correlated then commonAverage taken as a weighted mean of the two of them. Consider using n as the common average but as this tends to be noisier I'm uncertain of if would be wise
% elseif BxN > BxR && BxN > RxN
%     commonAverage = commonAverageBlack; % if black and n correlate the best it implies R has a particularly different waveform thus should not be used for common average as explained above
% elseif RxN > BxR && RxN > BxN
%     commonAverage = commonAverageRed; % as above
% end    


data = data - commonAverage;


data(:, noisyChannels) = 0; % reapply 0s for these groups

if neglectGroupRemoval == 1
    data(:, [1 9 17 18 19 25 26 27 28 33 34 35 41 42 43 49 50 57 58]) = 0;
end
% do this to avoid adding spikes into the null channels

% 
% for i = 1:size(data,2)
% 
%     if find(i == blackGroup)
%         
%         data(:,i) = data(:,i) - commonAverageRed; % if is in black group subtracts the red group common average - removed any common noise but without diminishing the amplitude of the spikes detected by the electrodes in the group!
% 
%     elseif find(i == redGroup)
%         data(:,i) = data(:,i) - commonAverageBlack;
% 
%     else % just ignores the neglect group for now, gets removed completely later
%     
%     end
%  
% end    


