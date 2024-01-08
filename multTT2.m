function [pvals, refs] =  multTT2(a,samples)

% a is a struct of all the grouped samples where a.x is one group
% samples is a list of group names where x = 'group' in samples



% all_group_ps = zeros(length(samples), length(samples));
n = length(samples);
L=0;
for i = 1:n-1
    L = L+i;
end

pvals = zeros(1,L);
refs = cell(1,L);

nth = 0;
for i = 1:length(samples)-1
    for j = i+1:length(samples)
        nth = nth+1;

        x = a.(samples{i});
        y = a.(samples{j});
        [h,p,ci,stats] = ttest2(x,y,'Vartype','unequal');

       pvals(nth) = p;
       refs(nth) = {strcat(samples{i},'_',samples{j})};
    end
end