function [spikesTot, fullData, midfiftyData, stableData, tSpikeConcurrents, concurrencyNetwork, energy, ampdata] = null_output

spikesTot = 0;
signalToNoise = 0;




%% full data
fullData.spikesTot_full = 0;
fullData.spikesPerChannel_full = zeros(1,64);
fullData.frequencyData_full.freqPerChannel_Hz = zeros(1,64);
fullData.frequencyData_full.freqMaxFiringChannel_Hz = 0;
fullData.frequencyData_full.freqUQFiringChannel_Hz = 0;
fullData.frequencyData_full.freqMedianFiringChannel_Hz = 0;
fullData.frequencyData_full.freqLQFiringChannel_Hz = 0;
fullData.frequencyData_full.freqMinFiringChannel_Hz = 0;
fullData.frequencyData_full.freqSTDBetweenChannels_Hz = 0;
fullData.frequencyData_full.freqSEMBetweenChannels_Hz = 0;
fullData.frequencyData_full.freqMean_Hz = 0;
fullData.frequencyData_full.freqMedian_Hz = 0;
fullData.frequencyData_full.freqSTD_Hz = 0;
fullData.frequencyData_full.freqSEM_Hz = 0;

fullData.spikeIntervalData_full.spikeIntervalMeanPerChannel_s = zeros(1,64);
fullData.spikeIntervalData_full.spikeIntervalSTDPerChannel_s = zeros(1,64);
fullData.spikeIntervalData_full.spikeIntervalSEMPerChannel_s = zeros(1,64);
fullData.spikeIntervalData_full.spikeIntervalSTDBetweenChannels_s = 0;
fullData.spikeIntervalData_full.spikeIntervalSEMBetweenChannels_s = 0;
fullData.spikeIntervalData_full.spikeIntervalMean_s = 0;
fullData.spikeIntervalData_full.spikeIntervalSTD_s = 0;
fullData.spikeIntervalData_full.spikeIntervalSEM_s = 0;

%% midfifty

midfiftyData.spikesTot_full = 0;
midfiftyData.spikesPerChannel_full = zeros(1,64);
midfiftyData.frequencyData_full.freqPerChannel_Hz = zeros(1,64);
midfiftyData.frequencyData_full.freqMaxFiringChannel_Hz = 0;
midfiftyData.frequencyData_full.freqUQFiringChannel_Hz = 0;
midfiftyData.frequencyData_full.freqMedianFiringChannel_Hz = 0;
midfiftyData.frequencyData_full.freqLQFiringChannel_Hz = 0;
midfiftyData.frequencyData_full.freqMinFiringChannel_Hz = 0;
midfiftyData.frequencyData_full.freqSTDBetweenChannels_Hz = 0;
midfiftyData.frequencyData_full.freqSEMBetweenChannels_Hz = 0;
midfiftyData.frequencyData_full.freqMean_Hz = 0;
midfiftyData.frequencyData_full.freqMedian_Hz = 0;
midfiftyData.frequencyData_full.freqSTD_Hz = 0;
midfiftyData.frequencyData_full.freqSEM_Hz = 0;

midfiftyData.spikeIntervalData_full.spikeIntervalMeanPerChannel_s = zeros(1,64);
midfiftyData.spikeIntervalData_full.spikeIntervalSTDPerChannel_s = zeros(1,64);
midfiftyData.spikeIntervalData_full.spikeIntervalSEMPerChannel_s = zeros(1,64);
midfiftyData.spikeIntervalData_full.spikeIntervalSTDBetweenChannels_s = 0;
midfiftyData.spikeIntervalData_full.spikeIntervalSEMBetweenChannels_s = 0;
midfiftyData.spikeIntervalData_full.spikeIntervalMean_s = 0;
midfiftyData.spikeIntervalData_full.spikeIntervalSTD_s = 0;
midfiftyData.spikeIntervalData_full.spikeIntervalSEM_s = 0;

%% stable data
stableData.spikesTot_stable = 0;
stableData.spikesPerChannel_stable = zeros(1,64);
stableData.frequencyData_stable.freqPerChannel_Hz = zeros(1,64);
stableData.frequencyData_stable.freqMaxFiringChannel_Hz = 0;
stableData.frequencyData_stable.freqUQFiringChannel_Hz = 0;
stableData.frequencyData_stable.freqMedianFiringChannel_Hz = 0;
stableData.frequencyData_stable.freqLQFiringChannel_Hz = 0;
stableData.frequencyData_stable.freqMinFiringChannel_Hz = 0;
stableData.frequencyData_stable.freqSTDBetweenChannels_Hz = 0;
stableData.frequencyData_stable.freqSEMBetweenChannels_Hz = 0;
stableData.frequencyData_stable.freqMean_Hz = 0;
stableData.frequencyData_stable.freqMedian_Hz = 0;
stableData.frequencyData_stable.freqSTD_Hz = 0;
stableData.frequencyData_stable.freqSEM_Hz = 0;

stableData.spikeIntervalData_stable.spikeIntervalMeanPerChannel_s = zeros(1,64);
stableData.spikeIntervalData_stable.spikeIntervalSTDPerChannel_s = zeros(1,64);
stableData.spikeIntervalData_stable.spikeIntervalSEMPerChannel_s = zeros(1,64);
stableData.spikeIntervalData_stable.spikeIntervalSTDBetweenChannels_s = 0;
stableData.spikeIntervalData_stable.spikeIntervalSEMBetweenChannels_s = 0;
stableData.spikeIntervalData_stable.spikeIntervalMean_s = 0;
stableData.spikeIntervalData_stable.spikeIntervalSTD_s = 0;
stableData.spikeIntervalData_stable.spikeIntervalSEM_s = 0;

%% highest 60 data
sixtyData.spikesTot_sixty = 0;
sixtyData.spikesPerChannel_sixty = zeros(1,64);
sixtyData.frequencyData_sixty.freqPerChannel_Hz = zeros(1,64);
sixtyData.frequencyData_sixty.freqMaxFiringChannel_Hz = 0;
sixtyData.frequencyData_sixty.freqUQFiringChannel_Hz = 0;
sixtyData.frequencyData_sixty.freqMedianFiringChannel_Hz = 0;
sixtyData.frequencyData_sixty.freqLQFiringChannel_Hz = 0;
sixtyData.frequencyData_sixty.freqMinFiringChannel_Hz = 0;
sixtyData.frequencyData_sixty.freqSTDBetweenChannels_Hz = 0;
sixtyData.frequencyData_sixty.freqSEMBetweenChannels_Hz = 0;
sixtyData.frequencyData_sixty.freqMean_Hz = 0;
sixtyData.frequencyData_sixty.freqMedian_Hz = 0;
sixtyData.frequencyData_sixty.freqSTD_Hz = 0;
sixtyData.frequencyData_sixty.freqSEM_Hz = 0;

sixtyData.spikeIntervalData_sixty.spikeIntervalMeanPerChannel_s = zeros(1,64);
sixtyData.spikeIntervalData_sixty.spikeIntervalSTDPerChannel_s = zeros(1,64);
sixtyData.spikeIntervalData_sixty.spikeIntervalSEMPerChannel_s = zeros(1,64);
sixtyData.spikeIntervalData_sixty.spikeIntervalSTDBetweenChannels_s = 0;
sixtyData.spikeIntervalData_sixty.spikeIntervalSEMBetweenChannels_s = 0;
sixtyData.spikeIntervalData_sixty.spikeIntervalMean_s = 0;
sixtyData.spikeIntervalData_sixty.spikeIntervalSTD_s = 0;
sixtyData.spikeIntervalData_sixty.spikeIntervalSEM_s = 0;




tSpikeConcurrents = 0; % these are just placeholders so it keeps working for now, might need to change
concurrencyNetwork = 0;


energy.energyMean = 0;
energy.energyMean2 = 0;
energy.energyMean3 = 0;

ampdata.ampMean = 0;
ampdata.ampMax = 0;
ampdata.ampUQ = 0;
ampdata.ampMedian = 0;
ampdata.ampLQ = 0;
ampdata.ampMin = 0;

ampdata.ampSTD = 0;
ampdata.ampSEM = 0;
end
