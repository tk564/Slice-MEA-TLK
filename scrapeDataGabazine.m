function [a, controls, ab, thirty, b, hundred, c, threehundred, d, onemicro] =  scrapeDataGabazine(output, lineQ, conditionQ, ageQ, sideQ, metric);
% nomenclature - lineQ = line Query etc
backup = output;
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

thirty = zeros(size(output));
for f = 1:length(output)
    conc = {'Gabazine 30nM'};
    if contains(output(f).condition, conc);
        thirty(f) = output(f).(metric);
 
    end
end
if sum(thirty) ~= 0
    ab = (nonzeros(thirty));
else
    ab = NaN;
end







hundred = zeros(size(output));
for f = 1:length(output)
    conc = {'Gabazine 100nM'};
    if contains(output(f).condition, conc);
        hundred(f) = output(f).(metric);
    
        
    end
end
if sum(hundred) ~= 0
    b = (nonzeros(hundred));
else
    b = NaN;
end



threehundred = zeros(size(output));
for f = 1:length(output)
    conc = {'Gabazine 300nM'};
    if contains(output(f).condition, conc);
        threehundred(f) = output(f).(metric);
 
    end
end
if sum(threehundred) ~= 0
    c = (nonzeros(threehundred));
else
    c = NaN;
end



onemicro = zeros(size(output));
for f = 1:length(output)
    conc = {'Gabazine 1uM'};
    if contains(output(f).condition, conc);
        onemicro(f) = output(f).(metric);
    
    end
end
if sum(onemicro) ~= 0
    d = (nonzeros(onemicro));
else
    d = NaN;
end







    