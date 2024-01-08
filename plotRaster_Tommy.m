function plotRaster_Tommy(TimeChanMatrix, timeInterval, file, f1, f2, data)
%% simply plots a raster

[slicepics, row] = rowForSlicepics(file);

figure('name', 'SpikeRaster');
TimeChanMatrix(:,1) = TimeChanMatrix(:,1)*timeInterval/1000;

%% create the colour matrix for different regions
colourMatrix = zeros(length(TimeChanMatrix),3);

% set colour for DG electrodes to red 1,0,0
if ~isempty(slicepics{row, 5})                     
                    DGs = str2num(slicepics{row,5});
                    for i = 1:length(TimeChanMatrix)
                        if nnz(TimeChanMatrix(i,2) == DGs) == 1
                            colourMatrix(i,:) = [1, 0, 0];
                        end
                    end
end

% set colour for CA3 electrodes to magenta

if ~isempty(slicepics{row, 6})                     
                    CA3s = str2num(slicepics{row,6});
                    for i = 1:length(TimeChanMatrix)
                        if nnz(TimeChanMatrix(i,2) == CA3s) == 1
                            colourMatrix(i,:) = [1, 0, 1];
                        end
                    end
end

% set colour for CA1 electrodes to blue

if ~isempty(slicepics{row, 7})                     
                    CA1s = str2num(slicepics{row,7});
                    for i = 1:length(TimeChanMatrix)
                        if nnz(TimeChanMatrix(i,2) == CA1s) == 1
                            colourMatrix(i,:) = [0, 0, 1];
                        end
                    end
end

% set colour for EC electrodes to green

if ~isempty(slicepics{row, 12})                     
                    ECs = str2num(slicepics{row,12});
                    for i = 1:length(TimeChanMatrix)
                        if nnz(TimeChanMatrix(i,2) == ECs) == 1
                            colourMatrix(i,:) = [0, 1, 0];
                        end
                    end
end







hold on
b = scatter(TimeChanMatrix(:,1), TimeChanMatrix(:,2), [], colourMatrix);


hold off
aesthetics

b.Marker = '.';




xlabel('Time from start of analysis (s)');
xlim([0 length(data)*timeInterval/1000]);
ylabel('Channel')

fileName = strcat(file.name(1:length(file.name)-4),'_spike_raster.png');

cd("RecFiles\")
saveas(gcf, fileName);
cd ../

close

end

