function combinedSpikes = loadRegionalSpikes(fileName, CA1layers)

regionals = dir(strcat(fileName(1:11), '*', '_analysed_by_region.mat'));
file = load(regionals.name);

DG = file.DG;
CA1 = file.CA1;
CA1oriens = file.CA1oriens;
CA1pyramidale = file.CA1pyramidale;
CA1radiatum = file.CA1radiatum;
CA1moleculare = file.CA1moleculare;
CA3 = file.CA3;
EC = file.EC;

%% load combined spikes for all



if CA1layers == 1
    spikes = zeros(25*60*1000,7); % sets up a matrix to accomodate a 25 min recording
    try
        spikes(1:length(DG.combinedSpikes),1) = DG.combinedSpikes;
    catch
        spikes(:,1) = 0;
    end
    try 
        spikes(1:length(CA1.combinedSpikes),2) = CA1.combinedSpikes;
    catch
        spikes(:,2) = 0;
    end
    try 
        spikes(1:length(CA1oriens.combinedSpikes),3) = CA1oriens.combinedSpikes;
    catch
        spikes(:,3) = 0;
    end
    try
        spikes(1:length(CA1pyramidale.combinedSpikes),4) = CA1pyramidale.combinedSpikes;
    catch
        spikes(:,4) = 0;
    end
    try
        spikes(1:length(CA1moleculare.combinedSpikes),5) = CA1moleculare.combinedSpikes;
    catch
        spikes(:,5) = 0;
    end
    try 
        spikes(1:length(CA3.combinedSpikes),6) = CA3.combinedSpikes;
    catch
        spikes(:,6) = 0;
    end
    try 
        spikes(1:length(EC.combinedSpikes),7) = EC.combinedSpikes;
    catch
        spikes(:,7) = 0;
    end
else
    spikes = zeros(25*60*1000,4);


 try
        spikes(1:length(DG.combinedSpikes),1) = DG.combinedSpikes;
    catch
        spikes(:,1) = 0;
 end
 try
     spikes(1:length(CA1.combinedSpikes),2) = CA1.combinedSpikes;
 catch
     spikes(:,2) = 0;
 end
  try 
        spikes(1:length(CA3.combinedSpikes),3) = CA3.combinedSpikes;
    catch
        spikes(:,3) = 0;
    end
    try 
        spikes(1:length(EC.combinedSpikes),4) = EC.combinedSpikes;
    catch
        spikes(:,4) = 0;
    end
end

[a b] = find(spikes);
final = max(a);
combinedSpikes = spikes(1:final+1000, :); % trims down the matrix


end