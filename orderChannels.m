function [morph,transformations] = orderChannels(channels, group, spikeMatrix, null, morph,transformations)

for i = 1:channels
                   if nnz(i == group) == 1
                       column = spikeMatrix(:,i); % gets column of data for channel
                       morph = [morph, column]; % adds column of data on sequentially in order
                       newpos = size(morph,2)-1; 
                        transformations(2,i) = newpos;
                        
                   end
                   
              
end
%morph = [morph, null]; % adds a breaker between each group of electrodes so can separate them out later#
% silence for now as breaks the channel labelling

