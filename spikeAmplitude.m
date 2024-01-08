function amp = spikeAmplitude(traces, channel, time, polairty) 
%%
% reads the spike amplitude from the array of traces


c = channel;
t = time;
toprow = find(traces(1,:) == c);
across = find(traces(2,toprow) == t);

if polarity == 1
    amp = max(traces(3:size(traces,1),across));
else
    amp = min(traces(3:size(traces,1),across));
end
   

