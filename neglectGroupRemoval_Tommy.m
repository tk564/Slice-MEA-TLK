function [data] = neglectGroupRemoval_Tommy(data)

% neglect group is channels 1 9 17 18 19 25 26 27 28 33 34 35 41 42 43 49 50 57 58

zeroArray = zeros(height(data),1);

data(:,1) = zeroArray;
data(:,9) = zeroArray;
data(:,17) = zeroArray;
data(:,18) = zeroArray;
data(:,19) = zeroArray;
data(:,25) = zeroArray;
data(:,26) = zeroArray;
data(:,27) = zeroArray;
data(:,28) = zeroArray;
data(:,33) = zeroArray;
data(:,34) = zeroArray;
data(:,35) = zeroArray;
data(:,41) = zeroArray;
data(:,42) = zeroArray;
data(:,43) = zeroArray;
data(:,49) = zeroArray;
data(:,50) = zeroArray;
data(:,57) = zeroArray;
data(:,58) = zeroArray;

% data.CH1mV = zeroArray;
% data.CH9mV = zeroArray;
% data.CH17mV = zeroArray;
% data.CH18mV = zeroArray;
% data.CH19mV = zeroArray;
% data.CH25mV = zeroArray;
% data.CH26mV = zeroArray;
% data.CH27mV = zeroArray;
% data.CH28mV = zeroArray;
% data.CH33mV = zeroArray;
% data.CH34mV = zeroArray;
% data.CH35mV = zeroArray;
% data.CH41mV = zeroArray;
% data.CH42mV = zeroArray;
% data.CH43mV = zeroArray;
% data.CH49mV = zeroArray;
% data.CH50mV = zeroArray;
% data.CH57mV = zeroArray;
% data.CH58mV = zeroArray;

disp('Neglect group was removed')

end

