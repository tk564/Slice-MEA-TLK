function output = wholeSliceOutput(file, data, output)

 output(file).signalToNoise = data.signalToNoise;

    %% full data ouptut
   
        output(file).spikesTot_full = data.fullData.spikesTot_full;
    
        %output(file).spikesPerChannel_full = num2str(data.fullData.spikesPerChannel_full);
        
        %output(file).freqPerChannel_Hz_full = num2str(data.fullData.frequencyData.freqPerChannel_Hz);
        try
        reference = output(file).recording(1:11);    
        hubfile = dir(strcat(reference,'*','hub_stuff.mat'));
        if length(hubfile) > 1
            hubfile = hubfile(end);
        end
        hubs = load(hubfile.name);
        h = hubs.h;
        
        output(file).meanConnectivity = h.meanConnectivity;
        output(file).maxConnectivity = h.maxConnectivity;
        output(file).maxConnectivity_electrode = h.maxConnectivity_electrode;
        output(file).maxConnectivity_region = h.maxConnectivity_region;
        output(file).STDConnectivity = h.STDConnectivity;
        output(file).connectivityDG = h.connectivity_per_region(1);
        output(file).connectivityCA3 = h.connectivity_per_region(2);
        output(file).connectivityCA1 = h.connectivity_per_region(3);
        output(file).connectivityEC = h.connectivity_per_region(4);



        output(file).meanControl = h.meanControl;
        output(file).maxControl = h.maxControl;
        output(file).maxControl_electrode = h.maxControl_electrode;
        output(file).maxControl_region = h.maxControl_region;
        output(file).STDControl = h.STDControl;
         output(file).controlDG = h.control_per_region(1);
        output(file).controlCA3 = h.control_per_region(2);
        output(file).controlCA1 = h.control_per_region(3);
        output(file).controlEC = h.control_per_region(4);

        % mean, std, and maxprimary dont mean anything
        output(file).maxPrimary_electrode = h.maxPrimary_electrode;
        output(file).maxPrimary_region = h.maxPrimary_region;
        
        catch
            disp('no hub stuff')
        end

        



        try
        output(file).energyMean = data.energy.energyMean;
        output(file).energyMean2 = data.energy.energyMean2;
        output(file).energyMean3 = data.energy.energyMean3;
     

        output(file).ampMean = data.ampdata.ampMean;
        output(file).ampMax = data.ampdata.ampMax;
        output(file).ampUQ = data.ampdata.ampUQ;
%         output(file).ampMedian = data.ampdata.ampMedian;
        output(file).ampLQ = data.ampdata.ampLQ;
        output(file).ampMin = data.ampdata.ampMin;
        output(file).ampSTD = data.ampdata.ampSTD;
        output(file).ampSEM = data.ampdata.ampSEM;

        catch
            output(file).energyMean = 0;
        output(file).energyMean2 = 0;
        output(file).energyMean3 = 0;
     

        output(file).ampMean =0;
        output(file).ampMax = 0;
        output(file).ampUQ = 0;
%         output(file).ampMedian = 0;
        output(file).ampLQ = 0;
        output(file).ampMin = 0;
        output(file).ampSTD = 0;
        output(file).ampSEM = 0;
        end
       
    
        output(file).freqMean_Hz_full = data.fullData.frequencyData_full.freqMean_Hz;
        output(file).freqSTD_Hz_full = data.fullData.frequencyData_full.freqSTD_Hz;
        output(file).freqSEM_Hz_full = data.fullData.frequencyData_full.freqSEM_Hz;
        
        output(file).freqMaxFiringChannel_Hz_full = data.fullData.frequencyData_full.freqMaxFiringChannel_Hz;
        output(file).freqUQFiringChannel_Hz_full = data.fullData.frequencyData_full.freqUQFiringChannel_Hz;
        output(file).freqMedianFiringChannel_Hz_full = data.fullData.frequencyData_full.freqMedianFiringChannel_Hz;
        output(file).freqLQFiringChannel_Hz_full = data.fullData.frequencyData_full.freqLQFiringChannel_Hz;
        output(file).freqMinFiringChannel_Hz_full = data.fullData.frequencyData_full.freqMinFiringChannel_Hz;
    
        output(file).freqSTDBetweenChannels_Hz_full = data.fullData.frequencyData_full.freqSTDBetweenChannels_Hz;
        output(file).freqSEMBetweenChannels_Hz_full = data.fullData.frequencyData_full.freqSEMBetweenChannels_Hz;
    
        %output(file).spikeIntervalMeanPerChannel_s_full = num2str(data.fullData.spikeIntervalData_full.spikeIntervalMeanPerChannel_s);
        %output(file).spikeIntervalSTDPerChannel_s_full = num2str(data.fullData.spikeIntervalData_full.spikeIntervalSTDPerChannel_s);
        %output(file).spikeIntervalSEMPerChannel_s_full = num2str(data.fullData.spikeIntervalData_full.spikeIntervalSEMPerChannel_s);
        
        output(file).spikeIntervalMean_s_full = data.fullData.spikeIntervalData_full.spikeIntervalMean_s;
        output(file).spikeIntervalSTD_s_full = data.fullData.spikeIntervalData_full.spikeIntervalSTD_s;
        output(file).spikeIntervalSEM_s_full = data.fullData.spikeIntervalData_full.spikeIntervalSEM_s;
    
        output(file).spikeIntervalSTDBetweenChannels_s_full = data.fullData.spikeIntervalData_full.spikeIntervalSTDBetweenChannels_s;    
        output(file).spikeIntervalSEMBetweenChannels_s_full = data.fullData.spikeIntervalData_full.spikeIntervalSEMBetweenChannels_s;
    

    %% active data output
    output(file).spikesTot_active = data.interictalData.spikesTot_full;

    %output(file).spikesPerChannel_active = num2str(data.full.spikesPerChannel_active);

    %output(file).freqPerChannel_Hz_active = num2str(data.full.frequencyData.freqPerChannel_Hz_active);

    output(file).freqMean_Hz_active = data.interictalData.frequencyData_full.freqMean_Hz;
    output(file).freqSTD_Hz_active = data.interictalData.frequencyData_full.freqSTD_Hz;
    output(file).freqSEM_Hz_active = data.interictalData.frequencyData_full.freqSEM_Hz;
    
    output(file).freqMaxFiringChannel_Hz_active = data.interictalData.frequencyData_full.freqMaxFiringChannel_Hz;
    output(file).freqUQFiringChannel_Hz_active = data.interictalData.frequencyData_full.freqUQFiringChannel_Hz;
    output(file).freqMedianFiringChannel_Hz_active = data.interictalData.frequencyData_full.freqMedianFiringChannel_Hz;
    output(file).freqLQFiringChannel_Hz_active = data.interictalData.frequencyData_full.freqLQFiringChannel_Hz;
    output(file).freqMinFiringChannel_Hz_active = data.interictalData.frequencyData_full.freqMinFiringChannel_Hz;

    output(file).freqSTDBetweenChannels_Hz_active = data.interictalData.frequencyData_full.freqSTDBetweenChannels_Hz;
    output(file).freqSEMBetweenChannels_Hz_active = data.interictalData.frequencyData_full.freqSEMBetweenChannels_Hz;

    %output(file).spikeIntervalMeanPerChannel_s_active = num2str(data.interictalData.spikeIntervalData_full.spikeIntervalMeanPerChannel_s);
    %output(file).spikeIntervalSTDPerChannel_s_active = num2str(data.interictalData.spikeIntervalData_full.spikeIntervalSTDPerChannel_s);
    %output(file).spikeIntervalSEMPerChannel_s_midfufty = num2str(data.interictalData.spikeIntervalData_full.spikeIntervalSEMPerChannel_s);
    
    output(file).spikeIntervalMean_s_active = data.interictalData.spikeIntervalData_full.spikeIntervalMean_s;
    output(file).spikeIntervalSTD_s_midfufty = data.interictalData.spikeIntervalData_full.spikeIntervalSTD_s;
    output(file).spikeIntervalSEM_s_midfufty = data.interictalData.spikeIntervalData_full.spikeIntervalSEM_s;

    output(file).spikeIntervalSTDBetweenChannels_s_active = data.interictalData.spikeIntervalData_full.spikeIntervalSTDBetweenChannels_s;    
    output(file).spikeIntervalSEMBetweenChannels_s_active = data.interictalData.spikeIntervalData_full.spikeIntervalSEMBetweenChannels_s;

%     %% stable period
% 
%     output(file).spikesTot_stable = data.stableData.spikesTot_stable;
% 
%     %output(file).spikesPerChannel_stable = num2str(data.stableData.spikesPerChannel_stable);
% 
%     %output(file).freqPerChannel_Hz_stable = num2str(data.stableData.frequencyData_stable.freqPerChannel_Hz_stable);
% 
%     output(file).freqMean_Hz_stable = data.stableData.frequencyData_stable.freqMean_Hz;
%     output(file).freqSTD_Hz_stable = data.stableData.frequencyData_stable.freqSTD_Hz;
%     output(file).freqSEM_Hz_stable = data.stableData.frequencyData_stable.freqSEM_Hz;
%     
%     output(file).freqMaxFiringChannel_Hz_stable = data.stableData.frequencyData_stable.freqMaxFiringChannel_Hz;
%     output(file).freqUQFiringChannel_Hz_stable = data.stableData.frequencyData_stable.freqUQFiringChannel_Hz;
%     output(file).freqMedianFiringChannel_Hz_stable = data.stableData.frequencyData_stable.freqMedianFiringChannel_Hz;
%     output(file).freqLQFiringChannel_Hz_stable = data.stableData.frequencyData_stable.freqLQFiringChannel_Hz;
%     output(file).freqMinFiringChannel_Hz_stable = data.stableData.frequencyData_stable.freqMinFiringChannel_Hz;
% 
%     output(file).freqSTDBetweenChannels_Hz_stable = data.stableData.frequencyData_stable.freqSTDBetweenChannels_Hz;
%     output(file).freqSEMBetweenChannels_Hz_stable = data.stableData.frequencyData_stable.freqSEMBetweenChannels_Hz;
% 
%     %output(file).spikeIntervalMeanPerChannel_s_stable = num2str(data.stableData.spikeIntervalData_stable.spikeIntervalMeanPerChannel_s);
%     %output(file).spikeIntervalSTDPerChannel_s_stable = num2str(data.stableData.spikeIntervalData_stable.spikeIntervalSTDPerChannel_s);
%     %output(file).spikeIntervalSEMPerChannel_s_stable = num2str(data.stableData.spikeIntervalData_stable.spikeIntervalSEMPerChannel_s);
%     
%     output(file).spikeIntervalMean_s_stable = data.stableData.spikeIntervalData_stable.spikeIntervalMean_s;
%     output(file).spikeIntervalSTD_s_stable = data.stableData.spikeIntervalData_stable.spikeIntervalSTD_s;
%     output(file).spikeIntervalSEM_s_stable = data.stableData.spikeIntervalData_stable.spikeIntervalSEM_s;
% 
%     outout(file).spikeIntervalSTDBetweenChannels_s_stable = data.stableData.spikeIntervalData_stable.spikeIntervalSTDBetweenChannels_s;    
%     output(file).spikeIntervalSEMBetweenChannels_s_stable = data.stableData.spikeIntervalData_stable.spikeIntervalSEMBetweenChannels_s;
%     
% 
%     %% highest spiking 60s
% 
%     output(file).spikesTot_sixty = data.sixtyData.spikesTot_sixty;
%     
%         %output(file).spikesPerChannel_sixty = num2str(data.sixtyData.spikesPerChannel_sixty);
%         
%         %output(file).freqPerChannel_Hz_sixty = num2str(data.sixtyData.frequencyData.freqPerChannel_Hz);
%     
%         output(file).freqMean_Hz_sixty = data.sixtyData.frequencyData_sixty.freqMean_Hz;
%         output(file).freqSTD_Hz_sixty = data.sixtyData.frequencyData_sixty.freqSTD_Hz;
%         output(file).freqSEM_Hz_sixty = data.sixtyData.frequencyData_sixty.freqSEM_Hz;
%         
%         output(file).freqMaxFiringChannel_Hz_sixty = data.sixtyData.frequencyData_sixty.freqMaxFiringChannel_Hz;
%         output(file).freqUQFiringChannel_Hz_sixty = data.sixtyData.frequencyData_sixty.freqUQFiringChannel_Hz;
%         output(file).freqMedianFiringChannel_Hz_sixty = data.sixtyData.frequencyData_sixty.freqMedianFiringChannel_Hz;
%         output(file).freqLQFiringChannel_Hz_sixty = data.sixtyData.frequencyData_sixty.freqLQFiringChannel_Hz;
%         output(file).freqMinFiringChannel_Hz_sixty = data.sixtyData.frequencyData_sixty.freqMinFiringChannel_Hz;
%     
%         output(file).freqSTDBetweenChannels_Hz_sixty = data.sixtyData.frequencyData_sixty.freqSTDBetweenChannels_Hz;
%         output(file).freqSEMBetweenChannels_Hz_sixty = data.sixtyData.frequencyData_sixty.freqSEMBetweenChannels_Hz;
%     
%         %output(file).spikeIntervalMeanPerChannel_s_full = num2str(data.fullData.spikeIntervalData_full.spikeIntervalMeanPerChannel_s);
%         %output(file).spikeIntervalSTDPerChannel_s_full = num2str(data.fullData.spikeIntervalData_full.spikeIntervalSTDPerChannel_s);
%         %output(file).spikeIntervalSEMPerChannel_s_full = num2str(data.fullData.spikeIntervalData_full.spikeIntervalSEMPerChannel_s);
%         
%         output(file).spikeIntervalMean_s_sixty = data.sixtyData.spikeIntervalData_sixty.spikeIntervalMean_s;
%         output(file).spikeIntervalSTD_s_sixty = data.sixtyData.spikeIntervalData_sixty.spikeIntervalSTD_s;
%         output(file).spikeIntervalSEM_s_sixty = data.sixtyData.spikeIntervalData_sixty.spikeIntervalSEM_s;
%     
%         output(file).spikeIntervalSTDBetweenChannels_s_sixty = data.sixtyData.spikeIntervalData_sixty.spikeIntervalSTDBetweenChannels_s;    
%         output(file).spikeIntervalSEMBetweenChannels_s_sixty = data.sixtyData.spikeIntervalData_sixty.spikeIntervalSEMBetweenChannels_s;
%     