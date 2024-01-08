function [upvdownstrokeRemovals, spikeMatrixFT] = upstrokevdownstroke_Tommy(spikeMatrixFT, fs, filteredData, metadata)
upvdownstrokeRemovals = [0, 0, 0, 0];


for i = 1:64

    spikestocheck = find(spikeMatrixFT(fs/2:length(spikeMatrixFT)-fs/2,i))+fs/2;

    for j = 1:length(spikestocheck)

        tracetocheck = filteredData(spikestocheck(j)-fs/2:spikestocheck(j)+fs/2, i);
        %tracetocheck = diff(tracetocheck);
        tracelength = length(tracetocheck);

        if metadata.polarity == 1

            upstrokelength = find( flip(tracetocheck(1:(tracelength+1)/2) < mean(tracetocheck)), 1, 'first');
            downstrokelength = find( tracetocheck((tracelength+1)/2:tracelength) == min(tracetocheck((tracelength+1)/2:tracelength) ));

        else 
           upstrokelength = find( flip(tracetocheck(1:(tracelength+1)/2) > mean(tracetocheck)), 1, 'first');
            downstrokelength = find( tracetocheck((tracelength+1)/2:tracelength) == max(tracetocheck((tracelength+1)/2:tracelength) ));

        end

        if upstrokelength > downstrokelength
                spikeMatrixFT(spikestocheck(j),i) = 0;
                upvdownstrokeRemovals = [upvdownstrokeRemovals; i spikestocheck(j) upstrokelength downstrokelength];
        end

    end
end
end