function spikes = primaryofsubfield(spikes, file, CA1layers, fileName)
%% load final data and the spike matrix
datafiles = dir(strcat(fileName(1:11), '*', '_finalData_6.mat'));
finalData = load(datafiles.name);
finalData = finalData.finalData;

spikefiles = dir(strcat(fileName(1:11), '*', '_tSpikes_6.mat'));
spikeMatrix = load(spikefiles.name);
spikeMatrix = spikeMatrix.spikeMatrix;


%% get the average amplitude of all the spikes in each electrode

avgAmp = checkSameSpike(finalData, spikeMatrix);

topfield = [3 12 29 13 6 11 20 4 5 21 14 2 51 44 60 61 45 22 10 59 36 53 7];
topamps = avgAmp;
for i = 1:length(avgAmp)
    if nnz(i == topfield) == 0
        topamps(i) = 0;
    end
end
maxtopamp = find(topamps == max(topamps));




forceerror




