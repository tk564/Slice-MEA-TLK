function burstMatrix = bakkumBurstDetect(spikeTrain, fs, N, minChannel) 
    %script from: https://github.com/Timothysit/mecp2
    % edited by Alex Dunn: August 2019
    % modified for IIS by Tommy Kelly 20220323 to serve a single spike
    % train
        
 
    allSpikeTime = find(spikeTrain); % gets times of all spikes
    Spike.T = allSpikeTime / fs; % times of all spikes in seconds   
    SpikeTime = Spike.T;
    
    % 'Spike' is a structure with members: 
    % Spike.T Vector of spike times [sec] 
    % Spike.C (optional) Vector of spike channels 
        % I assume this is the channel causing the spike for that bin 
        % I think it must be just one value, therefore won't accept
        % conincident spike (although they are quite rare I think).
    % 
    % 'N' spikes within 'ISI_N' [seconds] satisfies the burst criteria
    
    % N = 20; % N is the critical paramter here, 
    % ISI_N can be automatically selected (and this is dependent on N)
    Steps = 10.^[-5:0.05:1.5]; 
    Steps = Steps*100; % the ISIs are ~100x timescale of single unit
    % exact values of this doens't matter as long as its log scale, covers 
    % the possible spikeISI times,(but we don't care about values about
    % 0.1s anyway)
    plotFig = 0;
  %  ISInTh = getISInTh(Spike.T, N, Steps, plotFig);
  % Tommy: making my own one because the above gave me a headache

  ISIs = zeros(1,size(SpikeTime,1)-1);
  for i = 2:size(SpikeTime)
      ISIs(i-1) = SpikeTime(i) - SpikeTime(i-1);
  end
    
  ISIs = ISIs(2:length(ISIs));
%   m = mean(ISIs);
%   s = std(ISIs);
%   thresh = m - 1.5*s;
%   movavg = movmean(ISIs,10);
%   
%   faster = movavg < thresh;



warning('off');
   n = histc(ISIs, Steps); 
   n = movmean(n,3);
  % breaks for some recordings... can we go without smoothing?
   % n = fLOESS(n, 16/round(length(n))); % used by Sit 2018
    warning('on');
    % the fraction of data used is not specified in the paper 
    % so I will just make a guess (using the minimum value allowed).

%      if plotFig == 1 
%         plot(Steps * 1000, n/sum(n), '.-', 'color', map(cnt, :))
%     end 
%   
curve = n/sum(n);

[pks,locs] = findpeaks(curve, 'minpeakdistance', 2); 
%%
if length(pks) <= 1 
    % no peak or one peak, return default ISIn threshold value 
    ISInTh = 0.1; % in seconds, ie. 100ms (See Pasquale et al 2010) 
                  % actually also default value used in Bakkum et al 2014 
elseif length(pks) >= 2               
    % note that this entertains two conditions, peak == 2, in which case we get the
    % minimum value between those two peaks, and where peak > 2, in which
    % case we get the mimum value between the first two peaks (from
    % smallest to largest), in terms of x-axis values 
%     peakOne = locs(1); 
%     peakTwo = locs(2); 
%     
%     valleyPoint = find(curve == min(curve(peakOne:peakTwo))); 
%     % this will find the first minimum, if there are multiples 
%     
%     ISInTh = valleyPoint / 1000; % convert ms back to seconds
    pks = pks(1);
    
end 
ISInTh = pks*100;

% convert N to be TIME based...
% looking for 10s based on some of the clinical literature

%% JK FORGET ALL THAT BEFORE DO IT THIS WAY ITS MUCH COOLER
% check = zeros(1,50);
% backs = check;
% for i = 1:50
%     ISInTh = i;
    [Burst SpikeBurstNumber] = BurstDetectISIn(Spike, 10, ISInTh); 
%     check(i) = sum( SpikeBurstNumber(SpikeBurstNumber > 0));
%     try
%     check(i) = Burst.T_start(1);
%     backs(i) = Burst.T_end(1);
%     catch
%         check(i) = 0;
%     end
% end   
% 
% if check == 0
%     burstMatrix = zeros(size(spikeTrain));
% else
%     differential = diff(check); % see sudden changes in where first 'ictal period' being detected
%     changes = abs(differential); % could be either sudden increase or decrease (realistically decrease)
%     [peaks pos] = findpeaks(changes,1,'MinPeakDistance',9); % justify as min length of 10-1? smth like that
%     chosenThresh = (pos(1) + pos(2))/2;
% 
%      [Burst SpikeBurstNumber] = BurstDetectISIn(Spike, 10, chosenThresh); 
% 
%      for i = 1:length(Burst.T_start)
%         burstMatrix(floor(Burst.T_start(i)):ceil(Burst.T_end(i))) = 1; % sets the period to be defined as a burst
%      end
% end

%%

    
    % Burst.T_start Burst start time [sec] 
    % Burst.T_end Burst end time [sec] 
    % Burst.S Burst size (number of spikes) 
    % Burst.C Burst size (number of channels) 
    
    % burstMatrix = Burst;
    
    
    % now, covert it to a cell structure, where each cell contain a matrix 
    % with the spike trains during a burst period 
    burstCell = cell(length(Burst.S), 1);
    
    
    
    for bb = 1:length(Burst.S)
        T_start_frame = round(Burst.T_start(bb) * fs); % convert from s back to frame 
        T_end_frame = round(Burst.T_end(bb) * fs); 
        burstCell{bb} = spikeMatrix(T_start_frame:T_end_frame, :);
    end 
 
end 
