function traces = getAllTraces(fs, spikeMatrixFT, filteredData, metadata)

tempL = size(metadata.refinedSpikeTemplate,1)-1;

traces = zeros(tempL+3,nnz(spikeMatrixFT));
nValue = 1;
for i = 1:64 % does each channel

    for j = tempL/2+1:size(spikeMatrixFT, 1)-(tempL/2+1) % cant get trace if at either of the extreme ends, shouldbt be a problem as better set earlier but just in case

        if spikeMatrixFT(j,i) == 1
            trace = filteredData(j-tempL/2:j+tempL/2, i);
            traceadd = [i; j; trace]; % at top is the channel, below the position, and then the trace itself
            
            traces(:,nValue) = traceadd;
            nValue = nValue+1;
        end
    end
end

if nnz(traces) > 0 % only removes if there are actual traces there, otherwise might cause an error
traces(:,1) = []; % removes the run of 0s at the start
end

end