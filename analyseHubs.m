function analyseHubs

hubs = load('IIS_hubs.mat');


output = hubs.output;
control = hubs.controlMetrics;
connectivity = hubs.connectivityMetrics;
maxAmps = hubs.maxAmps;

slicepics = readtable("slice pic analysis.xlsx", 'VariableNamingRule', 'preserve'); % load the table with channel info
    slicepics = table2cell(slicepics);
    allData = readtable('(AD and Epilepsy) Total MED64 Data.xlsx', 'VariableNamingRule', 'preserve');


for i = 1:length(output)
   



    recording = cell2mat(output(i,1)); % gets the recording name
    try
    [~, ~, ~, slice, ~] = getMetadata(recording, allData); % gets the slice number from big table

    
    indexer = cell2mat(slicepics(:,1:2));
    date = str2num(recording(1:8));
    row = 0;
    for k = 1:size(slicepics,1)
        
        if indexer(k,1) == date
           
            if indexer(k,2) == slice
                row = k;
            end
        end
    end
    HPCelectrodes = [str2num(slicepics{row,5}), str2num(slicepics{row,6}),  str2num(slicepics{row,7}), str2num(slicepics{row,12})]; % get channels of DG/CA3/CA1all/ECnd
    % DG, CA3, CA1, EC


    [h.meanConnectivity, h.maxConnectivity, h.maxConnectivity_electrode, h.STDConnectivity,h.maxConnectivity_region,  h.connectivity_per_region] = getMetrics(connectivity(i,:));
     [h.meanControl, h.maxControl, h.maxControl_electrode, h.STDControl, h.maxControl_region, h.control_per_region] = getMetrics(control(i,:));
     [h.meanPrimary, h.maxPrimary, h.maxPrimary_electrode, h.STDPrimary, h.maxPrimary_region, h.primary_per_region] = getMetrics(maxAmps(i,:));
    
        save(strcat(recording, '_hub_stuff.mat'), 'h');
    catch
end
end




function [a, b, c, d, e, f] = getMetrics(vector)

    try
    a = mean(nonzeros(vector));
    b = max(nonzeros(vector));
    c = find(b == vector);
    d = std(nonzeros(vector));
    catch
        a = 0;
        b = 0;
        c = 0;
        d = 0;
        
    end
    try
        if nnz(c == str2num(slicepics{row,5})) == 1
            e = 1;
        elseif nnz(c == str2num(slicepics{row,6})) == 1
            e = 2;
        elseif nnz(c == str2num(slicepics{row,7})) == 1
            e = 3;
        elseif nnz(c == str2num(slicepics{row,12})) == 1
            e = 4;
        else
            e=0;
        end
    catch
        e = 0;
    end
            


    try
    f = [mean(vector(str2num(slicepics{row,5}))), mean(vector(str2num(slicepics{row,6}))), mean(vector(str2num(slicepics{row,7}))), mean(vector(str2num(slicepics{row,12})))];
    catch
        f = [0,0,0,0];
    end
end
end
   

    