function [isItASpike, currentSpikeTemplate, similarity, similarityNeg] = validateSpikeTemplate_Tommy(currentSpikeTemplate, fs, metadata, c, k,tempLength, sType)
% checks against a known spike if a decent template, if not the template
% taken over by the backup

if k >= 1
    c = 0.75; % slightly more leeway during the iteratiosn thean when first establishing the template
end

%polarity = metadata.polarity; % tells if spikes in the recording are positive or negative

if strcmp(sType, 'mu')
knownSpike = load("knownSpike.mat");
knownSpike = knownSpike.knownSpike; % loads a validated spike template, normalised from [0 1] from 20170820004 data
knownSpike = downsample(knownSpike, 20000/fs); % downsamples to whatever the new fs is
knownSpike = knownSpike(250:750);
elseif strcmp(sType, 'su')
    knownSpike = load("suSpike.mat");
    knownSpike = knownSpike.suSpike; %
    knownSpike = knownSpike(10:50);
    knownSpike = downsample(knownSpike,2);
end
%%

getmid = tempLength-1; % need to subtract 1 so indexing is of an even number

corr = normxcorr2(knownSpike, currentSpikeTemplate);
similarity = max( corr(getmid*2*0.25:getmid*2*0.75) ); % focuses the correlation on the middle 50% to make sure not some other spike getting detected

corr2 = normxcorr2(-knownSpike+1,currentSpikeTemplate);
similarityNeg = max( corr2(getmid*2*0.25:getmid*2*0.75));

        isItASpike = 1;
        
        
if similarity < c  % if correlation is too low then replace with the known spike template HOWEVER if in the iteration phase then do not check as refinement should be allowed to match as best as possible
 
        isItASpike = 0;
        currentSpikeTemplate = knownSpike;
    
else
    

end


