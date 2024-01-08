function plotAgainstGabazine(dependent, output)
%%
% NB xvalues of 0 are plotted at log(1.5*2.718) so that graph scale is
% maintained
%%
metric = dependent;

figure
hold on
aesthetics

[maxy] = zeros(1,6);

xlim([log(1.5*2.718) log(1000)]);
xticks([log(0.001) log(10) log(30) log(100) log(300) log(1000)]);
xticklabels({'0' , '10', '30', '100', '300', '1000'});
xlabel('Final [Gabazine] of aCSF (nM)');


title(strcat('Inter-ictal spike', {' '}, metric, {' '} , 'against aCSF [Gabazine]'), 'interpreter', 'none')

legend('Location', 'northwest');

%% %% plot group 1 / WT 5w

[xvals] = [log(1.5*2.718), log(10), log(100), log(300), log(1000)];
[a, controls, ab, thirty, b, hundred, c, threehundred, d, onemicro] = scrapeDataGabazine(output, 'WT', 'Gabazine', '4-5' , 0, metric); % need to have manually preloaded output for this

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
else
    plot(xvals(1), a, '*', 'color', 'g', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(ab)
    ab = 0;
else
    plot(xvals(2), ab, '*', 'color', 'g', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(b)
    b = 0;
else
    plot(xvals(3), b, '*', 'color', 'g', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(c)
    xvals(4) = NaN;
else
    plot(xvals(4), c, '*', 'color', 'g', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(d)
    xvals(length(xvals)) = NaN;
else
    plot(xvals(5), d, '*', 'color', 'g', 'MarkerSize', 5,'HandleVisibility','off')
end

[x1] = xvals(~isnan(xvals));
[mean_y] = [mean(a) mean(ab) mean(b) mean(c)  mean(d)];
maxy(1) = max(mean_y);
[y1] = mean_y(~isnan(mean_y));

plot(x1, y1, '--*', 'color', 'g' , 'linewidth', 2, 'DisplayName','WT 4-5w');


%% plot group 2 / NL-F 5w

[xvals] = [log(1.5*2.718), log(10), log(100), log(300), log(1000)]; % not even bothering with 10nM
[a, controls, ab, thirty, b, hundred, c, threehundred, d, onemicro] = scrapeDataGabazine(output, 'LF', 'Gabazine', '12-13' , 0, metric); % need to have manually preloaded output for this

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
else
    plot(xvals(1), a, '*', 'color', 'y', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(ab)
    ab = 0;
else
    plot(xvals(2), ab, '*', 'color', 'y', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(b)
    b = 0;
else
    plot(xvals(3), b, '*', 'color', 'y', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(c)
    xvals(4) = NaN;
else
    plot(xvals(4), c, '*', 'color', 'y', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(d)
    xvals(length(xvals)) = NaN;
else
    plot(xvals(5), d, '*', 'color', 'y', 'MarkerSize', 5,'HandleVisibility','off')
end

[x2] = xvals(~isnan(xvals));
[mean_y] = [mean(a) mean(ab) mean(b) mean(c)  mean(d)];
maxy(2) = max(mean_y);
[y2] = mean_y(~isnan(mean_y));


plot(x2, y2, '--*', 'color', 'y', 'linewidth', 2, 'DisplayName','NL-F 4-5w');


%% plot group 3 / NL-G-F 5w


[xvals] = [log(1.5*2.718), log(10), log(100), log(300), log(1000)]; % not even bothering with 10nM
[a, controls, ab, thirty, b, hundred, c, threehundred, d, onemicro] = scrapeDataGabazine(output, 'GF', 'K', '4-5' , 0, metric); % need to have manually preloaded output for this

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
else
    plot(xvals(1), a, '*', 'color', 'r', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(ab)
    ab = 0;
else
    plot(xvals(2), ab, '*', 'color', 'r', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(b)
    b = 0;
else
    plot(xvals(3), b, '*', 'color', 'r', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(c)
    xvals(4) = NaN;
else
    plot(xvals(4), c, '*', 'color', 'r', 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(d)
    xvals(length(xvals)) = NaN;
else
    plot(xvals(5), d, '*', 'color', 'r', 'MarkerSize', 5,'HandleVisibility','off')
end

[x3] = xvals(~isnan(xvals));
[mean_y] = [mean(a) mean(ab) mean(b) mean(c)  mean(d)];
maxy(3) = max(mean_y);
[y3] = mean_y(~isnan(mean_y));


plot(x3, y3,'--*', 'color', 'r', 'linewidth', 2, 'DisplayName','NL-G-F 4-5w');

%% plot group 4 / WT 12w


[xvals] = [log(1.5*2.718), log(10), log(100), log(300), log(1000)]; % not even bothering with 10nM
[a, controls, ab, thirty, b, hundred, c, threehundred, d, onemicro] = scrapeDataGabazine(output, 'WT', 'K', '12-13' , 0, metric); % need to have manually preloaded output for this

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
else
    plot(xvals(1), a, '*', 'color', [0.4660 0.6740 0.1880], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(b)
    b = 0;
else
    plot(xvals(3), b, '*', 'color', [0.4660 0.6740 0.1880], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(ab)
    ab = 0;
else
    plot(xvals(2), ab, '*', 'color', [0.4660 0.6740 0.1880], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(c)
    xvals(4) = NaN;
else
    plot(xvals(4), c, '*', 'color', [0.4660 0.6740 0.1880], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(d)
    xvals(length(xvals)) = NaN;
else
    plot(xvals(5), d, '*', 'color', [0.4660 0.6740 0.1880], 'MarkerSize', 5,'HandleVisibility','off')
end

[x4] = xvals(~isnan(xvals));
[mean_y] = [mean(a) mean(ab) mean(b) mean(c)  mean(d)];
maxy(4) = max(mean_y);
[y4] = mean_y(~isnan(mean_y));


plot(x4, y4, '--o', 'color',[0.4660 0.6740 0.1880] , 'linewidth', 2, 'DisplayName','WT 12-13w');

%% plot group 5 / NL-F 12w


[xvals] = [log(1.5*2.718), log(10), log(100), log(300), log(1000)]; % not even bothering with 10nM
[a, controls, ab, thirty, b, hundred, c, threehundred, d, onemicro] = scrapeDataGabazine(output, 'LF', 'K', '12-13' , 0, metric); % need to have manually preloaded output for this

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
else
    plot(xvals(1), a, '*', 'color', [0.9290 0.6940 0.1250], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(b)
    b = 0;
else
    plot(xvals(3), b, '*', 'color', [0.9290 0.6940 0.1250], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(ab)
    ab = 0;
else
    plot(xvals(2), ab, '*', 'color', [0.9290 0.6940 0.1250], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(c)
    xvals(4) = NaN;
else
    plot(xvals(4), c, '*', 'color', [0.9290 0.6940 0.1250], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(d)
    xvals(length(xvals)) = NaN;
else
    plot(xvals(5), d, '*', 'color', [0.9290 0.6940 0.1250], 'MarkerSize', 5,'HandleVisibility','off')
end

[x5] = xvals(~isnan(xvals));
[mean_y] = [mean(a) mean(ab) mean(b) mean(c)  mean(d)];
maxy(5) = max(mean_y);
[y5] = mean_y(~isnan(mean_y));


plot(x5, y5, '--o','color',[0.9290 0.6940 0.1250] , 'linewidth', 2, 'DisplayName','NL-F 12-13w');

%% plot group 6 / NL-G-F 12-13w


[xvals] = [log(1.5*2.718), log(10), log(100), log(300), log(1000)]; % not even bothering with 10nM
[a, controls, ab, thirty, b, hundred, c, threehundred, d, onemicro] = scrapeDataGabazine(output, 'GF', 'K', '12-13' , 0, metric); % need to have manually preloaded output for this

if isnan(a) % assume that for control and lowest experimental conc that if NaN this is due to =0 as opposed to absence of data (true for all but 2 cases or so)
    a = 0;
else
    plot(xvals(1), a, '*', 'color', [0.6350 0.0780 0.1840], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(b)
    b = 0;
else
    plot(xvals(3), b, '*', 'color', [0.6350 0.0780 0.1840], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(ab)
    ab = 0;
else
    plot(xvals(2), ab, '*', 'color', [0.6350 0.0780 0.1840], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(c)
    xvals(4) = NaN;
else
    plot(xvals(4), c, '*', 'color', [0.6350 0.0780 0.1840], 'MarkerSize', 5,'HandleVisibility','off')
end
if isnan(d)
    xvals(length(xvals)) = NaN;
else
    plot(xvals(5), d, '*', 'color', [0.6350 0.0780 0.1840], 'MarkerSize', 5,'HandleVisibility','off')
end

[x6] = xvals(~isnan(xvals));
[mean_y] = [mean(a) mean(ab) mean(b) mean(c)  mean(d)];
maxy(6) = max(mean_y);
[y6] = mean_y(~isnan(mean_y));


plot(x6, y6, '--o', 'color', [0.6350 0.0780 0.1840], 'linewidth', 2, 'DisplayName','NL-G-F 12-13w');

%% set y axis
ymax = max(maxy);
if length(ymax) > 1
    ymax = ymax(1); % avoids error in case 2 of same length
end

if ymax ~= 0


ymax = ceil(ymax * 4)/4; % round to nearest 0.5


if ymax > 1.5
    if ymax > 10
        ylim([0 ymax]);
    yticks((linspace(0, ceil(ymax), 11)));
    yticklabels((linspace(0, ceil(ymax), 11))); % for ISIs
    else
    ylim([0 ymax]);
    yticks(linspace(0, 10, 11));
    yticklabels(linspace(0, 10, 11)); % for ISIs
    end
    
else
    ylim([0 ymax])
    yticks(linspace(0,1,11));
    yticklabels(linspace(0, 1,11)); % for frequencies
end

ylabel(metric, 'Interpreter','none');
else
   disp('No regional analysis for Gabazine')
end
