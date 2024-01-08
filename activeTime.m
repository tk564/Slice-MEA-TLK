function time_A = activeTime(N1v, dtv, startv, endv, spike_times_1)
        dt = dtv; 
        start = startv; 
        endvv = endv; % end is not a valid variable name in MATLAB 
        tempN = N1v; % changed N1 into tempN as nested function variables are declared
        % globally. This is problematic when N1v and N2v are different
        % values
        
        % maximum
        time_A = 2 * tempN * dt; 
        
        % if just one spike in train 
        if tempN == 1
            
            if spike_times_1(1) - start < dt 
                time_A = time_A - start + spike_times_1(1) - dt; 
            elseif spike_times_1(1) + dt > endvv 
                time_A = time_A - spike_times_1(1) - dt + endvv; 
            end
        
            % if more than one spike in train 
        else 
            i = 1; % added by TS
            while i < tempN % switched from N1 - 1, to take account of 1 indexing
            
                diff = spike_times_1(i+1) - spike_times_1(i); 
                
                if diff < 2 * dt 
                    % subtract overlap 
                    time_A = time_A -2 * dt + diff; 
                end 
                 
                i = i + 1; 
            end 
            
            % check if spikes are within dt of the start and/or end, if so
            % just need to subtract overlap of first and/or last spike as
            % all within-train overlaps have been accounted for 
            
            if spike_times_1(1) - start < dt 
                time_A = time_A - start + spike_times_1(1) - dt; 
            end 
            
            if endvv - spike_times_1(tempN) < dt % switched from N1 - 1 to N1 to for 1 indexing
                time_A = time_A - spike_times_1(tempN) - dt + endvv; 
            end 
       
            
        end 
                
    
        
    end 
