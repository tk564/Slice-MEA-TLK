function getAdjacencies



%  {'DG', 'CA1 oriens', 'CA1 pyramidale', 'CA1 radiatum', 'CA1 moleculare', 'CA3', 'EC'}
% read as row to column

L = length(allMatrix);

from = [];
for i = 1:L
    add = [1:L];
    from = [from; add'];
end


to = [];
for i = 1:L
    to = [to; ones(L,1)*i];
end

combined = [from, to, allMatrix(:)];
   