function concurrencyAnalysis(CA1layers, t1, t2, useCondition, redo_concurrency, domfactor)
% function to report any potential transfer of spikes between hippocampal
% subfields

folder = 'E:\Slice_MEA';

%% get all regional files

%% set parameters
% CA1layers = 1; % toggle 0 and 1 to do either CA1 or CA1 divided by layers
% t1 = 1; % minimum time after which event can have occurred
% t2 = 20; % maximum time after which event can have occurred

%redo_concurrency = 1; % if you change CA1layers OR either t1/t2 this needs to be set to 1

dominant_only = 1; % 1 = only the dominant direction of a connection is plotted
save_new = 1;

% useCondition = 'Every Condition'; % condition as per output file - quite long mind, would be good if could cut down to just do the parts OR 'Every Condition'
useSide = 'Both'; % not recorded for a large number but can do if want. L, R, or 'Both' if can be either

%% load analysis files
close all
clearvars fig G
cd .\RecFiles
regionals = strcat( '*', '_analysed_by_region.mat')';
rFiles = dir(regionals);

cd(folder)
allData = readtable('(AD and Epilepsy) Total MED64 Data.xlsx', 'VariableNamingRule','preserve');
%%

if redo_concurrency == 1
    disp(length(rFiles))
    for i = 1:length(rFiles)
        disp(i)

        fileName = rFiles(i).name;
        fileRef = fileName(1:11);

        % exclude files of the wrong condition


        %proceed with plot
        %      if isempty(dir(strcat(fileRef, '*', 'concurrency', '*', '.mat'))) % check hasn't been analysed already
        cd(folder)
        cd .\RecFiles\ 
        file = load(fileName);
        cd(folder)

        checkSpiking = nnz(file.DG.spikesTot) + nnz(file.CA3.spikesTot) + nnz(file.EC.spikesTot) + nnz(file.CA1.spikesTot); % determines number of spiking channels
        if checkSpiking < 2 % must have at least 2 spiking channels to plot
            note = strcat(num2str(checkSpiking), " ", 'subfields active - can not get concurrency');
            cd(folder)
            cd .\RecFiles\
            saveFile = strcat(fileName(1: length(fileName) - 22), 'concurrency_data.mat');
            save(saveFile, "note");
            cd(folder)

        else
            getConcurrencyMatrix(file, fileName, CA1layers, t1, t2, folder)
        end
        %      end
    end
end

%% plot concurrency for desired conditions/side

cd(folder)
cd .\RecFiles
adjacencies = strcat('*','_adjacency_matrix.mat')';
aFiles = dir(adjacencies);
aFiles = aFiles(~contains({aFiles.name}, strcat('all')));
cd(folder)




if CA1layers == 1
    allMatrix = ones(7,7)*2; % make from two so that the low weight edges can be removed from plot but also so can apply chi square
else
    allMatrix = ones(4,4)*2;
end


%% construct combined matrix
p=0;
for i = 1:length(aFiles)

    cd(folder)
    cd .\RecFiles
    fileName = aFiles(i).name;
    fileRef = fileName(1:11);

    cd(folder)
    [~, condition, ~, ~, side] = getMetadata(fileRef, allData);

%% choose condition
    correctCondition = contains(condition, useCondition); % checks if condition of recording is same as one wishing to plot concurrency for
  
    if strcmp('Every Condition', useCondition)
        correctCondition = 1; % use all recs if can do any condition
    end
%% choose side
    if side ~= "" % if the side for a recording has been noted
        correctSide = strcmp(side, useSide); % checks if side is the one desired
    else
        correctSide = 0; % if did specify side and has not been noted then have to ignore recording
    end
    % then note that if both sides can be used then will be a 1 regardless
    % overruling previous decision
    if strcmp('Both', useSide)
        correctSide = 1; % says that if any side was ok to use as indicated by * then can use recording even if was not noted down
    end
%% include recording and combine
    % finally combine into one metric for checking
    includeRecording = correctCondition + correctSide;


    if includeRecording == 2

        cd(folder)
        cd .\RecFiles
        file = load(fileName);
           cd(folder)
        adjacencyMatrix = file.adjacencyMatrix;
        %adjacencyMatrix = ceil(adjacencyMatrix*100 / 1+sum(sum(adjacencyMatrix)));
        N = nnz(adjacencyMatrix);
     

        %adjacencyMatrix = adjacencyMatrix / sum(sum(adjacencyMatrix)); % normalise for the number of detected propagations in recording

        if size(adjacencyMatrix) == size(allMatrix) % avoid error where there was adjacency when considering CA1 layer communication but not if CA1 considered alone
            allMatrix = allMatrix + adjacencyMatrix;
            p = p+1;
           
        end

    end
end

%%
allMatrix = round(allMatrix);

%allMatrix = round(((allMatrix/sum(sum(allMatrix)))*100))+1;


    %%

    if dominant_only == 1 % only included the 'dominant' connection
        perc = 1 / ((1-domfactor)+1);
        hideMatrix = zeros(size(allMatrix));
        for r = 1:size(allMatrix,1) % each row
            for c = 1:size(allMatrix,2) % each column i.e. every value
                number1 = allMatrix(r,c); % number
                number2 = allMatrix(c,r); % and its opposite direction weight

                if number1 > number2 % must be at least 50% greater
                    hideMatrix(c,r) = 1;
                elseif number2 > number1
                    hideMatrix(r,c) = 1;
                else
                end
                if number1 == 2
                    hideMatrix(r,c) = 1; % had to make matrix of 1s so that number of edges total was the same as the size of allMatrix for indexing to remove low weight ones
                end
                if r == c
                    hideMatrix(r,c) =1;
                end 
              
%                 if number1 < 0.04*sum( sum( allMatrix)) %(:, [1, length(allMatrix)-1, length(allMatrix)]))) % excludes the CA1s simply because so much connectivity otherwise
%                     hideMatrix(r,c) = 1;
%                 end
            end
        end

        hideVec = [];
        for k = 1:size(hideMatrix,1)
            hideVec = [hideVec, hideMatrix(k,:)];
        end
        hideVecFin = nonzeros([1:size(hideMatrix,1)^2].*hideVec);
    else
        hideVecFin = [1; 6; 11; 16];
     
    end



%% get dipgraphs and plot


if nnz(allMatrix) == 0
    disp(strcat('No concurrencies for', " ", useCondition, " ", 'recordings from', " ", useSide, " ", 'sides'))
else
    %allMatrix = ceil(allMatrix*100 / sum(sum(allMatrix)));
    if CA1layers == 1
        G = digraph(allMatrix); ...
           % {'DG', 'CA1 oriens', 'CA1 pyramidale', 'CA1 radiatum', 'CA1 moleculare', 'CA3', 'EC'}); % dont omit self loops so can do the low weight removals. If not can remove later anyway

        x = [0, -150, -50, 50, 150, -100, 100];
        y = [-100, 50, 200, 200, 50, -50, -50];

    else
        G = digraph(allMatrix,...
           {'DG', 'CA1', 'CA3', 'EC'}); % dont omit self loops so can do the low weight removals. If not can remove later anyway

        x = [-100, 100, -100, 100];
        
        y = [-50, 100, 100, -50];

    end
    figure('WindowState', 'Maximized');
    fig = plot(G, ...
        'XData', x, 'YData', y,...
        'LineWidth', G.Edges.Weight/(max(G.Edges.Weight)/8), ...
        'EdgeLabel', G.Edges.Weight, ...
        'ArrowSize', 20, ...
        'ArrowPosition', 0.8,...
        'EdgeAlpha', 0.5, ...
        'EdgeFontSize', 20, ...
        'NodeFontSize', 20, ...
        'NodeLabelColor', 'r', ...
        'EdgeColor', [0.5 0.5 0.5]);

    hold on
    aesthetics
    axis off
    for i = 1:length(hideVecFin)
        highlight(fig, 'Edges', hideVecFin(i), 'EdgeColor', 'w'); % hides self loops and edges of lower weight than counterdirectional counterpart
    
        fig.EdgeLabel{hideVecFin(i)} = char("");
    end

    title( {strcat('Concurrency Plot for', " ", useCondition, " ", 'Recordings from', " ", useSide, " ", 'Sides'), 'Showing Potential IIS Communication'});

    if save_new == 1
        cd(folder)
        cd .\FunctionalConnectivity
        allMatrix = allMatrix(:);
        keep = (allMatrix ~= 2);
        allMatrix = allMatrix.*keep;
        save('___.mat', 'allMatrix');
        saveas(fig, strcat(useCondition, '_', useSide, '_sides_concurrency_plot.png'))
         save(strcat(useCondition, '_', useSide, '_sides_combined_recordings_adjacency_matrix.mat', "adjacencyMatrix"));

        cd(folder)
            end
end


allMatrix
a = allMatrix;

