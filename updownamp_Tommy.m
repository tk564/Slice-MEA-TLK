function [updownampRemovals, spikeMatrixFT] = updownamp_Tommy(spikeMatrixFT, fs, filteredData, metadata, polarity)

updownampRemovals = [0, 0, 0, 0];



for i = 1:size(spikeMatrixFT,2)

    spikestocheck = find(spikeMatrixFT(fs*5:length(spikeMatrixFT)-fs*5,i))+fs*5; % 5s not analysed at each end to allow for the local means, sometimes gotta break some eggs

    for j = 1:length(spikestocheck)

        tracetocheck = filteredData(spikestocheck(j)-fs/2:spikestocheck(j)+fs/2, i);
        %tracetocheck = diff(tracetocheck);
        tracelength = length(tracetocheck);
	midpoint = (tracelength+1)/2;

        if polarity == 1

            upstrokeamp = max( tracetocheck( round(midpoint-fs/8):round(midpoint+fs/8)));
            downstrokeamp = min(tracetocheck(midpoint:length(tracetocheck)));

        else 
           upstrokeamp = min(tracetocheck(round(midpoint-15):round(midpoint+15)));
            downstrokeamp = max(tracetocheck(midpoint:length(tracetocheck)));
        end

     %% compare the amplitudes

        if upstrokeamp < downstrokeamp
                spikeMatrixFT(spikestocheck(j),i) = 0;
                updownampRemovals = [updownampRemovals; i spikestocheck(j) upstrokeamp downstrokeamp];
        end
    %% check is above amplitude of intrinsic noise
        if polarity == 1 % only do for the multiunit analysis
         thresh = 0.01; %mean(filteredData(spikestocheck(j)-5*fs:spikestocheck(j)+5*fs,i))+2*std(filteredData(spikestocheck(j)-5*fs:spikestocheck(j)+5*fs,i)) % must be 2STD above the local mean+2std, so in a noisier bit of recording a higher threshold is set, but without a noisy period influencing other periods!            
         if abs(upstrokeamp) < thresh
                spikeMatrixFT(spikestocheck(j),i) = 0;
                updownampRemovals = [updownampRemovals; i spikestocheck(j) upstrokeamp downstrokeamp];
         end
        end

    end
end
end