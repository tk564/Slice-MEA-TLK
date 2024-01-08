function filteredData = filterData_Tommy(frequencyRange, fs, data, sType)


    highpass = frequencyRange(1); % 1 taken from Palani's report (can do future analysis of SWRs hopefully with 0.1)
    lowpass = frequencyRange(2); % 200Hz as per Tanja, or 35 as per  Arnal-Real, 2021
    wn = [highpass lowpass] / (fs / 2); % Create the window to define the Butterworth function.
    filterOrder = 3; % A suitable order, could be increased but be cautious as this may result in excessive and irrelevant roll-off.
    [b, a] = butter(filterOrder, wn); % Defines the transfer function coefficients of the filter
%     filteredData = filtfilt(b, a, table2array(data)); % Filter data using a Butterworth Function.
    filteredData = filtfilt(b, a, data);

if strcmp(sType, 'mu')
    for i = [50, 100, 150, 200] %, 250, 300, 350, 400, 450, 500
     d = designfilt('bandstopiir','filterOrder',4, ... 
              'HalfPowerFrequency1',i-2,'HalfPowerFrequency2',i+2, ...
             'DesignMethod','butter','SampleRate',fs);
   filteredData = filtfilt(d, filteredData);
     end
  
end
end