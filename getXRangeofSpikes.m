function [rangeMatrix] = getXRangeofSpikes(data, minNth, maxNth)
%%

for i = 1:size(data,2) % so can handle one channel at a time if desired

    if nnz(data(:,i)) > 2 % must have at least 2 values to proceed I believe
        spikesInChannel = nnz(data(:,i));
        firstPosition = floor(minNth/100*spikesInChannel); % number of minNth numbered spike 

        if firstPosition == 0
            firstPosition = 1; % catch in case rounds to 0 and breaks
        end
        
        lastPosition = ceil(maxNth/100*spikesInChannel); % number of maxNth percentile spike

        allSpikes = find(data(:,i));

        firstSpike = allSpikes(firstPosition);
        lastSpike = allSpikes(lastPosition);

        rangeMatrix = data(firstSpike:lastSpike-1,i); % selects just the cental 50% of spikes detected, is sfS-1 rather than sfS so that as has included latter half of first spike only includes the firts half of second spike before the spike actually detected thus not viasing the results so much
    
    else
        
        rangeMatrix = data(:,i); % for channels where <2 so cant get a middle 50% it just keeps the same number as before

    end
    
end

end
