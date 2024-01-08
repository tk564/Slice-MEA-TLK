function [a, controls, b, fivemM, c, sevenfivemM, d, tenmM] =  scrapeData(output, lineQ, conditionQ, ageQ, sideQ, metric);
% nomenclature - lineQ = line Query etc
backup = output;

ro=0;
% ro = 1; % remove outliers, set to 1 to remove outliers
% 
% if or(contains(metric, 'energy'), contains(metric, 'amp'))
%     ro = 0;
% end
%% firstly ignore all rows without proper data
nodata = zeros(size(output)); % set up index to be filled in
for f = 1:length(output) % for each recording in output
    if isempty(output(f).spikesTot_full) % checks if has any spikes
        nodata(f) = 1; % if no spikes notes it in the index
    end
end
output(find(nodata)) = []; % any rows without any spikes are removed from further analyses

%% if doing side-dependent analysis, ignore all from other side
if sideQ ~= 0
    wrongside = zeros(size(output));
    for f = 1:length(output)
        if ~strcmp(output(f).side, sideQ)
            wrongside(f) = 1;    
        end
    end
    output(find(wrongside)) = [];
end


%% remove wrong any of a different line

wrongline = zeros(size(output)); % set up index to be filled in
for f = 1:length(output) % for each recording in output
    if ~strcmp(lineQ, output(f).line) % checks if has any spikes
        wrongline(f) = 1; % if no spikes notes it in the index
    end
end
output(find(wrongline)) = []; % any rows without any spikes are removed from further analyses

%% remove any of wrong age
wrongage = zeros(size(output)); % set up index to be filled in
ageQ = str2double(strsplit(ageQ, '-')); % split the two possibilities into their own
for f = 1:length(output) % for each recording in output
    if ~or((ageQ(1) == output(f).age), (ageQ(2) == output(f).age))
        wrongage(f) = 1; % if no spikes notes it in the index
    end
end
output(find(wrongage)) = []; % any rows without any spikes are removed from further analyses


%% get the control data
controls = zeros(size(output));
for f = 1:length(output)
    ref = {'Control'};
    if contains(output(f).condition, ref)
        controls(f) = output(f).(metric);
    end
end

if sum(controls) ~= 0
    a = (nonzeros(controls));
    if ro == 1
    a = nonzeros(a.*~isoutlier(a));
    end
else
    a = NaN;
end

%% remove wrong any of different conditions
wrongcondition = zeros(size(output)); % set up index to be filled in
for f = 1:length(output) % for each recording in output
    if ~contains(output(f).condition,conditionQ)
        wrongcondition(f) = 1; % if no spikes notes it in the index
    end
end
output(find(wrongcondition)) = []; % any rows without any spikes are removed from further analyses

%% at this point 'output' should only contain the desired line, side if specificed, and only recordings with actual spikes in them



%% get conc dependent data (atm only bother for K)


fivemM = zeros(size(output));
for f = 1:length(output)
    conc = {'K+ 5mM'};
    if contains(output(f).condition, conc)
      fivemM(f) = output(f).(metric);
      

        
    end
end
if sum(fivemM) ~= 0
    b = (nonzeros(fivemM));
    if ro == 1
     b = nonzeros(b.*~isoutlier(b));
    end
else
    b = NaN;
end
%%


sevenfivemM = zeros(size(output));
for f = 1:length(output)
    conc = {'K+ 7.5mM'};
    if contains(output(f).condition, conc);
        sevenfivemM(f) = output(f).(metric);
    
    end
end
if sum(sevenfivemM) ~= 0
    c = (nonzeros(sevenfivemM));
    if ro ==1
     c = nonzeros(c.*~isoutlier(c));
    end
else
    c = NaN;
end



tenmM = zeros(size(output));
for f = 1:length(output)
    conc = {'K+ 10mM'};
    if contains(output(f).condition, conc);
        tenmM(f) = output(f).(metric);

    end
end
if sum(tenmM) ~= 0
    d = (nonzeros(tenmM));
    if ro ==1
     d = nonzeros(d.*~isoutlier(d));
    end
else
    d = NaN;
end








    