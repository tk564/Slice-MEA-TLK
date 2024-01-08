function [primaryHub, primaryArea, primaryElectrode, export, transformations] = STTC_home(file, dtv, dtv2, logit)

[spikefile, spikeMatrix, channels] = loadHPCtrains(file);

%% rearrange into EC -> DG -> CA3 -> CA1 

null = zeros(size(spikeMatrix,1),1);
morph = zeros(size(spikeMatrix,1),1);
noCA1 = 0;

transformations = zeros(2,size(spikeMatrix,2));
transformations(1,:) = 1:size(spikeMatrix,2);
[slicepics, row] = rowForSlicepics(spikefile);
 if ~isempty(slicepics{row, 12})
               ECs = str2num(slicepics{row,12})';
               [morph, transformations] = orderChannels(channels, ECs, spikeMatrix, null, morph, transformations);
 else 
     ECs = [];
               
 end
 if ~isempty(slicepics{row, 5}) 
               DGs = str2num(slicepics{row,5})';  
               [morph, transformations] = orderChannels(channels, DGs, spikeMatrix, null, morph, transformations);
                else 
     DGs = [];
 end
 if ~isempty(slicepics{row, 6})
               CA3s = str2num(slicepics{row,6})';
               [morph, transformations] = orderChannels(channels, CA3s, spikeMatrix, null, morph,transformations);
                else 
     CA3s = [];
 end
 if ~isempty(slicepics{row, 8})
               CA1orienss = str2num(slicepics{row,8})';
               [morph,transformations] = orderChannels(channels, CA1orienss, spikeMatrix, null, morph,transformations);
                else 
     CA1orienss = [];
     noCA1 = noCA1+1;
 end
 if ~isempty(slicepics{row, 9})
               CA1pyramidales = str2num(slicepics{row,9})';
               [morph,transformations] = orderChannels(channels, CA1pyramidales, spikeMatrix, null, morph,transformations);
                else 
     CA1pyramidales = [];
     noCA1 = noCA1+1;
 end
  if ~isempty(slicepics{row, 10})
               CA1radiatums = str2num(slicepics{row,10})';
               [morph,transformations] = orderChannels(channels, CA1radiatums, spikeMatrix, null, morph,transformations);
                else 
     CA1radiatums = [];
     noCA1 = noCA1+1;
  end
  if ~isempty(slicepics{row, 11})
               CA1moleculares = str2num(slicepics{row,11})';
               [morph,transformations] = orderChannels(channels, CA1moleculares, spikeMatrix, null, morph,transformations);
                else 
     CA1moleculares = [];
     noCA1 = noCA1+1;
  end

  CA1s = []; % placeholder to avoid error later
  if noCA1 == 4
      if ~isempty(slicepics{row,7})
      CA1s = str2num(slicepics{row,7})';
      [morph,transformations] = orderChannels(channels, CA1s, spikeMatrix, null, morph,transformations);
      else 
          CA1s = [];
      end
  end


morph(:,1) = [];
morph(1,:) = [];

  
%%
 checks = zeros(1,1);
% for x = 0:0.05:1
for x = 0.5 % placeholder, doesnt matter as switching to just excluding any from the same subfield
% in the output matrix we want to cluster together anatomically but first
% we just do a general output
newL = size(morph,2);
t1matrix = zeros(newL,newL);
t2matrix = zeros(newL,newL);
Time = [1,length(spikeMatrix)];

t1matrix = getSTTCmatrix(newL, morph, dtv, Time, logit, t1matrix); % gets the matrix for the low t window supposedly indicating 'detecting the same spike'
%maxt1sttc = max(max(t1matrix)); % find the maximum STTC value
keep = t1matrix < x;


t1matrix = t1matrix.*keep;
%cutoff = 0.1*maxt1sttc; % create a cutoff at 25% of this to preserve any of the very low connectivity electrodes
% heatmap(max1sttc)
% 
% pause
% 
% keepmat = t1matrix < cutoff;
% remmat = t1matrix > cutoff;

t2matrix = getSTTCmatrix(newL, morph, dtv2, Time, logit, t2matrix);

if dtv ~= 101  % set to 101 if you dont want to remove anything
    allMatrix = t2matrix.*keep; % dot product only keeping those points which were below the cutoff for the low t matrix
else
    allMatrix = t2matrix;
end

% score = nnz(allMatrix);
% checks = [checks, score];
 
% plot(checks)
%% set to 0 if on the same electrode subfield
% if means cant find one because doesnt communicate, re-does it

backupMatrix = allMatrix;
 left = [1 9 17 18 19 25 26 27 28 33 34 35 41 42 43 49 50 57 58];
 top = [2 3 4 5 6 7 10 11 12 13 14 20 21 22 29 36 44 45 51 52 53 59 60 61];
 right = [8 15 16 23 24 30 31 32 37 38 39 40 46 47 48 54 55 56 62 63 64];

 groups = {'left', 'top', 'right'}; 
    for i = 1:length(groups)

    if i == 1
        to_combine = left; % to combine is a leftover from where code written, is jsust the subfield in use
    elseif i == 2
        to_combine = top;
    elseif i ==3
        to_combine = right;
    end

    % convert train using transformations
    newPositions = 0;
    for j = 1:length(to_combine)
        new = find(transformations(1,:) == to_combine(j));
        new = transformations(2,new);
        newPositions = [newPositions,new];
    end
    newPositions = nonzeros(newPositions); % all the new positions of electrodes in the given subfield

    for k = 1:length(newPositions)
        for m = 1:length(newPositions)
            allMatrix( newPositions(k), newPositions(m)) = 0; % sets to no correlation if from same subfield
        end
    end
    end

        







%%

k = heatmap(allMatrix, 'Colormap', plasma, 'CellLabelColor','none');

[ECns, DGns, CA3ns, CA1oriensns, CA1pyramidalens, CA1radiatumns, CA1molecularens, CA1ns]= plotSTTC(ECs, DGs, CA3s, CA1orienss, CA1pyramidales, CA1radiatums, CA1moleculares, noCA1, CA1s);


totConnectivity = zeros(1,length(allMatrix));
for i = 1:length(totConnectivity)

    col = sum(allMatrix(:,i));
    row = sum(allMatrix(i,:));
    self = allMatrix(i,i);
    totConnectivity(i) = col + row - self;
end

[primaryHub, primaryArea] = getPrimaryHub(totConnectivity, ECns, DGns, CA3ns, CA1molecularens, CA1pyramidalens, CA1radiatumns, CA1oriensns, CA1ns, noCA1);

export = allMatrix;

if strcmp(primaryArea, 'NaN')
    % if doesnt work as no communication between subfields then redoes it
    % (and notes lack of communication in display)
    disp(strcat(file," ", 'does not communicate between subfields'))


    allMatrix = backupMatrix;
    k = heatmap(allMatrix, 'Colormap', plasma, 'CellLabelColor','none');
    
    [ECns, DGns, CA3ns, CA1oriensns, CA1pyramidalens, CA1radiatumns, CA1molecularens, CA1ns]= plotSTTC(ECs, DGs, CA3s, CA1orienss, CA1pyramidales, CA1radiatums, CA1moleculares, noCA1, CA1s);
    
    
    totConnectivity = zeros(1,length(allMatrix));
    for i = 1:length(totConnectivity)
    
        col = sum(allMatrix(:,i));
        row = sum(allMatrix(i,:));
        self = allMatrix(i,i);
        totConnectivity(i) = col + row - self;
    end
    
    [primaryHub, primaryArea] = getPrimaryHub(totConnectivity, ECns, DGns, CA3ns, CA1molecularens, CA1pyramidalens, CA1radiatumns, CA1oriensns, CA1ns, noCA1);
    
    
k = heatmap(allMatrix, 'Colormap', plasma, 'CellLabelColor','none');

[ECns, DGns, CA3ns, CA1oriensns, CA1pyramidalens, CA1radiatumns, CA1molecularens, CA1ns]= plotSTTC(ECs, DGs, CA3s, CA1orienss, CA1pyramidales, CA1radiatums, CA1moleculares, noCA1, CA1s);


totConnectivity = zeros(1,length(allMatrix));
for i = 1:length(totConnectivity)

    col = sum(allMatrix(:,i));
    row = sum(allMatrix(i,:));
    self = allMatrix(i,i);
    totConnectivity(i) = col + row - self;
end

[primaryHub, primaryArea] = getPrimaryHub(totConnectivity, ECns, DGns, CA3ns, CA1molecularens, CA1pyramidalens, CA1radiatumns, CA1oriensns, CA1ns, noCA1);

end








[primaryElectrode] = find(transformations(2,:) == primaryHub);


disp(strcat('Primary hub appears to be over', " ", primaryArea))


checks = [checks, primaryElectrode];
end
checks(1:length(checks)-22) = [];
%plot(checks)


















