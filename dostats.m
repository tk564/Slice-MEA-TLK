function dostats(dep, boxplots)

folder = 'E:\Slice_MEA\';

 if nargin < 2, boxplots = false; end
significant = cell(1,1);

disp('config as of 20220401 is for grouping into ages')
dependent = dep;

if ~exist('ignoreChecks')
    ignoreChecks = 0;
end

%% load outputs
cd(folder)
cd .\OutputData

doc= dir('*mat');
dd = zeros(length(doc),1);
for j = 1:length(doc)
    dd(j) =doc(j).datenum;
end
[tmp i] = max(dd);
disp(doc(i).name)
file = load(doc(i).name);
output = file.output;

cd(folder)

pharmacology = {'K+', 'gabazine'};

%% get the data from all recordings into one matrix which can be sampled
% from rown 1:6 go from WT 4-5, NL-F 4-5, ... , NL-G-F 12-13
[grouped, alldata, forGP] = allrecdata(dep, output);

allDat = forGP;



%%
% first character w = wt, f = nlF, f = nlGf
% second character 4 = 4-5, 1 = 12-13
% third character 7 = 7.5mM 1 = 10mM

a.w47 = grouped.WT_4_75;
a.w41 = grouped.WT_4_10;
a.w17 = grouped.WT_1_75;
a.w11 = grouped.WT_1_10;

a.f47 = grouped.LF_4_75;
a.f41 = grouped.LF_4_10;
a.f17 = grouped.LF_1_75;
a.f11 = grouped.LF_1_10;

a.g47 = grouped.GF_4_75;
a.g41 = grouped.GF_4_10;
a.g17 = grouped.GF_1_75;
a.g11 = grouped.GF_1_10;


%% compare all minimum subgroups
samples = {'w47', 'w41', 'w17', 'w11', ...
    'f47', 'f41', 'f17', 'f11',...
    'g47', 'g41', 'g17', 'g11'};
% n for correction is actually only 4. e.g. w47 is compared to w17, w11,
% f47, and g47
[all_comp_p, all_comp_ref] = multTT2(a,samples); 
relevant = [1, 2, 4, 8, 13, 15, 19, 22, 25, 29, 34, 38, 39, 40, 42, 47, 49, 52, 55, 60, 61, 62, 65, 66];
all_comp_p = all_comp_p(relevant);
all_comp_p = fdr_BH(all_comp_p,0.05); % using this (find ref) instead of bonferroni at the latter kept making p values of 1 which just looks gross
all_comp_ref = all_comp_ref(relevant);

significant = [significant, all_comp_ref(all_comp_p < 0.05)];



%% compare whole genotypes


b.w = [a.w47; a.w17; a.w41; a.w11];
b.f = [a.f47; a.f17; a.f41; a.f11];
b.g = [a.g47; a.g17; a.g41; a.g11];

genrefs = {'w', 'f', 'g'}; % WT, nlF, and nlGf
% n for correction is 3

[gen_p, gen_ref] = multTT2(b,genrefs);
gen_p = fdr_BH(gen_p,0.05);

significant = [significant, gen_ref(gen_p < 0.05)];

%% compare whole ages
c.y = [a.w47; a.w41; a.f47; a.f41; a.g47; a.g41];
c.o = [a.w17; a.w11; a.f17; a.f11; a.g17; a.g11];

agerefs = {'y', 'o'}; % y = young = 4/5, o = old = 12/13 weeks
% correction irrelevant
[age_p, age_ref] = multTT2(c,agerefs);
% only 2 groups so no need for correction


significant = [significant, age_ref(age_p < 0.05)];


%% compare whole concentrations
d.sf = [a.w47; a.w17; a.f47; a.f17; a.g47; a.g17];
d.t = [a.w41; a.w11; a.f41; a.f11; a.g41; a.g11];
concrefs = {'sf', 't'}; % sf = 7.5mM, t = 10mM
[conc_p, conc_ref] = multTT2(d,concrefs);


significant = [significant, conc_ref(conc_p < 0.05)];
% only 2 groups so no need for correction

%% compare gen*age

e.w4 = [a.w47; a.w41];
e.w1 = [a.w17; a.w11];

e.f4 = [a.f47; a.f41];
e.f1 = [a.f17; a.f11];

e.g4 = [a.g47; a.g41];
e.g1 = [a.g17; a.g11];

ga_refs = {'w4', 'w1', 'f4', 'f1', 'g4', 'g1'};
% correction should use n = 15?
[ga_p, ga_ref] = multTT2(e,ga_refs);

relevant = [1,2,4,7,9,10,11,14,15];
ga_p = ga_p(relevant);
ga_p = fdr_BH(ga_p,0.05);
ga_ref = ga_ref(relevant);


significant = [significant, ga_ref(ga_p < 0.05)];



%% compare gen*conc

f.w07 = [a.w47; a.w17];
f.w01 = [a.w41; a.w11];

f.f07 = [a.f47; a.f17];
f.f01 = [a.f41; a.f11];

f.g07 = [a.g47; a.g17];
f.g01 = [a.g41; a.g11];

gc_refs = {'w07', 'w01', 'f07', 'f01', 'g07', 'g01'};
% correction should use n=15? depends what do i guess
[gc_p, gc_ref] = multTT2(f,gc_refs);
relevant = [1,2,4,7,9,10,11,14,15];
gc_p = gc_p(relevant);
gc_p = fdr_BH(gc_p,0.05);
gc_ref = gc_ref(relevant);

significant = [significant, gc_ref(gc_p < 0.05)];


%% compare age*conc
% a here means any
g.a47 = [a.w47; a.f47; a.g47];
g.a41 = [a.w41; a.f41; a.g41];

g.a17 = [a.w17; a.f17; a.g17];
g.a11 = [a.w11; a.f11; a.g11];

ac_refs = {'a47', 'a41', 'a17', 'a11'};
% correction should use n = 6?
[ac_p, ac_ref] = multTT2(g,ac_refs);
relevant = [1,2,5,6];
ac_p = ac_p(relevant);
ac_p = fdr_BH(ac_p,0.05);
ac_ref = ac_ref(relevant);


significant = [significant, ac_ref(ac_p < 0.05)];





%% do boxplots
if boxplots

    data = alldata;
meta = load('metaForStats.mat');
concsR = meta.concs;
genotypesR = meta.genotypes;
agesR = meta.ages; % loads references to get the meta of each sample from


    modified75 = 0;
    conc75 = {'0'};
    genotype75 = {'0'};
    age75 = {'0'};   % sets up to be added to

    for i = 1:6
        n = length(nonzeros(data(i,:)));
        modified75 = [modified75; nonzeros(data(i,:))]; % concatenates all the recording values
        
        for j = 1:n
            addconc = concsR{i};
            conc75 = [conc75; addconc]; % adds on the necessary metadata with length corresponding to number of samples in each
            
            addgenotype = genotypesR{i};
            genotype75 = [genotype75; addgenotype];

            addage = agesR{i};
            age75 = [age75; addage];
        end

    end
    
    modified75(1) = [];
    conc75(1) = [];
    genotype75(1) = [];
    age75(1) = [];
 

      modified10 = 0;
    conc10 = {'0'};
    genotype10 = {'0'};
    age10 = {'0'};   % sets up to be added to

    for i = 7:12
        n = length(nonzeros(data(i,:)));
        modified10 = [modified10; nonzeros(data(i,:))]; % concatenates all the recording values
        
        for j = 1:n
            addconc = concsR{i};
            conc10 = [conc10; addconc]; % adds on the necessary metadata with length corresponding to number of samples in each
            
            addgenotype = genotypesR{i};
            genotype10 = [genotype10; addgenotype];

            addage = agesR{i};
            age10 = [age10; addage];
        end

    end
    
    modified10(1) = [];
    conc10(1) = [];
    genotype10(1) = [];
    age10(1) = [];

    %%
combinedData = [modified75; modified10];
cConcs = [conc75; conc10];
cGen = [genotype75;genotype10];
cAge = [age75;age10];
%%

disp(strcat('Max value is', " ", num2str(max(combinedData))))
dbstop in dostats at 209

%% general values

% dep = SET ME;
% ymax = SET ME;
% tickinterval = SET ME;
% unit = SET ME





clabel = {'7.5 mM', '10 mM'};
glabel = {'WT', '{\it App}^{NL-F}', '{\it App}^{NL-G-F}'};
alabel = {'4 - 5', '12 - 13'};


% 
s = get(0, 'ScreenSize');
s = [s(3)*0.1 s(4)*0.1 s(3)*0.8 s(4)*0.8];

%%
concbox = figure('Position', s);
concbox = boxplot(combinedData,cConcs, 'Labels', clabel);
hold on
cax = gca;
title({strcat('Comparison of', " ", dep, " ",  'of Interictal Spikes'), 'for Different aCSF Concentrations of [K^+]'})
ylabel({dep, strcat('of Interictal Spikes', " (", unit, ')' )});
xlabel('[K^+] of aCSF (mM)');
boxplotAesthetics(ymax,concbox,tickinterval,cax);

cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy\Stats Outputs')
saveas(gca, strcat(dep, '_conc_boxplot'))
cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy')

hold off

%%
genbox = figure('Position', s);
genbox = boxplot(combinedData,cGen, 'Labels', glabel);
hold on
gax = gca;
title({strcat('Comparisons of', " ", dep, " ",  'of Interictal Spikes'), 'for Different Genotypes'})

ylabel({dep, strcat('of Interictal Spikes', " (", unit, ')' )});
xlabel('Genotype of Slice');
boxplotAesthetics(ymax,genbox,tickinterval,gax);
set(gax,'TickLabelInterpreter', 'tex')


cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy\Stats Outputs')
saveas(gca, strcat(dep, '_geno_boxplot'))
cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy')

hold off



%%
agebox = figure('Position', s);
agebox = boxplot(combinedData,cAge, 'Labels', alabel);
hold on
aax = gca;
title({strcat('Comparisons of', " ", dep, " ",  'of Interictal Spikes'), 'for Different Ages'})
ylabel({dep, strcat('of Interictal Spikes', " (", unit, ')' )});
xlabel('Age of Slice (weeks)')
boxplotAesthetics(ymax,agebox,tickinterval,aax);


cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy\Stats Outputs')
saveas(gca, strcat(dep, '_age_boxplot'))
cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy')


hold off
else
   concbox = 0;
    agebox = 0;
    genbox = 0;
end

%% save
%heatmap(all_group_ps,'Colormap', plasma);
note = {'This contains the p values from ttest2 with unequal variances with a Benjamini-Hochberg correction of the FDR'};

filename = strcat(dep, '_stats.mat');


cd(folder)
cd .\StatsOutputs

save(strcat(dep,'_all_data.mat'), 'allDat');
save('___.mat', 'allDat');

save(filename, 'all_comp_p', 'all_comp_ref', 'gen_p', 'gen_ref', 'age_p', 'age_ref','conc_p', 'conc_ref', ...
    'ga_p', 'ga_ref', 'gc_p', 'gc_ref', 'ac_p','ac_ref', 'note', 'significant');

cd(folder)



end







