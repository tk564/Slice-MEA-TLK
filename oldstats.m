function oldstats
% just for reference
data = [data75; data10]; % combines the 75 and 10 mM datasets


checkStats = checkNormAndVariance(data);

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
 

if or(nnz(checkStats(1:12,1)) == 12, ignoreChecks == 1) % if in current state then only needs to be normal, for homowhatever too change to 1:12,2 and 24
%     % means that normality met for each sample and homoscedascicity between
%     % them also met    
%     g1 = conc75;
%     g2 = genotype75;
%     g3 = age75;
% 
%    [p75,t75,stats75,terms] = anovan(modified75,{g2 g3},'model','interaction','varnames',{'g2','g3'});
%    [c,m,h,gnames] = multcompare(stats75); 
% end
% 
% if nnz(checkStats(7:12,:)) == 12
%     % means that normality met for each sample and homoscedascicity between
%     % them also met    
%     g1 = conc10;
%     g2 = genotype10;
%     g3 = age10;
% 
%    [p10,t10,stats10,terms] = anovan(modified10,{g2 g3},'interaction');
%    [c,m,h,gnames] = multcompare(stats10, 'Dimension',1:2); 

modified = [modified75; modified10];
conc = [conc75; conc10];
genotype = [genotype75; genotype10];
age = [age75; age10];

g1 = conc;
g2 = genotype;
g3 = age;

cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy\Stats Outputs');
[p, t, stats, terms] = anovan(modified, {g1 g2 g3}, 'model' ,'interaction', "Varnames",["g1","g2","g3"], 'display', 'off');
close

fileRef = strcat('multcompare-', dep, '-');
save(strcat(fileRef, 'anova3'), "t");

[c, m, h, gnames] = multcompare(stats, 'Dimension', 1);
save(strcat(fileRef, 'C'), "h"); 

[c, m, h, gnames] = multcompare(stats, 'Dimension', 2);
save(strcat(fileRef, 'G'), "h");

[c, m, h, gnames] = multcompare(stats, 'Dimension', 3);
save(strcat(fileRef, 'A'), "h");

[c, m, h, gnames] = multcompare(stats, 'Dimension', [1,2]);
save(strcat(fileRef, 'CxG'), "h");

[c, m, h, gnames] = multcompare(stats, 'Dimension', [1,3]);
save(strcat(fileRef, 'CxA'), "h");

[c, m, h, gnames] = multcompare(stats, 'Dimension', [2,3]);
save(strcat(fileRef, 'GxA'), 'h');

[c, m, h, gnames] = multcompare(stats, 'Dimension', [1 2 3]);
save(strcat(fileRef, 'CxGxA'), 'h');
cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy');
close

else
    disp(strcat('Normality AND homoscedasticity not both met for', " ", dep))
    disp('Doing Wilcoxon Rank Sum instead')
    
    Wilcoxon = zeros(size(data,1), size(data,1));

    for i = 1:size(Wilcoxon,1)

        for j = 1:size(Wilcoxon,2)

            x = nonzeros(data(i,:));
            y = nonzeros(data(j,:));
            [p, h, stats] = ranksum(x,y);

            Wilcoxon(i,j) = p;
        end
    end
    % in this we perform 66 real tests (each of the 12 sample sets compared
    % to the 11 others = 132, but a:b = b:a so half this to 66
    % thus perform bonferroni correction of
   % a = 0.05 / 66;
    a = 0.05; % do i NEED to do the above?
    WilcoxonSignificant = Wilcoxon < a;

    groups = {'WT, 4-5 weeks, 7.5 mM', 'NL-F, 4-5 weeks, 7.5 mM','NL-G-F, 4-5 weeks, 7.5 mM','WT, 12-13 weeks, 7.5 mM','NL-F, 12-13 weeks, 7.5 mM','NL-G-F, 12-13 weeks, 7.5 mM',...
            'WT, 4-5 weeks, 10 mM', 'NL-F, 4-5 weeks, 10 mM','NL-G-F, 4-5 weeks, 10 mM','WT, 12-13 weeks, 10 mM','NL-F, 12-13 weeks, 10 mM','NL-G-F, 12-13 weeks, 10 mM'};
% 
% 
% cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy\Stats Outputs');
%     fileRef = strcat('Wilcoxon-', dep);
% 
%     Wilcoxon = array2table(Wilcoxon, 'VariableNames', groups, 'RowNames', groups');
%     WilcoxonSignificant = array2table(WilcoxonSignificant, 'VariableNames', groups, 'RowNames', groups');
% 
%     save(fileRef, 'Wilcoxon', 'WilcoxonSignificant');
%     cd('C:\Users\tommy\OneDrive\Documents\Scripts and Data for Tommy\Tommy');
% end

