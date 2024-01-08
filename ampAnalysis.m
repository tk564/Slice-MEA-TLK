function ampdata = ampAnalysis(data,traces)

empty = zeros(1,size(data,2));

ampMean = empty;
ampMax = empty;
ampUQ = empty;
ampMedian = empty;
ampLQ = empty;
ampMin = empty;

ampSTD = empty;
ampSEM = empty;


for i = 1:size(data,2)
    if nnz(data(:,i) > 0) && nnz(traces(1,:) == i) > 0
    chan = i;
    [ampMean(i), ampMax(i), ampUQ(i), ampMedian(i), ampLQ(i), ampMin(i), ampSTD(i), ampSEM(i)] = ampPerchannel(data(:,i), traces, chan);
    end
end

ampdata.ampMean = mean(nonzeros(ampMean));
ampdata.ampMax = max(nonzeros(ampMax));
ampdata.ampUQ = mean(nonzeros(ampUQ));
ampdata.ampUQ = mean(nonzeros(ampMedian));
ampdata.ampLQ = mean(nonzeros(ampLQ));
ampdata.ampMin = min(nonzeros(ampMin));
ampdata.ampSTD = mean(nonzeros(ampSTD));
ampdata.ampSEM = mean(nonzeros(ampSEM));

