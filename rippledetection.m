%% FIR high frequency filter

%REMOVE DC CURRENT - not necessary though because it's based on frequency and power entirely
clear DCremoved_CA1
DCremoved_CA1(1,:)=localCA1(1,:)-mean(localCA1(1,:)); % this is just the signal imported into MATLAB

%80-250 HZ FILTER - ripple band frequency
clear filtered_CA1
filtered_CA1(1,:)=bandpass(DCremoved_CA1(1,:),[80 250],1000,'ImpulseResponse','fir');

% CALL MYFINDRIPPLE
signal=filtered_CA1;

% can modify the thresholds/parameters here (look at the first part of MyFindRipples to understand what they are)
fs=1000; % !CHECK THIS! - This is the sampling rate of your recordings. In our preprocessing pipeline we downsampled to 1000.
time = (1:size(localCA1,2)) / fs;
%clear ripples
[ripples, sd, normalizedSquaredSignal] = MyFindRipples(time', signal', ...
                     'frequency', fs, ...
                     'thresholds', [2 5 0.01],... % lowThresholdFactor, highThresholdFactor, lowThresholdMV
                     'durations', [20 20 100],... % minInterRippleInterval, minRippleDuration, maxRippleDuration = durations(3);
                     'std', 0);

 %% plot (not for figures, just for visualisation)
figure(1) 

% CA1 trace
plot (DCremoved_CA1)
hold on 

% Just for SWRs, the cortical traces below are not needed. Could use the same
% method to visualise many units (ie EC, CA1, CA3, DG) if you want though. 

%add cortex channel to look for SWS
%clear DCremoved_PFC
%DCremoved_PFC(1,:)=localPFC(1,:)-mean(localPFC(1,:));
plot(DCremoved_PFC+500) % so that PFC doesn't overlap with CA1 on the graph
%DCremoved_S1(1,:)=localS1(1,:)-mean(localS1(1,:));
%plot(DCremoved_S1+1000)
plot(filtered_PFC+1000)

% to mark the beginning and end of ripples
y=-200*ones(size(ripples(:,2)));
scatter(ripples(:,1)*1000,y,'filled','r')
scatter(ripples(:,3)*1000,y,'filled','b')

plot(filtered_CA1-1000); %CA1 high frequency power trace

%% plot for coupling figures
 
% You won't need this as it shows cortical spindles and CA1 ripples in parallel.
figure(1) 

% CA1 trace
plot (DCremoved_CA1,'Color','black')
hold on 

%add cortex channel to look for SWS
%clear DCremoved_PFC
%DCremoved_PFC(1,:)=localPFC(1,:)-mean(localPFC(1,:));
plot(DCremoved_PFC+1300,'Color','black') % so that PFC doesn't overlap with CA1 on the graph

%DCremoved_S1(1,:)=localS1(1,:)-mean(localS1(1,:));
%plot(DCremoved_S1+1000)
plot(filtered_PFC+2300,'LineWidth',1.5,'Color',[.8 .8 .8])

 % to mark the beginning and end of ripples
y=-200*ones(size(ripples(:,2)));
scatter(ripples(:,2)*1000,y,100,'filled','r')
z=1300*ones(size(spindles(:,2)));
scatter(spindles(:,2)*1000,z,100,'filled','b')

plot(filtered_CA1-1000,'LineWidth',0.5,'Color',[.8 .8 .8]);%CA1 high frequency power trace

xlim([37000 42000])

line([37900 38200],[700 700],'LineWidth',1,'Color','black')
line([37900 37900],[700 1000],'LineWidth',1,'Color','black')

text(37900, 600, '300 ms','FontSize',12,'Color','black')
h=text(37830, 660,'300 μV','FontSize',12,'Color','black');
set(h,'Rotation',90);

 %% plot for SWR figures (could use this for SWR example figures)
figure(1) 

% Cortex trace
plot (DCremoved_CA1,'LineWidth',0.75,'Color','black')

%top=600*ones(size(spindles(:,1),1));
%bottom=-600*ones(size(spindles(:,1),1));
for i=1:size(ripples(:,1))
    x_val(1:2,i)=ripples(i,1)*1000;
    x_val(3:4,i)=ripples(i,3)*1000;
    y_val(1,i)=1500;
    y_val(2:3,i)=-2000;
    y_val(4,i)=1500;
end

patch(x_val,y_val,[0.8500, 0.3250, 0.0980],'FaceAlpha',.2,'EdgeColor','none')
hold on

 % to mark the beginning and end of spindles
%y=-200*ones(size(spindles(:,2)));
%scatter(spindles(:,1)*1000,y,'filled','r')
%scatter(spindles(:,3)*1000,y,'filled','b')

plot(filtered_CA1-1000,'LineWidth',1.5,'Color','black');

%line([87730 87830],[540 540],'LineWidth',1.5,'Color','black')
%line([87730 87730],[540 1040],'LineWidth',1.5,'Color','black')

%text(87740, 400, '100 ms','FontSize',13,'Color','black')
%h=text(87710, 590,'500 μV','FontSize',13,'Color','black');
%set(h,'Rotation',90);

%set(gca,'XTick',0:1000:1000000)
%set(gca,'XTickLabel',0:1:1000)
%ax=gca;
%ax.FontSize = 20;
%xlabel('Time (s)')
%ylabel('Voltage (μV)')
%yticks([-500 0 500])

%%  amend the time point if this is not the first batch

% You won't need this. This was to normalise SWR timestamps because I
% analysed large files in sections.

clear newripples
m=20%minutes for each batch, %CHECK THIS%
total_sec = m*60;
numofbatch=3% change this to the number of batch you are working on, %CHECK THIS%
read_init_pos = (numofbatch-1)*total_sec; 
newripples=[(ripples(:,1:3)+read_init_pos),ripples(:,4:5)];


