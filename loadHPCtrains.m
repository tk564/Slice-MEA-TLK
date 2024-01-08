function [spikefile, spikeMatrix, channels, HPCelectrodes] = loadHPCtrains(file)

file = char(file);
ref = file(1:11);


goback = cd;
cd .\RecFiles

spikefile = dir(strcat(ref, '*', 'spikes_6.mat'));
spikefile = spikefile(~contains({spikefile.name}, 'su'));

spikeMatrix = load(spikefile.name);
spikeMatrix = spikeMatrix.spikeMatrix;

cd(goback)

channels = size(spikeMatrix,2);


HPCelectrodes = getHPCelectrodes(spikefile);
for i = 1:size(spikeMatrix,2)
    if nnz(spikeMatrix(:,i)) < 20
        spikeMatrix(:,i) = 0;
    end
    if nnz(i == HPCelectrodes) == 0
        spikeMatrix(:,i) = 0;
    end
end
end