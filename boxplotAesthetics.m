function boxplotAesthetics(ymax, plotname, tickinterval,axname)

set(axname,'FontSize',20)
set(plotname,'MarkerSize',16)
ylim([0 ymax]);
yticks(0:tickinterval:ymax)
aesthetics
h = findobj(axname,'tag','Outliers');
set(h,'MarkerSize',16, 'LineWidth', 4)



