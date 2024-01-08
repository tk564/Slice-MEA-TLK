function plotAgainstConc(dependent, output)

% if plotting against concentration then the dependent variable could be
% NB use K for K, 4-5 or 12-13 for ages, LF and GF for NL-F and NL-GF
% respectively

sid = 0;
metric = dependent;

figure;

hold on
aesthetics

[maxy] = zeros(1,6);

al = 6.5;
om = 11;
xlim([al om]);
xticks(linspace(7.5, 10, 2));
xticklabels(linspace(7.5, 10, 2));
xlabel('[K^+] of modified aCSF (mM)');



title(strcat('Inter-ictal spike', {' '}, metric, {' '} , 'against aCSF [K+]'), 'interpreter', 'none')

lgd = legend('Location', 'northwest');
lgd.FontSize = 12;

%% plot group 1 / WT 5w

[xvals] = [7.5, 10];
[a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, 'WT', 'K', '4-5' , sid, metric); % need to have manually preloaded output for this
SEM = zeros(1,4);

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
    Na = 0;
    SEM(1) = 0;
else
    Na = length(a);
    SEM(1) = std( a ) / sqrt( Na );
end

if isnan(b)
    b = 0;
    Nb = 0;
    SEM(2) = 0;
else
    Nb = length(b);
    SEM(2) = std( b ) / sqrt( Nb );
end
if isnan(c)
    c=0;
    Nc = 0;
    SEM(3) = 0;

else

    Nc = length(c);
    SEM(3) = std( c ) / sqrt( Nc);
end
if isnan(d)
    xvals(length(xvals)) = NaN;
    Nd = 0;
    SEM(4) = 0; % change me to a 0 once we have data - just avoiding an error

else

    Nd = length(d);
    SEM(4) = std( d ) / sqrt( Nd );
end

[x1] = xvals(~isnan(xvals));
[mean_y] = [mean(c) mean(d)];
maxy(1) = max(mean_y);
[y1] = mean_y(~isnan(mean_y));


SEM = SEM(3:4);

% legLabel = strcat('WT 4-5w N =', " ", num2str(Na), ',', " ", num2str(Nb), ','," ", num2str(Nc), ',' , " ", num2str(Nd));
legLabel = strcat('WT 4-5w N =', " ", num2str(Nc), ',' , " ", num2str(Nd));

errorbar(x1, y1, SEM, '--*', 'color', [0 1 0] , 'linewidth', 2, 'DisplayName',legLabel);





%% plot group 2 / NL-F 5w

% [a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, 'LF', 'K', '4-5' , sid, metric); % need to have manually preloaded output for this
% 
% SEM = zeros(1,4);
% 
% if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
%     a = 0;
%     Na = 0;
%     SEM(1) = 0;
% else
%     Na = length(a);
%     SEM(1) = std( a ) / sqrt( Na );
% end
% 
% if isnan(b)
%     b = 0;
%     Nb = 0;
%     SEM(2) = 0;
% else
%     Nb = length(b);
%     SEM(2) = std( b ) / sqrt( Nb );
% end
% if isnan(c)
%     c=0;
%     Nc = 0;
%     SEM(3) = 0;
% 
% else
% 
%     Nc = length(c);
%     SEM(3) = std( c ) / sqrt( Nc);
% end
% if isnan(d)
%     xvals(length(xvals)) = NaN;
%     Nd = 0;
%      SEM(4) = []; % change me to a 0 once we have data - just avoiding an error
% else
% 
%     Nd = length(d);
%     SEM(4) = std( d ) / sqrt( Nd );
% end
% 
% [x2] = xvals(~isnan(xvals));
% [mean_y] = [mean(c) mean(d)];
% maxy(2) = max(mean_y);
% [y2] = mean_y(~isnan(mean_y));
% 
% SEM = SEM(3:4);
% 
% % legLabel = strcat('NL-F 4-5w N =', " ", num2str(Na), ',', " ", num2str(Nb), ','," ", num2str(Nc), ',' , " ", num2str(Nd));
% legLabel = strcat('NL-F 4-5w N =', " ", num2str(Nc), ',' , " ", num2str(Nd));
% errorbar(x2, y2, SEM,'--*', 'color', [0 1 1], 'linewidth', 2, 'DisplayName',legLabel);


%% plot group 3 / NL-G-F 5w

[a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, 'GF', 'K', '4-5' , sid, metric); % need to have manually preloaded output for this

SEM = zeros(1,4);

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
    Na = 0;
    SEM(1) = 0;
else
    Na = length(a);
    SEM(1) = std( a ) / sqrt( Na );
end

if isnan(b)
    b = 0;
    Nb = 0;
    SEM(2) = 0;
else
    Nb = length(b);
    SEM(2) = std( b ) / sqrt( Nb );
end
if isnan(c)
    c=0;
    Nc = 0;
    SEM(3) = 0;

else

    Nc = length(c);
    SEM(3) = std( c ) / sqrt( Nc);
end
if isnan(d)
    xvals(length(xvals)) = NaN;
    Nd = 0;
     SEM(4) = []; % change me to a 0 once we have data - just avoiding an error

else

    Nd = length(d);
    SEM(4) = std( d ) / sqrt( Nd );
end

[x3] = xvals(~isnan(xvals));
[mean_y] = [mean(c) mean(d)];
maxy(3) = max(mean_y);
[y3] = mean_y(~isnan(mean_y));


SEM = SEM(3:4);
% legLabel = strcat('NL-G-F 4-5w N =', " ", num2str(Na), ',', " ", num2str(Nb), ','," ", num2str(Nc), ',' , " ", num2str(Nd));
legLabel = strcat('NL-G-F 4-5w N =', " ", num2str(Nc), ',' , " ", num2str(Nd));
errorbar(x3, y3, SEM,'--*', 'color', [1 0 0], 'linewidth', 2, 'DisplayName',legLabel);

%% plot group 4 / WT 12w

[a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, 'WT', 'K', '12-13' , sid, metric); % need to have manually preloaded output for this

SEM = zeros(1,4);

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
    Na = 0;
    SEM(1) = 0;
else
    Na = length(a);
    SEM(1) = std( a ) / sqrt( Na );
end

if isnan(b)
    b = 0;
    Nb = 0;
    SEM(2) = 0;
else
    Nb = length(b);
    SEM(2) = std( b ) / sqrt( Nb );
end
if isnan(c)
    c=0;
    Nc = 0;
    SEM(3) = 0;

else

    Nc = length(c);
    SEM(3) = std( c ) / sqrt( Nc);
end
if isnan(d)
    xvals(length(xvals)) = NaN;
    Nd = 0;
     SEM(4) = []; % change me to a 0 once we have data - just avoiding an error
else

    Nd = length(d);
    SEM(4) = std( d ) / sqrt( Nd );
end

[x4] = xvals(~isnan(xvals));
[mean_y] = [mean(c) mean(d)];
maxy(4) = max(mean_y);
[y4] = mean_y(~isnan(mean_y));

SEM = SEM(3:4);
% legLabel = strcat('WT 12-13w N =', " ", num2str(Na), ',', " ", num2str(Nb), ','," ", num2str(Nc), ',' , " ", num2str(Nd));
legLabel = strcat('WT 12-13w N =', " ", num2str(Nc), ',' , " ", num2str(Nd));
errorbar(x4, y4, SEM,'--*', 'color',[0 0.6 0] , 'linewidth', 2, 'DisplayName',legLabel);

% %% plot group 5 / NL-F 12w
% 
% [a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, 'LF', 'K', '12-13' , sid, metric); % need to have manually preloaded output for this
% 
% SEM = zeros(1,4);
% 
% if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
%     a = 0;
%     Na = 0;
%     SEM(1) = 0;
% else
%     Na = length(a);
%     SEM(1) = std( a ) / sqrt( Na );
% end
% 
% if isnan(b)
%     b = 0;
%     Nb = 0;
%     SEM(2) = 0;
% else
%     Nb = length(b);
%     SEM(2) = std( b ) / sqrt( Nb );
% end
% if isnan(c)
%     c=0;
%     Nc = 0;
%     SEM(3) = 0;
% 
% else
% 
%     Nc = length(c);
%     SEM(3) = std( c ) / sqrt( Nc);
% end
% if isnan(d)
%     xvals(length(xvals)) = NaN;
%     Nd = 0;
%     SEM(4) = []; % change me to a 0 once we have data - just avoiding an error
% 
% else
% 
%     Nd = length(d);
%     SEM(4) = std( d ) / sqrt( Nd );
% end
% 
% 
% [x5] = xvals(~isnan(xvals));
% [mean_y] = [mean(c) mean(d)];
% maxy(5) = max(mean_y);
% [y5] = mean_y(~isnan(mean_y));
% 
% 
% SEM = SEM(3:4);
% % legLabel = strcat('NL-F 12-13w N =', " ", num2str(Na), ',', " ", num2str(Nb), ','," ", num2str(Nc), ',' , " ", num2str(Nd));
% legLabel = strcat('NL-F 12-13w N =', " ", num2str(Nc), ',' , " ", num2str(Nd));
% errorbar(x5, y5, SEM, '--*','color',[0 0.39 1] , 'linewidth', 2, 'DisplayName',legLabel);

%% plot group 6 / NL-G-F 12-13w



[a, controls, b, fivemM, c, sevenfivemM, d, tenmM] = scrapeData(output, 'GF', 'K', '12-13' , sid, metric); % need to have manually preloaded output for this

SEM = zeros(1,4);

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
    Na = 0;
    SEM(1) = 0;
else
    Na = length(a);
    SEM(1) = std( a ) / sqrt( Na );
end

if isnan(b)
    b = 0;
    Nb = 0;
    SEM(2) = 0;
else
    Nb = length(b);
    SEM(2) = std( b ) / sqrt( Nb );
end
if isnan(c)
    c=0;
    Nc = 0;
    SEM(3) = 0;

else

    Nc = length(c);
    SEM(3) = std( c ) / sqrt( Nc);
end
if isnan(d)
    xvals(length(xvals)) = NaN;
    Nd = 0;
    SEM(4) = 0;

else

    Nd = length(d);
    SEM(4) = std( d ) / sqrt( Nd );
end

[x6] = xvals(~isnan(xvals));
[mean_y] = [mean(c) mean(d)];
maxy(6) = max(mean_y);
[y6] = mean_y(~isnan(mean_y));

SEM = SEM(3:4);
% legLabel = strcat('NL-G-F 12-13w N =', " ", num2str(Na), ',', " ", num2str(Nb), ','," ", num2str(Nc), ',' , " ", num2str(Nd));
legLabel = strcat('NL-G-F 12-13w N =', " ", num2str(Nc), ',' , " ", num2str(Nd));
errorbar(x6, y6, SEM, '--*', 'color', [0.9 0.5 0], 'linewidth', 2, 'DisplayName',legLabel);

%% set y axis
ymax = max(maxy);
if length(ymax) > 1
    ymax = ymax(1); % avoids error in case 2 of same length
end


if ymax ~=0

    ymax = ceil(ymax * 8)/8; % round to nearest 0.5


    if ymax > 1.5
       
        if ymax > 10 && ymax < 30
            ymax = 30;
            ylim([0 ymax]);
            yticks((linspace(0, ceil(ymax), 11)));
            yticklabels((linspace(0, ceil(ymax), 11))); % for ISIs
        elseif ymax > 30
                %ymax = 1000;
                 ylim([0 ymax]);
            yticks((linspace(0, ceil(ymax), 11)));
            yticklabels((linspace(0, ceil(ymax), 11))); % for ISIs
            
        else
             ymax = 6;
            ylim([0 ymax]);
            yticks(linspace(0, 10, 11));
            yticklabels(linspace(0, 10, 11)); % for ISIs
        end

    else
        %ymax = 0.3;
        ylim([0 ymax])
        yticks(linspace(0,1,11));
        yticklabels(linspace(0, 1,11)); % for frequencies
    end

    ylabel(metric, 'Interpreter','none');
else
    disp('No regional analysis for K+')
end







