function [spikeTrain] = removeRepetitiveEvent(spikeTrain, fs, remInt)

%% just a WIP but dont forget about me
% if other repetetitve events are found this can be modified for that too
% input is specified to train when function is called and does not need to
% be repeated here

for int = remInt % approx latency of the repetitive event but should hopefully be covered by new common average reference

        findSpikes = find(spikeTrain);
        findIntervals = zeros(1, length(findSpikes)-1);
    
        for j = 1:length(findSpikes)-1
            
            findIntervals(j) = findSpikes(j+1) - findSpikes(j);
        end
        
        findIntervals = round(findIntervals / int, 3); % do this to catch all multiple sof the latency too, for when intermediate events have been subthreshold

       for k = 1:length(findIntervals)-1
            

           if abs(findIntervals(k) - round(findIntervals(k))) < 0.05 &&  abs(findIntervals(k+1) - round(findIntervals(k+1))) < 0.05 % must be true for two in a row, will miss removing some but also reduce chance of removing random true spikes that happen to have right interval
              
              spikeTrain(findSpikes(k)) = 0;
              spikeTrain(findSpikes(k+1)) = 0; % sets the two 1s on spikeTrain to 1
           else
           end
       end   
    
end
