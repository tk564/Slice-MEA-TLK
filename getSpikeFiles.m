function [data, channels, file, finalData, thresholds, exclude] = getSpikeFiles(f, tSpikeFiles, recording_ref, reanalyse)




file = tSpikeFiles(f);
disp(file.name)

cd("RecFiles\")
if ~isempty(dir(strcat(file.name(1:end-4), '*' , '_analysed.mat'))) && reanalyse == 0
    disp(strcat('already analysed', " ", file.name(1:end-14)))

    % set placeholder values to contintinue if already analysed and not to
    % be reanalysed. Using 0 is fine as exclude is set to 1 so will not
    % proceed further
    data = 0;
    channels = 0;
    finalData = 0;
    thresholds = 0;

    alreadyDone = 1;
else % analyse if not already done:
    alreadyDone = 0;
    data = load(file.name, 'spikeMatrix');
    data = data.('spikeMatrix');

end

cd ../
exR = readtable('Exclude Recordings.xlsx', 'VariableNamingRule', 'preserve');
exR = table2array(exR(:,1));
present = find(exR ==  str2num(file.name(1:11)) );

if ~isempty(present)
    exclude = 1;
elseif reanalyse == 0 && alreadyDone == 1
    exclude = 1;
else
    exclude = 0;
end

cd("RecFiles\")
if exclude == 0

    channels = load(file.name, 'channels');
    channels = channels.('channels');
    thresholds = load(file.name, 'thresholds');
    thresholds = thresholds.('thresholds');

  % cd('D:\Final Data');
    try
        finaldatafile = strcat(file.name(1:length(file.name)-12), 'finalData_6.mat');
        finalData = load(finaldatafile);
        finalData = finalData.finalData;


    catch
        finaldatafile = strcat(file.name(1:length(file.name)-13), 'finalData_6.mat');
        finalData = load(finaldatafile);
        finalData = finalData.finalData;
    end
    cd ../;
else
    channels = 0;
    thresholds =0;
    finalData = 0;


end







end
