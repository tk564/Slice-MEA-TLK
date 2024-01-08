function [acquiescent, interictal, ictal] = defineSpikeperiods(spikeMatrix, fs)
%% general parameters

% establish matrices to be filled such as 1 will indicate the recording is
% in a particular phase i.e. ...00000011111111111111100000...
acquiescent = zeros(size(spikeMatrix));
interictal = zeros(size(spikeMatrix));
ictal = zeros(size(spikeMatrix));


%% run burst detection

for i = 1:size(spikeMatrix,2)

    if nnz(spikeMatrix) > 20 % only for 'active channels'
        % 0 is a placeholder
        ictal(:,i) = bakkumBurstDetect(spikeMatrix(:,i), fs, 10, 0); 
    end
end
%%

