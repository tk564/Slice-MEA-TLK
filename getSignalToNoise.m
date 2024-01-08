function [signalToNoise] = getSignalToNoise(tSpikes, thresholds, removed)

%% get signal
signal = nnz(tSpikes);

%% determine polarity of spikes
if mean(thresholds) > 0
    polarity = 1;
elseif mean(thresholds) < 0
    polarity = 0;
else
    polarity = 1; % not sure why thresholds would ever be 0 but build this in to avoid errors just in case
end


%% get noise
if polarity == 1

    noise = removed.spikes.multichannelPos + removed.spikes.longremovalPos + removed.spikes.repetitivePos + size(removed.spikes.spikesRemovedByTemplate, 1);

else
    noise = removed.spikes.multichannelNeg + removed.spikes.longremovalNeg + removed.spikes.repetitiveNeg + size(removed.spikes.spikesRemovedByTemplate, 1);

end

%% get S/N

if noise == 0
    noise = 0.01; % makes sure there will always be a value for noise to avoid errors. In the event of '0 noise' which I consider highly unlikely there will be a large S/N
end


signalToNoise = signal / noise;

