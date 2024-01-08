    function [tSpikeConcurrents,concurrencyNetwork] = tSpikeConcurrentFinder_Tommy(data,TimeChanMatrix, splitMEA, MEAtype, file)

%%
% function will scan through the TimeChanMatrix and give a readout of any
% instances where a spike occurs close in time to another one within 10ms
% which reflects conduction delays but eh can play around with
% ALSO not urgent but make sure the script does directionality properly I
% think its ok as only selects ones whicha are ahead in time and this
% applies for all points

tSpikeConcurrents = zeros(size(data));
concurrencyNetwork = zeros(64,64);

 for i = 1:size(TimeChanMatrix, 1) %selects first datapoint of the matrix
     pos1 = [TimeChanMatrix(i, 1:2)];

        for j = 1:(size(TimeChanMatrix, 1)) %selects every other datapoint in matrix for comparison
            pos2 = [TimeChanMatrix(j, 1:2)];

            if pos1(1,2) ~= pos2(1,2) && 1 < pos2(1,1) - pos1(1,1) && pos2(1,1) - pos1(1,1) < 200 % 10ms, debatable what value to use. Could set lower bound also. Excludes datapoints from the same channel
              
               tSpikeConcurrents(pos1(1,1),pos1(1,2)) = 1; % puts values into the tSpikeConcurrents matrix where a concurrent spike is found
               tSpikeConcurrents(pos2(1,1),pos2(1,2)) = 1;

               concurrencyNetwork(pos1(1,2),pos2(1,2)) = (concurrencyNetwork(pos1(1,2),pos2(1,2))+1); % for making the network 
               %concurrencyNetwork(pos2(1,2),pos1(1,2)) = (concurrencyNetwork(pos2(1,2),pos1(1,2))+1); % need to plot on both sides of the diagonal to make adjacency matrix symmetric
            end
        end
 end

tSpikeConcurrents = sparse(tSpikeConcurrents); % produces the sparse matrix output

nodes = [1:64]; % for naming the nodes in such a way as can be selected for highlighting later
nodes = strsplit(num2str(nodes));

concurrencyNetworkMatrix = concurrencyNetwork;
concurrencyNetwork = digraph(concurrencyNetwork, nodes); % produces the concurrency network, use either graph or digraph depending which you prefer

% consider adding something here so only does concurrency networks if the
% two subfields have concurrency

checkSubfieldCommunication = nnz(concurrencyNetworkMatrix(splitMEA.electrodeGroup1, splitMEA.electrodeGroup2)) + nnz(concurrencyNetworkMatrix(splitMEA.electrodeGroup2, splitMEA.electrodeGroup2));

%% can plot if you want

%if checkSubfieldCommunication >= 1
%   concurrencyPlots_Tommy(data,TimeChanMatrix, splitMEA, MEAtype, file, concurrencyNetwork);
%else
%end    


end


            
