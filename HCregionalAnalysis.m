function HCregionalAnalysis(file, data, channels, finalData, thresholds)
% major overhaul - to be classed 



%% save for posterity
[slicepics, row] = rowForSlicepics(file);
    
    if row ~= 0
           
           DG.spikesTot = 0;
           if ~isempty(slicepics{row, 5}) 
                    
                    DGs = str2num(slicepics{row,5});    
                    [~, DG.spikesTot, DG.fullData, DG.midfiftyData, DG.stableData, DG.sixtyData, ~, DG.channels,~, DG.signalToNoise,DG.combinedSpikes, DG.energy, DG.ampdata] = tSpikeAnalysis_Tommy(data(:,DGs), channels(DGs), file);
           
           end

           CA3.spikesTot = 0;
           if ~isempty(slicepics{row, 6})
               CA3s = str2num(slicepics{row,6});
               [~, CA3.spikesTot, CA3.fullData, CA3.midfiftyData, CA3.stableData, CA3.sixtyData, ~, CA3.channels,~, CA3.signalToNoise, CA3.combinedSpikes, CA3.energy, CA3.ampdata] = tSpikeAnalysis_Tommy(data(:,CA3s), channels(CA3s), file);
           end

            CA1.spikesTot = 0;
            if ~isempty(slicepics{row, 7})
               CA1s = str2num(slicepics{row,7});
               [~, CA1.spikesTot, CA1.fullData, CA1.midfiftyData, CA1.stableData, CA1.sixtyData, ~, CA1.channels,~, CA1.signalToNoise, CA1.combinedSpikes, CA1.energy, CA1.ampdata] = tSpikeAnalysis_Tommy(data(:,CA1s), channels(CA1s), file);
            end

            CA1oriens.spikesTot = 0;
            if ~isempty(slicepics{row, 8})
               CA1orienss = str2num(slicepics{row,8});
               [~, CA1oriens.spikesTot, CA1oriens.fullData, CA1oriens.midfiftyData, CA1oriens.stableData, CA1oriens.sixtyData, ~, CA1oriens.channels,~, CA1oriens.signalToNoise, CA1oriens.combinedSpikes, CA1oriens.energy, CA1oriens.ampdata] = tSpikeAnalysis_Tommy(data(:,CA1orienss), channels(CA1orienss), file);
            end

            CA1pyramidale.spikesTot = 0;
            if ~isempty(slicepics{row, 9})
               CA1pyramidales = str2num(slicepics{row,9});
               [~, CA1pyramidale.spikesTot, CA1pyramidale.fullData, CA1pyramidale.midfiftyData, CA1pyramidale.stableData, CA1pyramidale.sixtyData, ~, CA1pyramidale.channels,~, CA1pyramidale.signalToNoise, CA1pyramidale.combinedSpikes, CA1pyramidale.energy, CA1pyramidale.ampdata] = tSpikeAnalysis_Tommy(data(:,CA1pyramidales), channels(CA1pyramidales), file);
            
            end
            
            CA1radiatum.spikesTot = 0;
             if ~isempty(slicepics{row, 10})
               CA1radiatums = str2num(slicepics{row,10});
               [~, CA1radiatum.spikesTot, CA1radiatum.fullData, CA1radiatum.midfiftyData, CA1radiatum.stableData, CA1radiatum.sixtyData, ~, CA1radiatum.channels,~, CA1radiatum.signalToNoise, CA1radiatum.combinedSpikes, CA1radiatum.energy, CA1radiatum.ampdata] = tSpikeAnalysis_Tommy(data(:,CA1radiatums), channels(CA1radiatums), file);
          
             end
                    
             CA1moleculare.spikesTot = 0;
             if ~isempty(slicepics{row, 11})
               CA1moleculares = str2num(slicepics{row,11});
               [~, CA1moleculare.spikesTot, CA1moleculare.fullData, CA1moleculare.midfiftyData, CA1moleculare.stableData, CA1moleculare.sixtyData, ~, CA1moleculare.channels,~, CA1moleculare.signalToNoise, CA1moleculare.combinedSpikes, CA1moleculare.energy, CA1moleculare.ampdata] = tSpikeAnalysis_Tommy(data(:,CA1moleculares), channels(CA1moleculares), file);
             
             end

             EC.spikesTot = 0;
             if ~isempty(slicepics{row, 12})
               ECs = str2num(slicepics{row,12});
               [~, EC.spikesTot, EC.fullData, EC.midfiftyData, EC.stableData, EC.sixtyData, ~, EC.channels,~, EC.signalToNoise, EC.combinedSpikes, EC.energy, EC.ampdata] = tSpikeAnalysis_Tommy(data(:,ECs), channels(ECs), file);
             end
   
             fileName = strcat(file.name(1:end-4), '_analysed_by_region', '.mat');
             cd("RecFiles\")
             save(fileName, 'DG', 'CA3', 'CA1', 'CA1oriens', 'CA1pyramidale', 'CA1radiatum', 'CA1moleculare', 'EC');
            cd ../
    else
        disp('no regional information in spreadsheet')
    end
   
    end 