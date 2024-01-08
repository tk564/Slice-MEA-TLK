

data = dataFile(:,electrode_to_plot+1); % selects only the channel being analysed to speed up

%%
[~, ~, filteredData, ~, ~] = detectSpikes_Tommy(data,method, multiplier);
finalData = filteredData;

spikeTrain = spikeMatrix(:,electrode_to_plot);
threshold = thresholds(electrode_to_plot);
      
    % get spike times and plot trace
   
    
    sp_times=find(spikeTrain(20001:length(spikeTrain))==1); % starts search at 20001 so no error selecting negative values
   
    figure
    n_spikes_to_plot = 50; % goal of 50 to plot but these population spikes much slower
    % correction if num spikes is fewer than desired number:
    if  sum(spikeTrain) < n_spikes_to_plot
        n_spikes_to_plot = length(sp_times);
    end
     all_trace = zeros(40001,n_spikes_to_plot); % make now to avoid error later
    
    for i=1:n_spikes_to_plot
        sp_peak_time = find(finalData(sp_times(i)-20000:sp_times(i)+20000) == min(finalData(sp_times(i)-20000:sp_times(i)+20000)));%note changed min to max as with filtered data spike is +ve
        %plot(finalData((sp_times(i))+sp_peak_time-25:(sp_times(i))+sp_peak_time+25));
        
        % added correction for if there is an early, such that spike time -
        % minus 25 samples is negative, it will not plot
        % or if any part of the trace to plot is above 50 or below -50, it
        % will exclude this trace from the plot and the average
        % calculation
        %if (sp_times(i))+sp_peak_time-10000 < 1 | ...
         %     ~isempty(find(...
          %      finalData((sp_times(i))+sp_peak_time-10000:(sp_times(i))+sp_peak_time+10000) > 20000)) | ...
           %     ~isempty(find(...
            %    finalData((sp_times(i))+sp_peak_time-10000:(sp_times(i))+sp_peak_time+10000) < -20000))
            % don't plot; don't add average, first line of array will be
            % excluded by MATLAB automatically
        
            [yvals] = finalData((sp_times(i))+sp_peak_time-40000:(sp_times(i))+sp_peak_time);
            %[xvals] = [1:40001]';
            plot(yvals, ...
               'Color',[0.5 0.5 0.5],'LineWidth',3); %all grey
            hold on
      
            all_trace(:,i)= finalData((sp_times(i))+sp_peak_time-40000:(sp_times(i))+sp_peak_time);
        
    end
    
    ave_trace=(sum(all_trace'))/(length(all_trace(1,:)));
    %plot(ave_trace,'LineWidth',8,'Color','w');
    %plot(ave_trace,'LineWidth',3,'Color','r');
    plot(ave_trace,'LineWidth',3,'Color','k'); %black line instead
    hold off
    aesthetics
    
    %change axes to voltage normalised
    %change x axis to time rather than samples
    xticks(linspace(0,40000,3));
    xticklabels([linspace(0,40000,3)/20000]-1);
    xlabel('time relative to peak (s)');
    
    %calibrate y axis
    nearestValue = 0.001; % i.e. nearest mutliple of 
    ymax = ceil(max(max(all_trace))/nearestValue)*nearestValue;
    ymin = ceil(min(min(all_trace))/nearestValue)*nearestValue;
    if  abs(ymax) >= abs(ymin)
        yval = abs(ymax);
    else
        yval = abs(ymin);
    end
    
    ylim([-yval yval])
    
    if      yval >= 300
        increment = 100;
    elseif  yval >= 100
        increment = 50;
    else
        increment = 25;     
    end
    
    yticks(linspace(-yval,yval,((2*yval)/increment)+1));
    ylabel('filtered signal (\muV)');
    set(gca,'fontsize',16)
    
    % plot the threshold if using threshold-based method
    if      strcmp(method,'Tommy') 
        threshvec = ones(1,40001)*threshold;
        hold on
        plot(threshvec,'LineStyle','--','Color','b','LineWidth',3)
        hold off
       
    else
    end
    
    %% sort title and save the figure    
    %make title font smaller
    ax = gca;
    ax.TitleFontSizeMultiplier = 0.7;