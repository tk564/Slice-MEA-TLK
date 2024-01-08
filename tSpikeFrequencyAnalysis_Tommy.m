function [frequencyData, dataMax, dataUQ] = tSpikeFrequencyAnalysis_Tommy(data, timeInterval, activePeriod)
% function to do freuqneyc analysis from tSpike matrix

%% analyse the data
% activeDurations = zeros(1,size(data,2));
% for i = 1:size(data,2)
%     if nnz(data(:,i)) > 0 % to avoid error on non-spiking channels
%         firstSpike = find(data(:,i), 1, 'first');
%         lastSpike = find(data(:,i), 1, 'last');
%         activeFor = lastSpike - firstSpike;
%         activeDurations(i) = activeFor;    
%     end     
% end

for i = 1:size(data,2)
    if strcmp(activePeriod, 'whole')
    activeDurations(i) = size(data,1); % Rich says use whole length of recording, messes with midfifty etc but maybe just remove that
    elseif strcmp(activePeriod,'active')

        

        if nnz(data(:,i)) >= 20
            all = nnz(data(:,i));
            n = floor(all*0.1); % need 90% of all the spikes in the recording
            times = find(data(:,i));

         
            % to get 90% must at least start by the 10th percentile spike
            % or end by the 90th percentile spike (10-100 or 0-90)
%             firsts = times(1:n);
%             lasts = times(all-n+1:all);
%          
%             windows = lasts - firsts;
%             chosen = find(min(windows));
% 
%             window = windows(chosen);
%             first = firsts(chosen);
%             last = lasts(chosen);
% 
%             activeDurations(i) = window;
%             data(1:first,i) =0;
%             data(length(data)-last:length(data)) = 0;
        
            time_A = activeTime(all, 10*1000, 1, length(data), times);
            activeDurations(i) = time_A;

       
        else
            activeDurations(i) = size(data,1);
            data(:,i) = 0;
        end
    end
end


%%

freqPerChannel_Hz = zeros(1,size(data,2));
for i = 1:size(data,2)
    freqPerChannel_Hz(i) = sum( data(:,i)) / (activeDurations(i)*timeInterval/1000);
end    
freqPerChannel_Hz(isnan(freqPerChannel_Hz))=0;



%% UQ firing channel

dataInOrder = sort(nonzeros(freqPerChannel_Hz));
if isempty(dataInOrder)
    dataInOrder = 0;
end    
freqMaxFiringChannel_Hz = dataInOrder(length(dataInOrder));
freqUQFiringChannel_Hz = dataInOrder(ceil(0.75*length(dataInOrder)));
freqMedianFiringChannel_Hz = dataInOrder(ceil(0.5*length(dataInOrder)));
freqLQFiringChannel_Hz = dataInOrder(ceil(0.25*length(dataInOrder)));
freqMinFiringChannel_Hz = dataInOrder(1);

freqSTDBetweenChannels_Hz = std(nonzeros(freqPerChannel_Hz)); % STD between active channels

if nnz(freqPerChannel_Hz) == 0 % avoids a divide by 0 error in event that no spikes have been detected
    freqSEMBetweenChannels_Hz = 0;
else    
    freqSEMBetweenChannels_Hz = freqSTDBetweenChannels_Hz / sqrt(nnz(freqPerChannel_Hz)); % SEM of frequency between channels
end   


freqMean_Hz = mean(nonzeros(freqPerChannel_Hz), 'omitnan'); % frequency of whole sample by averaging every active channel
freqMedian_Hz = median(nonzeros(freqPerChannel_Hz), 'omitnan');
freqSTD_Hz = std(nonzeros(freqPerChannel_Hz), 'omitnan'); % STDev of the frequencies of all active channels

if nnz(freqPerChannel_Hz) == 0 % avoids divide by 0 error in event no spikes are detected
    freqSEM_Hz = 0;
else
    freqSEM_Hz = freqSTD_Hz / sqrt(nnz(freqPerChannel_Hz)); % SEM of the frequencies of all active channels
end


%% save as a struct
% saving data in a sub-struct as allows me to add more metrics without
% faffing about adding more function outputs

frequencyData.freqPerChannel_Hz = freqPerChannel_Hz;


frequencyData.freqMaxFiringChannel_Hz = freqMaxFiringChannel_Hz;
frequencyData.freqUQFiringChannel_Hz = freqUQFiringChannel_Hz;
frequencyData.freqMedianFiringChannel_Hz = freqMedianFiringChannel_Hz;
frequencyData.freqLQFiringChannel_Hz = freqLQFiringChannel_Hz;
frequencyData.freqMinFiringChannel_Hz = freqMinFiringChannel_Hz;

frequencyData.freqSTDBetweenChannels_Hz = freqSTDBetweenChannels_Hz;
frequencyData.freqSEMBetweenChannels_Hz = freqSEMBetweenChannels_Hz;

frequencyData.freqMean_Hz = freqMean_Hz;
frequencyData.freqMedian_Hz = freqMedian_Hz;
frequencyData.freqSTD_Hz = freqSTD_Hz;
frequencyData.freqSEM_Hz = freqSEM_Hz;



end
