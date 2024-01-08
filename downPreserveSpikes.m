function [downMatrix] = downPreserveSpikes(spikeMatrix,d)

% 30ms the cutoff used based on empirical stuff. downsample by 10 then do
% x+/-1 as to be ignored
% spike matrix is the spike matrix input
% d is the downsampling factor

finL = floor(length(spikeMatrix)/d);
downMatrix = zeros(finL,size(spikeMatrix,2));
% % 
% % starts = [1:d:length(spikeMatrix)-25];
% spikeMT = spikeMatrix; % temporary matrix to use so dont do multiple detections
% 
% for i = 25:length(spikeMT)
%     
%     if nnz(spikeMT(i,:)) > 0
%         
%         spikes = sum(spikeMatrix(i:i+24,:));
%         spikes = spikes ~=0;
%         spikeMT(i:i+24,:) = 0;
% 
%         downMatrix(floor(i/24),:) = spikes;
%     end
% end
spikeMatrix(:,1:d) = 0;
[t c] = find(spikeMatrix);
t = floor(t/d);

for i = 1:length(t)
    downMatrix(t(i),c(i)) = 1;
end
