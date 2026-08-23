function plotScalogram(data)
% Convert 1-D bearing signals to scalograms through wavelet transform
fs = 64000;
[cfs,frq] = cwt(data.Vibration,'amor', fs);

% Plot the original signal and its scalogram
figure
subplot(2,1,1)
plot(data.Time, data.Vibration)
xlim([seconds(0) seconds(0.2601)])
title('Vibration Signal')
xlabel('Time (s)')
ylabel('Amplitude')
set(gca,'FontSize',20)
subplot(2,1,2)
surface(data.Time,frq,abs(cfs))
shading flat
xlim([seconds(0) seconds(0.2601)])
ylim([0 max(frq)])
title('Scalogram')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
set(gca,'FontSize',20)
end