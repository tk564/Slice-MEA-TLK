function n_as_max = checkSameSpike(finalData, spikeMatrix, method)
% preprocessing

n_as_max = zeros(1,64);

file.name = '20170815003';
 slicepics = readtable("slice pic analysis.xlsx", 'VariableNamingRule', 'preserve'); % load the table with channel info
    slicepics = table2cell(slicepics);
    allData = readtable('(AD and Epilepsy) Total MED64 Data.xlsx', 'VariableNamingRule', 'preserve');
    recording = file.name(1:11); % gets the recording name
    [~, ~, ~, slice, ~] = getMetadata(recording, allData); % gets the slice number from big table

    
    indexer = cell2mat(slicepics(:,1:2));
    date = str2num(recording(1:8));
    row = 0;
    for i = 1:size(slicepics,1)
        
        if indexer(i,1) == date
           
            if indexer(i,2) == slice
                row = i;
            end
        end
    end
    HPCelectrodes = [str2num(slicepics{row,5}), str2num(slicepics{row,6}),  str2num(slicepics{row,7}), str2num(slicepics{row,12})]; % get channels of DG/CA3/CA1all/ECnd

for i = 1:64
    if nnz(i == HPCelectrodes) == 0
        spikeMatrix(:,i) = 0;
    end
end





%% get amplitude matrix
ampMatrix = zeros(size(spikeMatrix));
minV = 0.001;
tWin = 25; % time window in ms, with +/- around the selected spike timepoiint
close
ampMatrix = full(finalData.*spikeMatrix);

avgAmp = zeros(1,size(spikeMatrix,2));
for i = 1:size(spikeMatrix,2)
    avgAmp(i) = mean(nonzeros(ampMatrix(:,i)));
end



% surf(ampMatrix); % makes very cool surface plot of spikes



[all_spikes, chan] = find(spikeMatrix);

% remove if within the twin
all_spikes = sort(all_spikes);
diffs = all_spikes(2:end) - all_spikes(1:end-1);

keep = diffs > tWin;
keep = [1;keep];
all_spikes = all_spikes.*keep;
all_spikes = nonzeros(all_spikes);



% get space matrix



% for i = 1:length(all_spikes);

spaceMatrixBase = zeros(26,38);
%time = all_spikes(round(rand*length(all_spikes))); % select a time from all_spikes, ideally make into a gif or something?

if strcmp(method, 'show')
 all_times = all_spikes(round(rand*length(all_spikes)));
else
    all_times = all_spikes;
end


for i = 1:length(all_times)
    time = all_times(i);
    ampAtTime = max( ampMatrix(time-tWin:time+tWin, :));
    %ampAtTime = finalData(time,:);

    spaceMatrix = getSpaceMatrix(spaceMatrixBase, ampAtTime);


    
    electrode = find(ampAtTime == max(ampAtTime));
    if length(electrode) > 1
        electrode = electrode(1);
    end
    if nnz(ampAtTime) > 5
    n_as_max(electrode) = n_as_max(electrode) + 1;
    end
    
    placeholders = ones(1,64)*0.001;
    electrodePositions = getSpaceMatrix(spaceMatrixBase, placeholders);
end



%if nnz(spaceMatrix) > 3
surf(spaceMatrix);


% [n o p] = find(spaceMatrix');
% f = fit([n,o], p, 'cubicinterp');
%     plot(f, [n,o], p);

% [t u v] = find(electrodePositions');
% f2 = fit([t u], v, 'linearinterp');
% plot(f2, [t u], v);
% title(num2str(time))
% 
% 
% % else
% %     disp('Not detected in sufficient channels')
% % 
% % end
% 
% %% modify in prep for interpolation
% scaleFactor = 5; % scale factor for upscaling
% upscaleM = zeros(size(spaceMatrix)*scaleFactor); % creates matrix to writ eupscaled size to
% 
% [a, b, c] = find(spaceMatrix); % gets the location and size of spikes in original matrix
% update = [a*scaleFactor, b*scaleFactor, c]; % scales up the coordinates without introducing new amplitudes
% 
% % 
% % for p = 1:size(update,1)
% %     if update(p,3) == minV
% %         update(p,:) = []
% 
% for u = 1:length(update)
%     upscaleM(update(u,1), update(u,2)) = update(u,3); % adds new values into matrix
% end
% 
% %% estimate decay constant 
% 
% %%
% % 
% % 
% % timesToIterate = scaleFactor*2; % i think suitable? Maybe just SF?
% % mergeM = upscaleM;
% % for t = 1:timesToIterate
% %     [d, e] = find(mergeM);
% %     toavg = [d,e];
% % 
% %     mod = 1; % modifier to calc earlier for exponential decay over distance, leave as 1 for now
% %     for f = 1:size(toavg,1)
% %         x = toavg(f,1);
% %         y = toavg(f,2);
% %         newval = mean([mergeM(y+1,x)*mod, mergeM(y-1,x)*mod, mergeM(y, x+1)*mod, mergeM(y, x-1)*mod]);
% % 
% %         mergeM(y,x) = newval;
% % 
% %     
% % 
% %     end
% % end
% % 
% % 
% % 
% % 
% % 
% % 
% % %surf(upscaleM
% % 
% % %% calculate the rate of decay from max amp
% % 
% % maxChannel = find(ampAtTime == max(ampAtTime));
% % 
% % 
% % 
% % 
% % 
% 
% 




