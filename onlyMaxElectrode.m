function [maxMatrix] = onlyMaxElectrode(electrodes, maxMatrix, ampMatrix,w)

backup = ampMatrix;
for i = 1:size(ampMatrix,2)
    if nnz( i == electrodes) == 0
        ampMatrix(:,i) = 0; % blank out other subfields, dont output this
    end
end
%%
 % w is window either side i.e. half of the period we call the 'active' period of the spike
for i = floor(size(ampMatrix,1)/w)*w-w:-w:w+1 % working backwards

    if nnz(ampMatrix(i-w:i+w, electrodes)) > 0     

    [maxt maxElectrode] = find( ampMatrix(i-w:i+w,:) == max(max(ampMatrix(i-w:i+w,:)))); % in a 3ms window find the maximum amplitude channel

    if nnz(maxElectrode) > 1
        maxElectrode = maxElectrode(1); % only selects one selectode if multiple equal
    end
    if nnz(maxt) > 1
        maxt = maxt(1);
    end

    maxt = maxt+i-w-1;

    maxMatrix(maxt,maxElectrode) = 1; % sets to 1 in the position in that SUBFIELD where the max amplitude was
 %    maxMatrix(i+1:i+200,electrodes) = 0; % sets all in the row above to 0 in case of mutliple detections etc. Work backwards so that the very first time the spike is detected in subfield is where taken from
 %  maxMatrix(i+1:i+201,maxElectrode) = 0; % reimposing the void period
 

  
    end
   
end

%%

% ampMatrix = backup;
% maxMatrix = zeros(size(ampMatrix));
% 
% maxofrow = max(ampMatrix(:,electrodes), [], 2);
% [a b] = find(maxofrow > 0);
% 
% for i = 1:length(a)
%     t = a(i);
%    channel = find(ampMatrix(t,electrodes) == max(ampMatrix(t,electrodes)));
%    maxMatrix(t,channel) = 1;
% end

   


