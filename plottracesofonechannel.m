close
for i = 1:size(traces,2)
if traces(1,i) == 64
plot(traces(3:1003,i))
hold on
end
end

hold on
plot(mean(traces(3:1003,:),2), 'LineWidth',2)
    