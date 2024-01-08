function concurrencyPlots_Tommy(data,TimeChanMatrix, splitMEA, MEAtype, file, concurrencyNetwork)

if strcmp(MEAtype, 'split')
    toHighlight1 = splitMEA.electrodeGroup1;
    toHighlight1 = split(num2str(toHighlight1));
    toHighlight2 = splitMEA.electrodeGroup2;
    toHighlight2 = split(num2str(toHighlight2));
    toRemove = splitMEA.offGroup;
    %concurrencyNetwork = rmnode(concurrencyNetwork, toRemove);
    concurrencyNetworkPlot = plot(concurrencyNetwork);
    
        highlight(concurrencyNetworkPlot, toHighlight1,'NodeColor', 'k'); % only works for manual viewing, doesnt affect the saved form of graph - find a way to change
        highlight(concurrencyNetworkPlot, toHighlight2, 'NodeColor', 'r');
        highlight(concurrencyNetworkPlot, toRemove, 'NodeColor', 'g');
        saveas(concurrencyNetworkPlot, strcat(file.name(1:end-14), '_analysed_concurrencyNetworkPlot', '.png'));
else
   concurrencyNetworkPlot = plot(concurrencyNetwork);
   saveas(concurrencyNetworkPlot, strcat(file.name(1:end-14), '_analysed_concurrencyNetworkPlot', '.png'));
   
end 

close all

%% grouped concurrents - currently only removes the off group

if strcmp(MEAtype, 'split') % only does grouped concurrents if a split MEA
    tSpikeGConcurrents = zeros(size(data)); % set these up to avoid errors later
    GconcurrencyNetwork = zeros(64,64); % zeros so 1 values can be added onto

    for i = 1:size(TimeChanMatrix, 1) %selects first datapoint of the matrix
         pos1 = [TimeChanMatrix(i, 1:2)];

            for j = 1:(size(TimeChanMatrix, 1)) %selects every other datapoint in matrix for comparison
                pos2 = [TimeChanMatrix(j, 1:2)];

                if pos1(1,2) ~= pos2(1,2) && 0 < pos2(1,1) - pos1(1,1) && pos2(1,1) - pos1(1,1) < 200 % 10ms, debatable what value to use. Could set lower bound also. Excludes datapoints from the same channel
                    if ~(sum(pos1(1,2) == splitMEA.electrodeGroup1) && sum(pos2(1,2) == splitMEA.electrodeGroup1)) && ~(sum(pos1(1,2) == splitMEA.electrodeGroup2) && sum(pos2(1,2) == splitMEA.electrodeGroup2)) % only puts values where electrode is temporally linked to an electrode from the other group
                  
                        tSpikeGConcurrents(pos1(1,1),pos1(1,2)) = 1; % puts values into the tSpikeGConcurrents matrix where a concurrent spike is found
                        tSpikeGConcurrents(pos2(1,1),pos2(1,2)) = 1;

                        GconcurrencyNetwork(pos1(1,2),pos2(1,2)) = (GconcurrencyNetwork(pos1(1,2),pos2(1,2))+1); % for making the network 
                        %GconcurrencyNetwork(pos2(1,2),pos1(1,2)) = (GconcurrencyNetwork(pos2(1,2),pos1(1,2))+1); % need to plot on both sides of the diagonal to make adjacency matrix symmetric
              
                  
                    end    
                end
            end
    end
    tSpikeGConcurrents = sparse(tSpikeGConcurrents); % produces the sparse matrix output, included the off group but can be removed

    nodes = [1:64]; % for naming the nodes in such a way as can be selected for highlighting later
    nodes = strsplit(num2str(nodes)); % converts vector into a string then splits it into individual cells
    
    nodes{1} = ' ';
    nodes{9} = '  ';
    nodes{17} = '   ';
    nodes{18} = '    ';
    nodes{19} = '     ';
    nodes{25} = '      ';
    nodes{26} = '       ';
    nodes{27} = '        ';
    nodes{28} = '         ';
    nodes{33} = '          ';
    nodes{34} = '           ';
    nodes{35} = '            ';
    nodes{41} = '             ';
    nodes{42} = '              ';
    nodes{43} = '               ';
    nodes{49} = '                ';
    nodes{50} = '                 ';
    nodes{57} = '                  ';
    nodes{58} = '                   ';
    

    GconcurrencyNetworkMatrix = GconcurrencyNetwork; % saves a copy which can be output if desired
    
    GconcurrencyNetwork(splitMEA.offGroup,:) = 0; % sets off group to 0, handled differently to before as need to keep total number of nodes intact for producing bipartite graph
    GconcurrencyNetwork(:,splitMEA.offGroup) = 0;
    
    GconcurrencyNetwork = digraph(GconcurrencyNetwork, nodes); % produces the concurrency network, use either graph or digraph depending which you prefer

   
       toHighlight1 = splitMEA.electrodeGroup1; % highlights the group 1 electrodes
        toHighlight1 = split(num2str(toHighlight1));
        toHighlight2 = splitMEA.electrodeGroup2; % highlights the group 2 electrodes
        toHighlight2 = split(num2str(toHighlight2));
       toRemove = splitMEA.offGroup;
       % GconcurrencyNetwork = rmnode(GconcurrencyNetwork, toRemove);
        GconcurrencyNetworkPlot = plot(GconcurrencyNetwork);
        
            highlight(GconcurrencyNetworkPlot, toHighlight1,'NodeColor', 'g'); % highlights group 1 as green 
            GconcurrencyNetworkPlot.XData(splitMEA.electrodeGroup1) = 1; % collects group 1 along one axis
            highlight(GconcurrencyNetworkPlot, toHighlight2, 'NodeColor', 'b'); % highlights group 2 as blue
            GconcurrencyNetworkPlot.XData(splitMEA.electrodeGroup2) = 10; % collects group 2 along another axis
            highlight(GconcurrencyNetworkPlot, toRemove, 'Marker','none'); % makes the off group invisible
            GconcurrencyNetworkPlot.YData = linspace(0,1,64); % evenly spaces along the Y axis
            
     
           saveas(GconcurrencyNetworkPlot, strcat(file.name(1:end-14), '_analysed_groupedConcurrencyNetworkPlot', '.png'));
   
    end 
    
    close all



%% groups together same recordings from same electrode groups to get overall comparison

%{
if strcmp(MEAtype, 'split')
    groupedConcurrency1 = find(data(:,splitMEA.electrodeGroup1));
    groupedConcurrency2 = find(data(:,splitMEA.electrodeGroup2));

    
    gC1plot = zeros(1,length(data));
    gC1plot(groupedConcurrency1) = 1;
    plot(gC1plot)

    hold on

    gC2plot = zeros(1,length(data));
    gC2plot(groupedConcurrency2) = 1;
    subplot(gC2plot)
%}
%% attempt at statistical analysis of communication but not particularly functional

%{
    if mean(groupedConcurrency1) > mean(groupedConcurrency2)
        disp ('black tends to follow red')
    elseif mean(groupedConcurrency1) < mean(groupedConcurrency2)
        disp ('red tends to follow black')
    else
        disp ('black and red fire simultaneously')
    end    

    [h,p] = ttest2(groupedConcurrency1,groupedConcurrency2);
end
%}  
end