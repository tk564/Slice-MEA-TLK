function [grouped, alldata, forGP] = allrecdata(metric, output)

[xvals] = [3, 5, 7.5, 10];
genotypes = {'WT', 'LF', 'GF'};
ages = {'4-5', '12-13'};



refmatrix = reshape(1:length(genotypes)*length(ages), length(genotypes), length(ages));

data75 = zeros(length(genotypes)*length(ages), 16);
data10 = zeros(length(genotypes)*length(ages), 16);
data75_2 = data75';
data10_2 = data10';

% outputs will be as such
% WT 4-5
% NL-F 4-5
% NL-G-F 4-5
% WT 12-13
% NL-F 12-13
% NL-G-F 12-13

for i = 1:length(genotypes)*length(ages)
    [geno age] = find(i == refmatrix);
    genRef = genotypes{geno};
    ageRef = ages{age};

[a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, genRef, 'K', ageRef , 0, metric); % need to have manually preloaded output for this

data75(i, 1:length(c)) = c';
data10(i, 1:length(d)) = d';



ref75 = char(strcat(genRef, '_', ageRef(1), '_75'));
ref10 = char(strcat(genRef, '_', ageRef(1), '_10'));

grouped.(ref75) = c;
grouped.(ref10) = d;

end
alldata = [data75; data10];


refmatrix2 = [1 2; 3 4; 5 6];
forGP = zeros(16,length(genotypes)*length(ages));

for i = 1:6
      [geno age] = find(i == refmatrix2);
    genRef = genotypes{geno};
    ageRef = ages{age};
    [a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, genRef, 'K', ageRef , 0, metric); % need to have manually preloaded output for this

   
data75_2(1:length(c),i) = c;
data10_2(1:length(d),i) = d;
end

% which column in the dostats output does the number go in
% these are all the 7.5mM conditions


%p = [1 4 2 5 3 6]; % for grouping by age
p = [1 7 2 8 3 9]; % for grouping by conc

for i = 1:6
    pos = p(i);
    forGP(:,pos) = data75_2(:,i);
end

%p = [7 10 8 11 9 12]; % for grouping by age
p = [4 10 5 11 6 12];
for i = 1:6
    pos = p(i);
    forGP(:,pos) = data10_2(:,i);
end
forGP(find(forGP == 0)) = NaN;
forGP = num2cell(forGP);


end