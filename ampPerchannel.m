function  [meanA, maxA, UQA, medianA, LQA, minA,stdA, semA] = ampPerchannel(data, traces, chan)


L = size(traces,1);
n_spikes = nnz(data);
allamps = zeros(1,n_spikes);
k = 0;

for i = 1:size(traces,2)

    if traces(1,i) == chan
        k = k+1;

        allamps(k) = max(traces(3:L,i));

    end
end

allamps = nonzeros(allamps); % should be unecessary but just in case

meanA = mean(allamps);
maxA = max(allamps);
UQA = quantile(allamps,0.75);
medianA = quantile(allamps,0.5);
LQA = quantile(allamps,0.25);
minA = min(allamps);
stdA = std(allamps);
semA = stdA / sqrt(length(allamps));






