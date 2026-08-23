%% Clear

clear all

%% Load data

Normal = load("Datasets/Paderborn/Normal/K004 Extracted/K004_1.mat");
Artificial = load("Datasets/Paderborn/Artificial Outer Race/KA05 Extracted/KA05_13.mat");
Natural = load("Datasets/Paderborn/Natural Outer Race/KA22 Extracted/KA22_13.mat");

%% Calculate parameters

Fs = 64000;
Fr = 1500/60;

%PB data
d = 6.75;                                                    % ball bearing diameter /mm
D = 29.05;                                                   % pitch diameter /mm
n = 8;                                                       % number of balls

BPFO_PB = 0.5*n*Fr*(1-d/D);                         % Outer Race Ballpass Frequency /Hz
BPFI_PB = 0.5*n*Fr*(1+d/D);                         % Inner Race Ballpass Frequency /Hz
FTF_PB = 0.5*Fr*(1-d/D);                               % Fundamental Train Frequency /Hz
BSF_PB = (D*Fr/d)*(1-((d/D)^2));                 % Ball Spin Frequency /Hz

%% Plot time series data
FontSize = 20;

%Normal
subplot(3,1,1)
plot(Normal.Time,Normal.Vib)
title("Normal Baseline", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")
set(gca,'FontSize',FontSize)

%Artificial
subplot(3,1,2)
plot(Artificial.Time,Artificial.Vib)
title("Artificial", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")
set(gca,'FontSize',FontSize)

%Natural
subplot(3,1,3)
plot(Natural.Time,Natural.Vib)
title("Natural", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")
set(gca,'FontSize',FontSize)

linkaxes([subplot(3,1,1) subplot(3,1,2) subplot(3,1,3)])

%% Frequency Domain
upperlim = 20000;
ylimit = 0.01;

%Normal
figure;
[y, x] = FFTPlot(Normal.Vib, Fs);
plot(x, y,'LineWidth',2)
title("Normal Frequency Spectrum with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
%helperPlotCombsSidebands(100,BPFO_PB,Fr,2)
%legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 ylimit])


%Artificial
figure;
[y, x] = FFTPlot(Artificial.Vib, Fs);
plot(x, y,'LineWidth',2)
title("Artificial Frequency Spectrum with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
%helperPlotCombsSidebands(100,BPFO_PB,Fr,2)
%legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 ylimit])

%Natural
figure;
[y, x] = FFTPlot(Natural.Vib, Fs);
plot(x, y,'LineWidth',2)
title("Natural Frequency Spectrum with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
%helperPlotCombsSidebands(100,BPFO_PB,Fr,2)
%legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 ylimit])

%% Overlayed spectrum


upperlim = 20000;
ylimit = 0.01;

%Normal
figure;
[y, x] = FFTPlot(Normal.Vib, Fs);
plot(x, y,'LineWidth',2,'Color','blue')

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
%helperPlotCombsSidebands(100,BPFO_PB,Fr,2)
%legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 ylimit])
hold on

%Artificial
[y, x] = FFTPlot(Artificial.Vib, Fs);
plot(x, y,'LineWidth',2,'Color','cyan')

xlim([0 upperlim])

%helperPlotCombsSidebands(100,BPFO_PB,Fr,2)
%legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 ylimit])
hold on

%Natural
[y, x] = FFTPlot(Natural.Vib, Fs);
plot(x, y,'LineWidth',2,'Color','red')
xlim([0 upperlim])
%helperPlotCombsSidebands(100,BPFO_PB,Fr,2)
%legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 ylimit])

legend("Normal", "Artificial", "Natural")


%% Kurtogram

level = 9;

subplot(2,2,1)
kurtogram(Normal.Vib, Fs, level);

subplot(2,2,2)
kurtogram(Artificial.Vib, Fs, level);

subplot(2,2,3)
kurtogram(Natural.Vib, Fs, level);

%% Scalogram

fs = 64000;
[cfs,frq] = cwt(Normal.Vib,'amor', fs);

% Plot the original signal and its scalogram
figure;
subplot(2,1,1)
plot(Normal.Time, Normal.Vibration)
xlim([0 0.16])
title('Vibration Signal - Normal')
xlabel('Time (s)')
ylabel('Amplitude')
set(gca,'FontSize',20)
subplot(2,1,2)
surface(Normal.Time,frq,abs(cfs))
shading flat
xlim([0 0.16])
ylim([0 max(frq)])
title('Scalogram - Normal')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
set(gca,'FontSize',20)

fs = 64000;
[cfs,frq] = cwt(Artificial.Vib,'amor', fs);

% Plot the original signal and its scalogram
figure;
subplot(2,1,1)
plot(Artificial.Time, Artificial.Vibration)
xlim([0 0.16])
title('Vibration Signal - Artificial')
xlabel('Time (s)')
ylabel('Amplitude')
set(gca,'FontSize',20)
subplot(2,1,2)
surface(Artificial.Time,frq,abs(cfs))
shading flat
xlim([0 0.16])
ylim([0 max(frq)])
title('Scalogram - Artificial')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
set(gca,'FontSize',20)

fs = 64000;
[cfs,frq] = cwt(Natural.Vib,'amor', fs);

% Plot the original signal and its scalogram
figure;
subplot(2,1,1)
plot(Natural.Time, Natural.Vibration)
xlim([0 0.16])
title('Vibration Signal - Natural')
xlabel('Time (s)')
ylabel('Amplitude')
set(gca,'FontSize',20)
subplot(2,1,2)
surface(Natural.Time,frq,abs(cfs))
shading flat
xlim([0 0.16])
ylim([0 max(frq)])
title('Scalogram - Natural')
xlabel('Time (s)')
ylabel('Frequency (Hz)')
set(gca,'FontSize',20)

%% Spectral Entropy

NormalSE = pentropy(Normal.Vib,Fs,'Instantaneous',false);
ArtificialSE = pentropy(Artificial.Vib,Fs,'Instantaneous',false);
NaturalSE = pentropy(Natural.Vib,Fs,'Instantaneous',false);

%% GCMs
%BPFO_PB/Fr
OrderList = [1];

T = table('Size',[3 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});

%Normal
TSA = tsa(Normal.Vib,Fs,1/Fr);
res = tsaresidual(TSA, Fs, Fr*60, OrderList);
diff = tsadifference(TSA, Fs, Fr*60, OrderList);
reg = tsaregular(TSA, Fs, Fr*60, OrderList);

T(1,'TSA') = {TSA};
T(1,'Diff') = {diff};
T(1,'Reg') = {reg};
T(1,'Res') = {res};

%Artificial
TSA = tsa(Artificial.Vib,Fs,1/Fr);
res = tsaresidual(TSA, Fs, Fr*60, OrderList);
diff = tsadifference(TSA, Fs, Fr*60, OrderList);
reg = tsaregular(TSA, Fs, Fr*60, OrderList);

T(2,'TSA') = {TSA};
T(2,'Diff') = {diff};
T(2,'Reg') = {reg};
T(2,'Res') = {res};

%Natural
TSA = tsa(Natural.Vib,Fs,1/Fr);
res = tsaresidual(TSA, Fs, Fr*60, OrderList);
diff = tsadifference(TSA, Fs, Fr*60, OrderList);
reg = tsaregular(TSA, Fs, Fr*60, OrderList);

T(3,'TSA') = {TSA};
T(3,'Diff') = {diff};
T(3,'Reg') = {reg};
T(3,'Res') = {res};

[gearMetrics,info] = gearConditionMetrics(T,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res')








