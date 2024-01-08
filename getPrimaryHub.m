function [primaryHub, primaryArea] = getPrimaryHub(totConnectivity, ECns, DGns, CA3ns, CA1molecularens, CA1pyramidalens, CA1radiatumns, CA1oriensns, CA1ns, noCA1);

primaryArea = [];
primaryHub = find(totConnectivity == max(totConnectivity));
if length(primaryHub) > 1
    primaryHub = primaryHub(1);
end

if totConnectivity(primaryHub) == 0
    primaryHub = 0;
    primaryArea = 'NaN';

else
if nnz(primaryHub == ECns) == 1
    primaryArea = 'entorhinal cortex';
end

if nnz(primaryHub == DGns) == 1
    primaryArea = 'dentate gyrus';
end

if nnz(primaryHub == CA3ns) == 1
    primaryArea = 'CA3';
end

if nnz(primaryHub == CA1molecularens) == 1
    primaryArea = 'CA1 stratum moleculare';
end

if nnz(primaryHub == CA1pyramidalens) == 1
    primaryArea = 'CA1 stratum pyramidale';
end

if nnz(primaryHub == CA1radiatumns) == 1
    primaryArea = 'CA1 stratum radiatum';
end

if nnz(primaryHub == CA1oriensns) == 1
    primaryArea = 'CA1 stratum oriens';
end

if noCA1 == 4 && nnz(primaryHub == CA1ns) == 1
    primaryArea = 'CA1';
end

primaryArea = primaryArea;
end