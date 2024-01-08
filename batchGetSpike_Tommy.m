function batchGetSpike_Tommy(file, method, multiplier, voidPeriod_ms, fs)

% Note that this overwrites files rather than append to them.

%% Load Data

cd('RecFiles');

if strcmp(method,'Tommy')
    
    name = file.name;
    data = load(file.name, 'recording_data');
    data = data.('recording_data');
    data = removevars(data, {'Tms'});
    channels = load(file.name, 'channels');
    channels = channels.('channels');
    channels = channels(2:65);

    fprintf('Data loaded successfully \n')

else
    disp('could not load data')
    

end
    

% cut beginning and end of data to make more manageable
 

dataarray = zeros(size(data));
for i = 1:size(data,2)
    dataarray(:,i) = table2array(data(:,i)); % do channel by channel as was making lag, array is easier to handle
end    
data = dataarray;
clear dataarray; % remove repeated to save RAM
data = data(120*fs:length(data)-5*fs, :); % only analyses from 2 mins in as before this is often poor quality - might even change to less
disp('data converted to array')
    %% Get Spikes and Save 
% consider removing other options to streamline
if strcmp(method,'Tommy')

    frequencyRanges = [1 200];%; 500 3000]; % can add in 100-500 here, but have tried it on several and nothing particularly interesting emerges 
% 500-300
    for i = 1:size(frequencyRanges,1)
        frequencyRange = frequencyRanges(i,:);
        if i == 1
            sType = 'mu';
        elseif i ==2
            sType = 'su';
        else
            sType = indeterminate;
        end

        cd ../
        [spikeMatrix,finalData,thresholds,timeInterval, metadata, spikeMatrixFT, tSpikes, traces] = getSpikeMatrix_Tommy(data, method, multiplier, voidPeriod_ms, fs, name, frequencyRange, sType);
       
        % then repeat inverted
        invertedData = -finalData;
        
      
          [INVspikeMatrix,~,~,~, ~, INVspikeMatrixFT, INVtSpikes, ~] = getSpikeMatrix_Tommy(invertedData, 'negative', multiplier, voidPeriod_ms, fs, name, frequencyRange, sType);
      % only outputs positive IIS metadata and traces...

      tSpikes = or(tSpikes, INVtSpikes);
      spikeMatrixFT = or(spikeMatrixFT, INVspikeMatrixFT);
      spikeMatrix = or(spikeMatrix, INVspikeMatrix);        
        
        tSpikes = sparse(tSpikes);
        spikeMatrixFT = sparse(spikeMatrixFT);
        spikeMatrix = sparse(spikeMatrix);
    
        [signalToNoise] = getSignalToNoise(spikeMatrix, thresholds, metadata);
        
        f1 = frequencyRanges(i,1);
        f2 = frequencyRanges(i,2);

        cd('RecFiles\');
        
        fileName = strcat(file.name(1:end-4),'_', num2str(f1), '-', num2str(f2), '_', sType, 'Spikes_',num2str(multiplier), '.mat');
        save(fileName, 'tSpikes','channels','thresholds', 'timeInterval', 'signalToNoise', 'metadata', 'spikeMatrixFT', 'traces', 'spikeMatrix');
        clearvars tSpikes thresholds timeInterval signalToNoise metadata spikeMatrixFT traces spikeMatrix
        disp(strcat('saved', " ", fileName))

        fileName = strcat(file.name(1:end-4),'_', num2str(f1), '-', num2str(f2), '_', sType, 'finalData_',num2str(multiplier), '.mat');
       
        save(fileName, 'finalData', '-v7.3');
         clearvars finalData
        disp(strcat('saving', " ", fileName))
        
      
    end	        
else
    disp('method inputted incorrectly')
end

cd ../

