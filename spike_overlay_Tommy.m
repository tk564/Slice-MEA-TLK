%% plot filtered trace of spikes overlaid and peaks aligned
function spike_overlay_Tommy(file, method, ~, ~, fs, finalData, data, thresholds, f1, f2, spikeMatrix, sType)
% set chosen time windows, position 1 is in s, pos 2 and 3 are in ms
%time_wins           = [60 100 30];
option = {'spikiest'};
finalData = finalData*1000; % convert to uV for plots
thresholds = thresholds*1000;

if strcmp(sType, 'mu')
fs = 1000;
plotrange = 250;
yinterval = 50;
elseif strcmp(sType,'su')
    fs = 10000;
    plotrange = 20;
    yinterval=10;
else
    fs = 1000;
    plotrange = 250;
    yinterval = 50;
end
%% load data


spikeFile = dir(strcat(file.name(1:length(file.name))));

    spikeMatrix = full(data);
    if strcmp(option,'spikiest')
        %find channel index of spikiest
        electrode_to_plot   = find( sum(spikeMatrix(fs+1:length(data)-fs+1,:)) == max(sum(spikeMatrix(fs+1:length(data)-fs+1,:)))); % again checks for spikiest, but in the plottable window
    
        %correction if it's a draw (i.e. >1 electrodes has max no. spikes)
        if  length(electrode_to_plot)>1
            electrode_to_plot = electrode_to_plot(1);
        end

    else
        disp('cannot identify plotting option')
    end


    
     

if nnz(spikeMatrix(fs+1:length(data)-fs+1,electrode_to_plot)) > 0 % checks to avoid error if 0, and checks in window in case there is a spike but only outside of the plottable region        
    %elseif strcmp(option,'diagonal')
     %   electrode_to_plot = [find(channels == 22),find(channels == 64),find(channels == 78),...
      %      find(channels == 37)];
 
                %% check if already done
    if exist(strcat(file.name(1:end-4), '_', num2str(f1), '-', num2str(f2), '_', '*' , '_spike_overlay.png'))
       disp('already done')
    else %create plot if not already done:
    
    % load raw data / get filtered data to plot
    % raw_dat_fileName = file.name;
    % 
    % close all
    %             
    % dataFile = load(raw_dat_fileName); % loads the data, must be called data as variable name for detectSpikes
    % dataFile = dataFile.recording_data; % selects the data table, kept as table not array as converted downstream
    % data = dataFile(:,electrode_to_plot+1); % selects only the channel being analysed to speed up
    % data = table2array(data);
    % data = downsample(data, 20);
    
    
    %%
    
    
    % [~, ~, filteredData, threshold, ~, ~] = detectSpikes_Tommy(data,method, multiplier, fs);
    % finalData = filteredData;
    
    
    spikeTrain = data(:, electrode_to_plot);
    threshold = thresholds(electrode_to_plot);
    finalData = finalData(:,electrode_to_plot);
          
        % get spike times and plot trace
       
        
        sp_times=find(spikeTrain(fs+1:(length(spikeTrain))-fs+1)==1)+fs; % starts search at 20001 so no error selecting negative values, then adds on 20000 so still correct number from start
        

        figure
        n_spikes_to_plot = length(sp_times); 
        if n_spikes_to_plot > 50
            n_spikes_to_plot = 50;
        end
        % correction if num spikes is fewer than desired number:
 
         all_trace = zeros(plotrange*2+1,n_spikes_to_plot); % make now to avoid error later
        
        for i=1:n_spikes_to_plot
            if finalData(sp_times(i)) > 0
            
            
          
               
                [yvals] = finalData((sp_times(i))-plotrange:(sp_times(i)+plotrange));
               
                plot(yvals, ...
                   'Color',[0.5 0.5 0.5],'LineWidth',1); %all grey
                hold on
          
                all_trace(:,i)= finalData((sp_times(i))-plotrange:(sp_times(i)+plotrange));
            end 
            
        end
        
        ave_trace=(sum(all_trace'))/(length(all_trace(1,:)));
        %plot(ave_trace,'LineWidth',8,'Color','w');
        %plot(ave_trace,'LineWidth',3,'Color','r');
        plot(ave_trace,'LineWidth',3,'Color','k'); %black line instead
        hold off
        aesthetics
        
        %change axes to voltage normalised
        %change x axis to time rather than samples
        xticks(linspace(0,2*(plotrange),3));

        if strcmp(sType, 'mu')
             xticklabels((([linspace(0,2*(250),3)/(250)]/4-1/4)*fs));
        elseif strcmp(sType, 'su')
             xticklabels([-2, 0, 2]);
        end
        xlabel('time relative to peak (ms)');
        title({'Spike Overlay of All', 'Traces from One Channel'});

      
%% get the max amp for y scale


maxamp = ceil(max(max((all_trace)))/yinterval)*yinterval;

%%
        yval = maxamp; % standard set for all, 200 = 200uV
        if strcmp(sType,'mu')
        ylim([-yval/4 yval])
        elseif strcmp(sType,'su')
            ylim([-yval yval])
        end
        if      yval >= 6*yinterval
            increment = 2*yinterval;
        elseif  yval >= 2*yinterval
            increment = yinterval;
        else
            increment = 2.5*yinterval;     
        end
        
        yticks(linspace(-yval,yval,((2*yval)/increment)+1));
        ylabel('filtered signal (\muV)');
        set(gca,'fontsize',24)
        
        % plot the threshold if using threshold-based method
        if      strcmp(method,'Tommy') 
            threshvec = ones(1,2*plotrange+1)*threshold;
            hold on
            plot(threshvec,'LineStyle','--','Color','b','LineWidth',3)
            hold off
           
        else
        end
        
        %% sort title and save the figure    
        %make title font smaller
        ax = gca;
        ax.TitleFontSizeMultiplier = 0.7;
    
        disp('saving plot...')
    
        cd("RecFiles\")
        saveas(gcf, strcat(file.name(1:length(file.name)-4), '_channel_' , int2str(electrode_to_plot), '_spike_overlay.png'))
        cd ../
    end    
    
    close all
    
    if exist(strcat(file.name(1:end-4), '*' , '_detected_spikes.png'))
       disp('already done')
    else %create plot if not already done:
    
    voltage = finalData;
    %voltage = min(0,voltage); % can set so only negative values detected
    time = (1:length(finalData))';
    
    figure
    plot(time, voltage, ...
        'Color',[0.5 0.5 0.5],'LineWidth',0.1)
    
    hold on
    
    height = threshold/3;
    spikeTrainPlot = spikeMatrix(:,electrode_to_plot) * height;
    plot(spikeTrainPlot, ...
        'Color','r')
    
    hold on
    
    threshvec2 = ones(length(finalData),1)*threshold;
    plot(threshvec2,'--b','LineWidth',3)
    
    hold off
    
    aesthetics
    
    %change axes to voltage normalised
        %change x axis to time rather than samples
        xticks(linspace(0,ceil(length(finalData)),10));
        xticklabels(ceil( [linspace(0,ceil(length(finalData)),10)/fs]/60 )*60);
        xlabel('time (s)');
        
        %calibrate y axis
        nearestValue = 0.001; % i.e. nearest mutliple of 
%         ymax = ceil(max(max(finalData))/nearestValue)*nearestValue;
%         ymin = ceil(min(min(finalData))/nearestValue)*nearestValue;
%         if  abs(ymax) >= abs(ymin)
%             yval = abs(ymax);
%         else
%             yval = abs(ymin);
%         end
        yval = maxamp; % standard
        ylim([-yval/4 yval])
        
        if      yval >= 300
            increment = 100;
        elseif  yval >= 100
            increment = 50;
        else
            increment = 25;     
        end
        
        yticks(linspace(-yval,yval,((2*yval)/increment)+1));
        ylabel('filtered signal (\muV)');
        set(gca,'fontsize',24)
        
        %make title font smaller
        ax = gca;
        ax.TitleFontSizeMultiplier = 0.7;
        title({'Filtered Data for One Channel', 'Showing Every Detected Spike'})
    
        cd("RecFiles\")
        saveas(gcf, strcat(file.name(1:length(file.name)-4), '_channel_' , int2str(electrode_to_plot), '_detected_spikes.png'))
        cd ../

        close all
    end    
    
    

else
disp('no plottable spikes')
end
end    