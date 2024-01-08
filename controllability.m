function [aveControl, modControl] = controllability(allMatrix)
% inputs
% file = the 11-digit identifier for the file you want to analyse in ' '
% form
% dtv = the first STTC to subtract. I think in msot cases should use 0 just
% to remove the immediate


logit = 0; % legacy
%% load data

close
%[spikefile, spikeMatrix, channels, HPCelectrodes] = loadHPCtrains(file);
%HPCelectrodes = getHPCelectrodes(file);
% get the STTC matrix as a proxy of connectivity


%newL = size(spikeMatrix,2);
%t1matrix = zeros(newL,newL);
%t2matrix = zeros(newL,newL);
%Time = 1:length(spikeMatrix);

%t1matrix = getSTTCmatrix(newL, spikeMatrix, dtv, Time, logit, t1matrix); % gets the matrix for the low t window supposedly indicating 'detecting the same spike'
%maxt1sttc = max(max(t1matrix)); % find the maximum STTC value
%cutoff = 0.25*maxt1sttc; % create a cutoff at 25% of this to preserve any of the very low connectivity electrodes

%keepmat = t1matrix < cutoff;
%remmat = t1matrix > cutoff;

%t2matrix = getSTTCmatrix(newL, spikeMatrix, dtv2, Time, logit, t2matrix);

%if dtv ~= 101  % set to 101 if you dont want to remove anything
%    allMatrix = t2matrix.*keepmat; % dot product only keeping those points which were below the cutoff for the low t matrix
%else
 %   allMatrix = t2matrix;
%end

%%

%[primaryHub, primaryArea, primaryElectrode, morphMatrix] = STTC_home(file, dtv, dtv2, logit);

[aveControl] = ave_control(allMatrix);
[modControl] = modal_control(allMatrix);


% [aveControlMorph] = ave_control(morphMatrix);
% [modControlMorph] = modal_control(morphMatrix);

% close
% plot(modControlMorph)
% hold on
% scatter(primaryHub,max(aveControlMorph), 50);
% hold on


% bear in mind does NOT match electrodes, must use a conversion table



