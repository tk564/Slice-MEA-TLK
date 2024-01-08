function [spikeinfo, movingSTD] = analyseTraces(traces, polarity)
%% extracts a bunch of information from the spike trace

num = size(traces, 2);
spikeinfo = zeros(num, 7); % change dim2 depending on how many things you want output
for i = 1:num

	channel = traces(1,i);
    spikeinfo(i,1) = channel;

	time = traces(2,i);
    spikeinfo(i,2) = time;

	trace = traces(3:size(traces,1),1);
	firstdiff = diff(trace);
    spikeinfo(i,3) = firstdiff;

	seconddiff = diff(firstdiff);
    spikeinfo(i,4) = secondfidd;

	thirddiff = diff(seconddiff);
    spikeinfo(i,5) = thirddiff;

	movingSTD = movstd(trace, 5); % work out what to do with this hmm

    spikeAmp = spikeAmpliture(traces, channel, time, polarity);
    spikeinfo(i,7) = spikeAmp;

end