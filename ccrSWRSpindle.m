function [SWRspindleCouples,totalCorr] = ccrSWRSpindle(sim_SWR,sim_spindles)
%This calculates the probability of finding a spindle in the 4 seconds
%surrounding a ripple.

% Version for observed data
%RipplePeaks = SWR(:,2);
%SpindlePeaks = spindles(:,2);

% Version for simulated data
RipplePeaks = sim_SWR;
SpindlePeaks = sim_spindles;

SWRspindleCouples=[]; %array of SWR peak times, spindle peak times and delay between them if they fall within window
totalCorr=[]; %percentage of SWRs that have spindles around them
%SWRspindleProb=[];

windowLength=2; %seconds

%for loop begins here, in size(ripplepeaks)
for i=1:length(RipplePeaks)
    
        %for a window starting at SWR, window start would be RipplePeaks(i) and windowEnd=RipplePeaks(i)+windowLength
        windowStart=RipplePeaks(i)-windowLength; 
        windowEnd=RipplePeaks(i)+windowLength;
        SWRspindleCouples(i,1)=RipplePeaks(i);
    
        for o=1:length(SpindlePeaks) %should need to account for potential two spindles within range?
            if SpindlePeaks(o)>windowStart && SpindlePeaks(o)<windowEnd
                SWRspindleCouples(i,3)=SpindlePeaks(o)-RipplePeaks(i); %SpindlePeaks(o)-RipplePeaks(i); %interval between the two events
                SWRspindleCouples(i,2)=SpindlePeaks(o);
                break
            else
                continue
            end
        end
    
end

%calculate percentage of SWRs that are surrounded by spindles
totalCorr = nnz(SWRspindleCouples(:,3))/length(SWRspindleCouples(:,3))*100; %determine number of non-zero elements in delay column / total elements

%to find percentage of empty windows: p=100-totalCorr;
end
