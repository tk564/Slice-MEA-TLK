function [spikeMatrixPos, spikeMatrixNeg, checkLP] = longNoiseRemoval_Tommy(spikeMatrixPos, spikeMatrixNeg, fs, filteredData, maxL)

% removes any events which spend an unreasonable amount to time above
% threshold suggesting it is a noise event rather than a spike
% note although 'matrix' is used this is really dealing with each channel
% at a time
checkLP = 0; %legacy
%% positive first

%c = 0.3*fs; % cutoff length, 300ms empirically so far - some papers suggest much larger but these are for EEG. remember fs = 1s
c = maxL;
% Staley, 2012 refers to IIS as <250ms
% Ratnadurai-Giridharan, 2014 refers as <400ms
% remember i am reffering only to the initial upshot
% higher cutoff selected for now to preserve as many spikes as possible
% however as I am only recording detecting between when it is above
% threshold could potentially make smaller, or else change it so I detect
% the length of each spike from isoelectric - seems excessive effort though

baseline = mean(filteredData);

%% following is adapted from https://uk.mathworks.com/matlabcentral/answers/293926-how-do-i-find-4-or-more-consecutive-zeros-and-replace-these-zero-s#answer_227827

if nnz(spikeMatrixPos) ~= 0
spikes = find(spikeMatrixPos);

%lengthsP = zeros(nnz(spikeMatrixPos),2);

%remN = 1;
for i = 1:length(spikes)

    
    startSpike = find(filteredData(1:spikes(i)) < baseline, 1, 'last'); % last value below zero before spike thus 1 before spike begins
    endSpike = find(filteredData(spikes(i):length(filteredData)) < baseline, 1, 'first')+spikes(i); % first value below zero after spike 
    spikeLength = endSpike - startSpike;
  
    if spikeLength > c % if above a certain length
        spikeMatrixPos(spikes(i)) = 0; % sets 1 to 0 indicating was not a true spike
        %remN = remN+1;
    end


end

%checkLP = remN;
else
    spikeMatrixPos = NaN;
end


%% then negative
if nnz(spikeMatrixNeg) ~= 0
spikes = find(spikeMatrixNeg);
%lengthsN = [0];

for i = 1:length(spikes)
    startSpike = find(filteredData(1:spikes(i)) < baseline, 1, 'last'); % last value above zero before spike thus 1 before spike begins
    endSpike = find(filteredData(spikes(i):length(filteredData)) > baseline, 1, 'first')+spikes(i); % first value above zero after spike 
    spikeLength = endSpike - startSpike;
   % lengthsN = [lengthsN; spikeLength]; % for testing

    if spikeLength > c % if above a certain length
        spikeMatrixNeg(spikes(i)) = 0; % sets 1 to 0 indicating was not a true spike
    end
end

%checkLN = max(lengthsN);

else
    spikeMatrixNeg = NaN;
end
end


