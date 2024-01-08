function [analysedSpikes, spikesTot, fullData, activeData, stableData, sixtyData, tSpikeConcurrents,channels,concurrencyNetwork, signalToNoise, combinedSpikes, energy, ampdata] = tSpikeAnalysis_Tommy(data, channels, file, finalData, thresholds)

%%
% determine if single or multi-unit

sType = file.name( length(file.name)-13:length(file.name)-12);


%%
% data = load(file.name, 'tSpikes');
% data = data.('tSpikes');

cd("RecFiles\")

timeInterval = load(file.name, 'timeInterval');
timeInterval = timeInterval.('timeInterval'); % miliseconds per division
signalToNoise = load(file.name, 'signalToNoise');
signalToNoise = signalToNoise.('signalToNoise');
metadata = load(file.name, 'metadata');
metadata = metadata.('metadata');
traces = load(file.name, 'traces');
traces = traces.('traces');


if contains(file.name, 'split')
    MEAtype = {'split'};
elseif ~contains(file.name, 'square')
    MEAtype = {'split'};
elseif contains(file.name, 'square')
    MEAtype = {'square'};
end

%% check if analysisng full or partial
if size(data,2) < 64 && nnz(data) > 1   % only applies to the full recording, to avoid error in subgroup analyses
    partial = 1;
else
    partial = 0;
end

%% ignore noisy and non-HPC/EC channels
cd ../

try % have to do try as not all have slice pics always
    if partial == 0 % if not partial, only analyse the channels which are known to be on HPC, no need to do if partial as already only select those which are HPC local
       
        HPCelectrodes = getHPCelectrodes(file);
        nonHPC = zeros(1,size(data,2));
        for i = 1:size(data,2)
            if isempty(find(HPCelectrodes == i))
                nonHPC(i) = 1; % define all the nonHPC channels
            end
        end
        nonHPC = find(nonHPC);

        exclude = [nonHPC, metadata.channels.noisyChannels]; %, metadata.channels.noisyChannels]; % if an old analysis without StoN just uses noisy channels
    end

catch % in case no slice picture analysed yet

    exclude = metadata.channels.noisyChannels;

end


if exist('exclude')
    for i = exclude
        data(:,i) = 0;
        finalData(:,i)=0;
    end
end





%% exclude all 'inactive' channels from analysis


totalEvents = nnz(data);

activeChannelThreshold = 20; % allowing for 1 FP per minute



for i = 1:size(data, 2) % selects channel
    if nnz(data(:,i)) < activeChannelThreshold % excludes from further analysis if deemed 'inactive'
        data(:,i) = 0; % if fewer than 13 all values set to 0 so don't come up in further analyses
        finalData(:,i)=0;
    end
end


%% remove lowest 25% of spiking channels
lowerQuartile = quantile(nonzeros(sum(data)), 0.25);
for i = 1:size(data,2)
    if nnz(data(:,i)) < lowerQuartile
        data(:,i) = 0; % excludes channels below the lower quartile activity from further analysis
        finalData(:,i) = 0;
    end
end
%
%
% [a b] = find(data,1); % find time of first spike
% data(1:a,:) = []; % remove everything before the first spike



analysedSpikes = sparse(data);

%% frequency per channel and for whole, and total spikes


activeChannels = nnz(sum(data)); % simply finds number of spikes in all the active channels
spikesTot = 0; % sets 0 to avoid error

if or(activeChannels > 2, partial == 1) % arbitrary, but looking at data clearly shows that all channels in a subfield are active or none active, so certainly expect at least 5

    % full recording
    spikesTot = sum(nnz(data));

    %% combine channels for whole rec - basically to account for the 1 spike being picked up multiple time (if is big amplitude and sayin onyl 30% of them make it to channel x from y then it drafs down the mean firing freq)
    % keptwhole = zeros(1,200);
    v = 25; % determined by graphical inspeciton see keptprop and keptwhole
    % p=0;
    % for v = 1:50
    %     p=p+1

    combinedSpikes = sum(data,2);
    %     keptwhole(p) = nnz(combinedSpikes);
    for i = 1:length(combinedSpikes)
        if combinedSpikes(i) > 0

            if combinedSpikes(i) > 1
                combinedSpikes(i) = 1;
            end
            combinedSpikes(i+1:i+v) = 0;
        end
    end
    %     keptwhole(p) = nnz(combinedSpikes) / keptwhole(p);



    combinedSpikes = sparse(combinedSpikes);

    %% subfields

    %
    %     keptprop = zeros(51,3);
    % p=0;
    % for v = 1:20:1001
    % p = p+1
    if partial == 0
    datatoanalyse = zeros(size(data));
    subfieldTrain = zeros(length(data),3);
    left = [1 9 17 18 19 25 26 27 28 33 34 35 41 42 43 49 50 57 58];
    top = [2 3 4 5 6 7 10 11 12 13 14 20 21 22 29 36 44 45 51 52 53 59 60 61];
    right = [8 15 16 23 24 30 31 32 37 38 39 40 46 47 48 54 55 56 62 63 64];

    groups = {'left', 'top', 'right'};
    for i = 1:length(groups)

        if i == 1
            to_combine = left;
        elseif i == 2
            to_combine = top;
        elseif i ==3
            to_combine = right;
        end

        combined_train = sum(data(:,to_combine),2);
        %      keptprop(p,i) = nnz(combined_train);

        for j = 1:length(combined_train)
            try
                if combined_train(j) ~= 0
                    if combined_train(j) > 1
                        combined_train(j) = 1;
                    end
                    combined_train(j+1:j+v) = 0; % period to stop detection of same event multiple times
                end
            catch
            end
        end

        subfieldTrain(:,i) = combined_train;
        %           keptprop(p,i) = nnz(combined_train)/keptprop(p,i);

        for k = 1:size(datatoanalyse,2)
            if nnz(k == to_combine) == 1 && nnz(data(:,k)) > 0 % if correct subfield and an active channel
                datatoanalyse(:,k) = combined_train;
            end
        end
    end

    else
        datatoanalyse = data;

    end

    %%    %
    %
   [TimeChanMatrix, fullData] = fullDataAnalysis(data, timeInterval, 'whole');
    [TimeChanMatrix,activeData] = fullDataAnalysis(data,timeInterval, 'active');

    %     midfiftyData = midfiftyAnalysis(data, timeInterval);
    %     [~, stableData] = stablePeriodAnalysis(data, timeInterval);
    %     [sixtyData] = highestSixtyAnalysis(data,timeInterval);
    midfiftyData = 0;
    stableData = 0;
    sixtyData = 0;
    % get amplitude data


    ampdata = ampAnalysis(data,traces);


    energies = zeros(1,size(data,2));
    energies2 = zeros(1,size(data,2));
    energies3 = zeros(1,size(data,2));


    for i = 1:size(data,2)
        if nnz(data(:,i)) ~= 0
            chan = i;
            [energies(i), energies2(i), energies3(i)] = sliceEnergy(datatoanalyse(:,i),traces,chan);
        end
    end

    energyMean = mean(nonzeros(energies));
    energyMean2 = mean(nonzeros(energies2));
    energyMean3 = mean(nonzeros(energies3));

    energy.energyMean = energyMean;
    energy.energyMean2 = energyMean2;
    energy.energyMean3 = energyMean3;

    % [tSpikeConcurrents,concurrencyNetwork] = tSpikeConcurrentFinder_Tommy(data, TimeChanMatrix, splitMEA, MEAtype,file); % reports where one spike may be linked to another temporally
    tSpikeConcurrents = NaN;
    concurrencyNetwork = NaN;
    %% plot various graphs
    if partial == 0

        %         finalData(1:a,:) = [];
        split = strsplit(file.name,'_');
        filters = string(cell2mat(split(2)));
        filters = strsplit(filters,'-');
        f1 = str2num(filters(1));
        f2 = str2num(filters(2));

        [pos, time] = find(data);
        rasterMat = [pos, time];


        try plotRaster_Tommy(rasterMat, timeInterval, file, f1, f2, data); % only plot the raster for all 64 channels, not partial
        catch
            disp(strcat('raster did not work for', file.name));
        end

        spike_overlay_Tommy(file, 'Tommy', 6, 500, 1000, finalData, data, thresholds, f1, f2, analysedSpikes, sType); % produces the spike overlay plots

    end

else
    [fullData, activeData, stableData, sixtyData, tSpikeConcurrents, concurrencyNetwork, energy, ampdata] = null_output;
    disp('insufficient number of active channels, check spike overlay to confirm non-spikiness')
    combinedSpikes = 0;
end

if activeChannelThreshold < 2 && ACforlater > 5 % if originally the threshold was too low but there are still sufficient channels then makes a new tot spikes
    spikesTot = totalEvents;

end






