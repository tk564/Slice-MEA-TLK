function output = regionalOutput(file, recording, output, folder)

cd(folder)
cd .\RecFiles\

filename = strcat( recording(1:11), '*', 'analysed_by_region.mat');
rFile = dir(filename);
rFile = rFile(~contains({rFile.name}, 'su'));

if length(rFile) > 0
    load(rFile.name);

    cd(folder)

    if CA1.spikesTot > 0
        output = CA1Output(file, CA1, output);
    else
        [CA1.spikesTot, CA1.fullData, CA1.midfiftyData, CA1.stableData, CA1.sixtyData, CA1.tSpikeConcurrents, CA1.concurrencyNetwork] = null_output;
        output = CA1Output(file, CA1, output);
    end

    if CA1moleculare.spikesTot > 0
        output = CA1moleculareOutput(file, CA1moleculare, output);
    else
        [CA1moleculare.spikesTot, CA1moleculare.fullData, CA1moleculare.midfiftyData, CA1moleculare.stableData, CA1moleculare.sixtyData, CA1moleculare.tSpikeConcurrents, CA1moleculare.concurrencyNetwork] = null_output;
        output = CA1moleculareOutput(file, CA1moleculare, output);
    end

    if CA1oriens.spikesTot > 0
        output = CA1oriensOutput(file, CA1oriens, output);
    else
        [CA1oriens.spikesTot, CA1oriens.fullData, CA1oriens.midfiftyData, CA1oriens.stableData, CA1oriens.sixtyData, CA1oriens.tSpikeConcurrents, CA1oriens.concurrencyNetwork] = null_output;
        output = CA1oriensOutput(file, CA1oriens, output);
    end

    if CA1pyramidale.spikesTot > 0
        output = CA1pyramidaleOutput(file, CA1pyramidale, output);
    else
        [CA1pyramidale.spikesTot, CA1pyramidale.fullData, CA1pyramidale.midfiftyData, CA1pyramidale.stableData, CA1pyramidale.sixtyData, CA1pyramidale.tSpikeConcurrents, CA1pyramidale.concurrencyNetwork] = null_output;
        output = CA1pyramidaleOutput(file, CA1oriens, output);
    end

    if CA1radiatum.spikesTot > 0
        output = CA1radiatumOutput(file, CA1radiatum, output);
    else
        [CA1radiatum.spikesTot, CA1radiatum.fullData, CA1radiatum.midfiftyData, CA1radiatum.stableData, CA1radiatum.sixtyData, CA1radiatum.tSpikeConcurrents, CA1radiatum.concurrencyNetwork] = null_output;
        output = CA1radiatumOutput(file, CA1oriens, output);
    end

    if CA3.spikesTot > 0
        output = CA3Output(file, CA3, output);
    else
        [CA3.spikesTot, CA3.fullData, CA3.midfiftyData, CA3.stableData, CA3.sixtyData, CA3.tSpikeConcurrents, CA3.concurrencyNetwork] = null_output;
        output = CA3Output(file, CA1oriens, output);
    end

    if DG.spikesTot > 0
        output = DGOutput(file, DG, output);
    else
         [DG.spikesTot, DG.fullData, DG.midfiftyData, DG.stableData, DG.sixtyData, DG.tSpikeConcurrents, DG.concurrencyNetwork] = null_output;
        output = DGOutput(file, CA1oriens, output);
    end

    if EC.spikesTot > 0
        output = ECOutput(file, EC, output);
    else
        [EC.spikesTot, EC.fullData, EC.midfiftyData, EC.stableData, EC.sixtyData, EC.tSpikeConcurrents, EC.concurrencyNetwork] = null_output;
        output = ECOutput(file, CA1oriens, output);
    end

end
cd(folder)
end
