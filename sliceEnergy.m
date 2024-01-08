function [energy, energy2, energy3] = sliceEnergy(data, traces, chan)

% data here is just the spike train
% chan is one channel
%% calculate frequency
f = nnz(data) / length(data) * 1000; % 1000 is the sampling frequency, bear in mind if need to change


%% calculate the average amplitude
L = size(traces,1);

n_spikes = nnz(data);
amplitudes = zeros(1,n_spikes);

x = 0;
for i = 1:size(traces,2)

    if traces(1,i) == chan
x = x+1;
        amplitudes(x) = max(traces(3:L,i));
    end
end

avgamp = mean(amplitudes) * 1000; % convert from mV to V
minamp = min((amplitudes)) *1000; % convert from mV to v

%% calculate the 'energy'

%s = sliceEnergyConstant; % or something like that??
s = 1; % this is just placeholder, atm means this calculates a metric of the 'energy' of the slice
% units of s constant would be in kg/s aka mass flow rate - which kindve
% makes sense given we've called amplitude a 'distance' instead of a
% voltage - thus can think of almost as a voltage flow rate, and thus a
% current?

energy = s * avgamp * f * minamp; % im sure can make a more clever equation than this
energy2 = s * avgamp^2 * f;
energy3 = s * avgamp * f;


