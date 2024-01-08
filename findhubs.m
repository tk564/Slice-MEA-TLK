function findhubs

folder = 'E:/Slice_MEA';

cd(folder)
cd .\RecFiles

files = dir(strcat('*', 'spike_raster.png')); % these will all have spikes in mutliple channels
files = files(~contains({files.name},'su'));
files = files(~contains({files.name}, '0_spike_raster.png'));



%% 
% max distance between centres of subfields is 150units on imageJ
% distance between 2 recording electrodes is 10units on imageJ
% this is 150um IRL
% thus max distance between two of the subfield centrs is 1500um or 1.5mm
% sampling is in ms

% maharati et al 2021 considered events within 50ms of eachother to be
% synchronous?
% Gill et al, 2020 doing slice MEA says hypersynchronous epileptiform
% events propagate at a mean  9.32 mm s−1 as with disinhibited slices 
% assuming this then time to travel from one electrode to an adjacent would
% be 0.15/9.32 = 0.01609 = 16.9ms
% from one subfield to another would be 0.1609s
% we are not looking at electrode-electrode as too uncertain with current
% methods. but validated setting a limit of 200ms for second timepair

% have validated that a single event will not spill detection over into
% multiple subfields but can to multiple electrodes
timepairs = [10, 200];


output = cell(length(files)*size(timepairs,1),5);
connectivityMetrics = zeros(length(files)*size(timepairs,1),64);
controlMetrics = zeros(length(files)*size(timepairs,1),64);

maxAmps = zeros(length(files),64);

row=1;
for i = 1:length(files)
      cd(folder)
    cd .\RecFiles
  try
  
    disp(strcat(num2str(i), '/', num2str(length(files))))

    ref = files(i).name(1:11);

    finalData_file = dir(strcat(ref, '*', 'finalData_6.mat'));
    finalData = load(finalData_file.name);
    finalData = finalData.finalData;

    spikeMatrix_file = dir(strcat(ref, '*', 'Spikes_6.mat'));
    spikeMatrix = load(spikeMatrix_file.name);
    spikeMatrix = spikeMatrix.spikeMatrix;

    cd(folder)
    n_as_max = checkSameSpike(finalData, spikeMatrix, 'all');
    maxAmps(i,:) = n_as_max;

    


    for j = 1:size(timepairs,1)

        toanalyse = files(i);
        file = {toanalyse.name(1:11)};
        dtv = timepairs(j,1);
        dtv2 = timepairs(j,2);
        [primaryHub, primaryArea, primaryElectrode, allMatrix, transformations] = STTC_home(file, dtv, dtv2, 0);

        output(row,1) = (file);
        output(row,2) = {timepairs(j,:)};
        output(row,3) = {primaryElectrode};
        output(row,4) = {primaryHub};
        output(row,5) = {primaryArea};

         connectivity = sum(allMatrix);
         [aveControl, modControl] = controllability(allMatrix);
         toadd = zeros(1,64);
         toaddC = zeros(1,64);
         for k = 1:length(aveControl)
             old = find(transformations(2,:) == k);
               
                 toadd(old) = aveControl(k);
                toaddC(old) = connectivity(k);
                
                 
         end
        controlMetrics(row,:) = toadd;
        connectivityMetrics(row,:) = toaddC;
        row = row+1;
        
    end
   end

end

save('IIS_hubs', 'output', 'controlMetrics', 'connectivityMetrics', 'maxAmps')

analyseHubs




    
