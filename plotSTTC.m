function [ECns, DGns, CA3ns, CA1oriensns, CA1pyramidalens, CA1radiatumns, CA1molecularens, CA1ns] = plotSTTC(ECs, DGs, CA3s, CA1orienss, CA1pyramidales, CA1radiatums, CA1moleculares, noCA1, CA1s)
% get the number of each
ECn = length(ECs);
if ECn == 0
    ECns = [];
else
ECns = [1:ECn];
end

DGn = length(DGs);
if DGn == 0
    DGns = [];
else

DGns = [ECn+1:ECn+DGn];
end

CA3n = length(CA3s);
if CA3n == 0
    CA3ns = [];
else
CA3ns = [ECn+DGn+1:ECn+DGn+CA3n];
end

CA1oriensn = length(CA1orienss);
if CA1oriensn == 0
    CA1oriensns = [];
else
CA1oriensns = [ECn+DGn+CA3n+1:ECn+DGn+CA3n+CA1oriensn];
end


CA1pyramidalen = length(CA1pyramidales);
if CA1pyramidalen == 0
    CA1pyramidalens = [];
else
CA1pyramidalens = [ECn+DGn+CA3n+CA1oriensn+1:ECn+DGn+CA3n+CA1oriensn+CA1pyramidalen];
end

CA1radiatumn = length(CA1radiatums);
if CA1radiatumn == 0
    CA1radiatumns = [];
else
CA1radiatumns = [ECn+DGn+CA3n+CA1oriensn+CA1pyramidalen+1:ECn+DGn+CA3n+CA1oriensn+CA1pyramidalen+CA1radiatumn];
end

CA1molecularen = length(CA1moleculares);
if CA1molecularen == 0
    CA1molecularens =[];
else
CA1molecularens = [ECn+DGn+CA3n+CA1oriensn+CA1pyramidalen+CA1radiatumn+1:ECn+DGn+CA3n+CA1oriensn+CA1pyramidalen+CA1radiatumn+CA1molecularen];
end



if noCA1 < 4
    CA1ns =[];
thetitle = {strcat('Entorhinal cortex electrodes:', " ", num2str(ECns)), ...
    strcat('Dentate gyrus electrodes:', " ", num2str(DGns)), ...
    strcat('CA3 electrodes:', " ", num2str(CA3ns)), ...
    strcat('CA1 stratum oriens electrodes:', " ", num2str(CA1oriensns)), ...
    strcat('CA1 stratum pyramidale electrodes:', " ", num2str(CA1pyramidalens)), ...
    strcat('CA1 stratum radiatum electrodes:', " ", num2str(CA1radiatumns)), ...
    strcat('CA1 stratum moleculare electrodes:', " ", num2str(CA1molecularens))};
 title(thetitle)

elseif noCA1 == 4 
    CA1n = length(CA1s);
if CA1n == 0
    CA1ns =[];
else
CA1ns = [ECn+DGn+CA3n+CA1oriensn+CA1pyramidalen+CA1radiatumn+CA1molecularen+1:ECn+DGn+CA3n+CA1oriensn+CA1pyramidalen+CA1radiatumn+CA1molecularen+CA1n];
end

thetitle = {strcat('Entorhinal cortex electrodes:', " ", num2str(ECns)), ...
    strcat('Dentate gyrus electrodes:', " ", num2str(DGns)), ...
    strcat('CA3 electrodes:', " ", num2str(CA3ns)), ...
    strcat('CA1 electrodes:', " ", num2str(CA1ns))};
 title(thetitle)

end
end