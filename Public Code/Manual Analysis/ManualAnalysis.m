%% clear
clear all

%----------------------------------------------------------------------------------------------------------------------------------------%
%This Script conducts the manual analysis in a structured and repeatable way.
% We first need to load the data in a structure that is organised and labelled.
%The signals analysed are as follows:
%
% 1. CWRU Normal
% 2. CWRU Notched Point Fault
% 3. Paderborn Normal
% 4. Paderborn Notched Point Fault
% 5. Paderborn Notched Pitting Fault
% 6. Paderborn Artificial Pitting Fault
%
% We perform the analysis on these faults for both inner and outer race faults.
%----------------------------------------------------------------------------------------------------------------------------------------%

%% Load data - Inner Race

CWRU_Inner_Notch = load("Datasets/CWRU/Inner Race/IR_07_3.mat");
PB_Inner_Notch = load("Datasets/Paderborn/Artificial Inner Race/KI01 Extracted/KI01_2.mat");
PB_Inner_Pitting = load("Datasets/Paderborn/Artificial Inner Race/KI03 Extracted/KI03_1.mat");
PB_Inner_Natural = load("Datasets/Paderborn/Natural Inner Race/KI04 Extracted/KI04_1.mat");

CWRU_Fr_Inner_Notch = CWRU_Inner_Notch.X112RPM/60;
CWRU_Inner_Notch = CWRU_Inner_Notch.X112_FE_time(1:485000);


%% Load data - Outer Race

CWRU_Outer_Notch = load("Datasets/CWRU/Outer Race/OR_07_3.mat");
PB_Outer_Notch = load("Datasets/Paderborn/Artificial Outer Race/KA01 Extracted/KA01_1.mat");
PB_Outer_Pitting = load("Datasets/Paderborn/Artificial Outer Race/KA05 Extracted/KA05_1.mat");
PB_Outer_Natural = load("Datasets/Paderborn/Natural Outer Race/KA04 Extracted/KA04_1.mat");

CWRU_Fr_Outer_Notch = CWRU_Outer_Notch.X138RPM/60;
CWRU_Outer_Notch = CWRU_Outer_Notch.X138_FE_time(1:485000);

%% Load data - Ball

CWRU_Ball_Notch = load("Datasets/CWRU/Ball/B_07_3.mat");

CWRU_Fr_Ball_Notch = CWRU_Ball_Notch.X125RPM/60;
CWRU_Ball_Notch = CWRU_Ball_Notch.X125_FE_time(1:485000);

%% Load data - Normal

CWRU_Normal = load("Datasets/CWRU/Normal/Normal_3.mat");
PB_Normal = load("Datasets/Paderborn/Normal/K005 Extracted/K005_1.mat");

CWRU_Fr_Normal = CWRU_Normal.X100RPM/60;
CWRU_Normal = CWRU_Normal.X100_FE_time(1:485000);

%% Load data - Compound

PB_Compound = load("Datasets/Paderborn/Compound/KB24 Extracted/KB24_1.mat");



%------------------------------------------------------------------------------------------------------------------------------------%
% Now, we can determine all of the variables based on the geometry of the datasets.
%------------------------------------------------------------------------------------------------------------------------------------%

%% Determine Frequencies and parameters

CWRU_Fs = 48000;
PB_Fs = 64000;
PB_Fr = 1500/60;

%CWRU data
d_CWRU = 0.2656 * 25.4;                                         % ball bearing diameter /mm
D_CWRU = 1.122 * 25.4;                                          % pitch diameter /mm
n_CWRU = 8;                                                     % number of balls

%These are Harmonics as RPM varies! We need to multiply by Fr's
BPFO_CWRU = 0.5*n_CWRU*(1-d_CWRU/D_CWRU);                       % Outer Race Ballpass Frequency /Hz
BPFI_CWRU = 0.5*n_CWRU*(1+d_CWRU/D_CWRU);                       % Inner Race Ballpass Frequency /Hz
FTF_CWRU = 0.5*(1-d_CWRU/D_CWRU);                               % Fundamental Train Frequency /Hz
BSF_CWRU = (D_CWRU/d_CWRU)*(1-((d_CWRU/D_CWRU)^2));             % Ball Spin Frequency /Hz

%PB data
d_PB = 6.75;                                                    % ball bearing diameter /mm
D_PB = 29.05;                                                   % pitch diameter /mm
n_PB = 8;                                                       % number of balls

BPFO_PB = 0.5*n_PB*PB_Fr*(1-d_PB/D_PB);                         % Outer Race Ballpass Frequency /Hz
BPFI_PB = 0.5*n_PB*PB_Fr*(1+d_PB/D_PB);                         % Inner Race Ballpass Frequency /Hz
FTF_PB = 0.5*PB_Fr*(1-d_PB/D_PB);                               % Fundamental Train Frequency /Hz
BSF_PB = (D_PB*PB_Fr/d_PB)*(1-((d_PB/D_PB)^2));                 % Ball Spin Frequency /Hz


%------------------------------------------------------------------------------------------------------------------------------------%
% Now, we can plot the data in its different forms. We will start with the time series data.
%------------------------------------------------------------------------------------------------------------------------------------%

%% Plot raw data - Inner

CWRU_Faulty = CWRU_Inner_Notch;
CWRU_Length = length(CWRU_Faulty);
CWRU_Time = (0:CWRU_Length-1) / CWRU_Fs;

FontSize = 14;

figure('Name', 'Vibration Data Comparison');

%CWRU - Normal
subplot(2,3,1)
plot(CWRU_Time,CWRU_Normal)
xlim([0 4])
title("CWRU - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize);
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")

%CWRU - Faulty
subplot(2,3,4)
plot(CWRU_Time,CWRU_Faulty)
xlim([0 4])
title("CWRU - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")

%PB - Normal
subplot(2,3,2)
plot(PB_Normal.Time,PB_Normal.Vib)
title("Paderborn - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")


%PB - Inner Notch
subplot(2,3,5)
plot(PB_Inner_Notch.Time,PB_Inner_Notch.Vib)
title("Paderborn - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")


%PB - Inner Pitting
subplot(2,3,3)
plot(PB_Inner_Pitting.Time,PB_Inner_Pitting.Vib)
title("Paderborn - Inner Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")


%PB - Inner Natural
subplot(2,3,6)
plot(PB_Inner_Natural.Time,PB_Inner_Natural.Vib)
title("Paderborn - Inner Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")

linkaxes([subplot(2,3,1), subplot(2,3,2),subplot(2,3,3),subplot(2,3,4),subplot(2,3,5),subplot(2,3,6)]);

%% Plot raw data - Outer

CWRU_Faulty = CWRU_Outer_Notch;

CWRU_Length_Faulty = length(CWRU_Faulty);
CWRU_Time_Faulty = (0:CWRU_Length_Faulty-1) / CWRU_Fs;

CWRU_Length_Normal = length(CWRU_Normal);
CWRU_Time_Normal = (0:CWRU_Length_Normal-1) / CWRU_Fs;

FontSize = 14;

figure('Name', 'Vibration Data Comparison - Outer');

%CWRU - Normal
subplot(2,3,1)
plot(CWRU_Time_Normal,CWRU_Normal)
xlim([0 4])
title("CWRU - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize);
grid on;
xlabel("Time (s)")
ylim([-10 10])
ylabel("Acceleration (m/s^2)")

%CWRU - Faulty
subplot(2,3,4)
plot(CWRU_Time_Faulty,CWRU_Faulty)
xlim([0 4])
title("CWRU - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")

%PB - Normal
subplot(2,3,2)
plot(PB_Normal.Time,PB_Normal.Vib)
title("Paderborn - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")


%PB - Inner Notch
subplot(2,3,5)
plot(PB_Outer_Notch.Time,PB_Outer_Notch.Vib)
title("Paderborn - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")


%PB - Inner Pitting
subplot(2,3,3)
plot(PB_Outer_Pitting.Time,PB_Outer_Pitting.Vib)
title("Paderborn - Outer Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")


%PB - Inner Natural
subplot(2,3,6)
plot(PB_Outer_Natural.Time,PB_Outer_Natural.Vib)
title("Paderborn - Outer Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")

linkaxes([subplot(2,3,1), subplot(2,3,2),subplot(2,3,3),subplot(2,3,4),subplot(2,3,5),subplot(2,3,6)]);

%------------------------------------------------------------------------------------------------------------------------------------%
% Now, we move onto the frequency domain
%------------------------------------------------------------------------------------------------------------------------------------%

%% Plot raw frequency data - Inner

upperlim = 1000;
FontSize = 14;

subplot(2,3,4)
[y, x] = FFTPlot(CWRU_Inner_Notch, CWRU_Fs);
plot(x, y)
title("CWRU - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")

subplot(2,3,1)
[y, x] = FFTPlot(CWRU_Normal, CWRU_Fs);
plot(x, y)
title("CWRU - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")

subplot(2,3,2)
[y, x] = FFTPlot(PB_Normal.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")

subplot(2,3,5)
[y, x] = FFTPlot(PB_Inner_Notch.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombs(100,BPFI_PB)

subplot(2,3,3)
[y, x] = FFTPlot(PB_Inner_Pitting.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Inner Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombs(100,BPFI_PB)

subplot(2,3,6)
[y, x] = FFTPlot(PB_Inner_Natural.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Inner Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombs(100,BPFI_PB)

linkaxes([subplot(2,3,1), subplot(2,3,2), subplot(2,3,3), subplot(2,3,4), subplot(2,3,5), subplot(2,3,6)])

%------------------------------------------------------------------------------------------------------------------------------------%
%We can 'zoom in' and look at the low frequency range of our data, and consider the harmonics.
%------------------------------------------------------------------------------------------------------------------------------------%

%% Plot Combs - Inner Fault
FontSize = 20;

%Notched Point Fault
[y, x] = FFTPlot(PB_Inner_Notch.Vib, PB_Fs);
plot(x, y,'LineWidth',1)
title("Paderborn - Inner Race Point Fault (Notched) with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Notched Pitting
figure;
[y, x] = FFTPlot(PB_Inner_Pitting.Vib, PB_Fs);
plot(x(1,2:end), y(1,2:end),'LineWidth',1)
title("Paderborn - Inner Race Pitting Fault (Notched) with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Natural Pitting
figure;
[y, x] = FFTPlot(PB_Inner_Natural.Vib, PB_Fs);
plot(x(1,2:end), y(1,2:end),'LineWidth',1)
title("Paderborn - Inner Race Pitting Fault (Natural) with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)


%CWRU Notched Point Fault
[y, x] = FFTPlot(CWRU_Inner_Notch, CWRU_Fs);
plot(x, y)
title("CWRU - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFI_CWRU*CWRU_Fr_Inner_Notch,CWRU_Fr_Inner_Notch,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%------------------------------------------------------------------------------------------------------------------------------------%
% Repeating these results for Outer Race Data
%------------------------------------------------------------------------------------------------------------------------------------%

%% Plot raw frequency data - Outer

upperlim = 1000;
FontSize = 14;

subplot(2,3,4)
[y, x] = FFTPlot(CWRU_Outer_Notch, CWRU_Fs);
plot(x, y)
title("CWRU - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombs(100,BPFO_CWRU)

subplot(2,3,1)
[y, x] = FFTPlot(CWRU_Normal, CWRU_Fs);
plot(x, y)
title("CWRU - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")

subplot(2,3,2)
[y, x] = FFTPlot(PB_Normal.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")

subplot(2,3,5)
[y, x] = FFTPlot(PB_Outer_Notch.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombs(100,BPFO_PB)

subplot(2,3,3)
[y, x] = FFTPlot(PB_Outer_Pitting.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Outer Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombs(100,BPFO_PB)

subplot(2,3,6)
[y, x] = FFTPlot(PB_Outer_Natural.Vib, PB_Fs);
plot(x, y)
title("Paderborn - Outer Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombs(100,BPFO_PB)

linkaxes([subplot(2,3,1), subplot(2,3,2), subplot(2,3,3), subplot(2,3,4), subplot(2,3,5), subplot(2,3,6)])


%% Plot combs for Paderborn - Outer Fault
FontSize = 20;

%Notched Point Fault
[y, x] = FFTPlot(PB_Outer_Notch.Vib, PB_Fs);
plot(x, y,'LineWidth',1)
title("Paderborn - Outer Race Point Fault (Notched) with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Notched Pitting
figure;
[y, x] = FFTPlot(PB_Outer_Pitting.Vib, PB_Fs);
plot(x(1,2:end), y(1,2:end),'LineWidth',1)
title("Paderborn - Outer Race Pitting Fault (Notched) with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Natural Pitting
figure;
[y, x] = FFTPlot(PB_Outer_Natural.Vib, PB_Fs);
plot(x(1,2:end), y(1,2:end),'LineWidth',1)
title("Paderborn - Outer Race Pitting Fault (Natural) with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

figure;
[y, x] = FFTPlot(CWRU_Outer_Notch, CWRU_Fs);
plot(x, y)
title("CWRU - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFO_CWRU*CWRU_Fr_Outer_Notch,CWRU_Fr_Outer_Notch,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)


%------------------------------------------------------------------------------------------------------------------------------------%
%We can now move on to find the envelope spectrum. First, we can look at the kurtograms for each signal, to see where the optimum
%frequency lies, along with the kurtosis when maximised at this point.
%------------------------------------------------------------------------------------------------------------------------------------%

%% Kurtograms - Inner
level = 9;
FontSize = 20;

subplot(2,3,1)
kurtogram(CWRU_Normal, CWRU_Fs, level);

subplot(2,3,4)
kurtogram(CWRU_Inner_Notch, CWRU_Fs, level);

subplot(2,3,2)
kurtogram(PB_Normal.Vib, PB_Fs, level);

subplot(2,3,5)
kurtogram(PB_Inner_Notch.Vib, PB_Fs, level);

subplot(2,3,3)
kurtogram(PB_Inner_Pitting.Vib, PB_Fs, level);

subplot(2,3,6)
kurtogram(PB_Inner_Natural.Vib, PB_Fs, level);


%------------------------------------------------------------------------------------------------------------------------------------%
%We can then plot the envelope spectrum based on these spectograms
%------------------------------------------------------------------------------------------------------------------------------------%

%% Envelope Spectrum - Inner

level = 9;
% figure
% kurtogram(CWRU_Inner_Notch,CWRU_Fs,level)

% figure
% wc = 48;
% pkurtosis(xInner, fsInner, wc)

% Get optimum values from kurtogram
[~, ~, ~, fc_CWRU_Normal, ~, BW_CWRU_Normal] = kurtogram(CWRU_Normal, CWRU_Fs, level);
[~, ~, ~, fc_CWRU_Inner, ~, BW_CWRU_Inner] = kurtogram(CWRU_Inner_Notch, CWRU_Fs, level);
[~, ~, ~, fc_PB_Normal, ~, BW_PB_Normal] = kurtogram(PB_Normal.Vib, PB_Fs, level);
[~, ~, ~, fc_PB_Inner_Notch, ~, BW_PB_Inner_Notch] = kurtogram(PB_Inner_Notch.Vib, PB_Fs, level);
[~, ~, ~, fc_PB_Inner_Pitting, ~, BW_PB_Inner_Pitting] = kurtogram(PB_Inner_Pitting.Vib, PB_Fs, level); 
[~, ~, ~, fc_PB_Inner_Natural, ~, BW_PB_Inner_Natural] = kurtogram(PB_Inner_Natural.Vib, PB_Fs, level); 


% Generate optimum filters
ep = 1;

bpf_CWRU_Normal = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_CWRU_Normal - BW_CWRU_Normal/2, ep), 'CutoffFrequency2', min(fc_CWRU_Normal + BW_CWRU_Normal/2, CWRU_Fs/2 - ep), 'SampleRate', CWRU_Fs);
bpf_CWRU_Inner = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_CWRU_Inner - BW_CWRU_Inner/2, ep), 'CutoffFrequency2', min(fc_CWRU_Inner + BW_CWRU_Inner/2, CWRU_Fs/2 - ep), 'SampleRate', CWRU_Fs);  
bpf_PB_Normal = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Normal - BW_PB_Normal/2, ep), 'CutoffFrequency2', min(fc_PB_Normal + BW_PB_Normal/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  
bpf_PB_Inner_Notch = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Inner_Notch - BW_PB_Inner_Notch/2, ep), 'CutoffFrequency2', min(fc_PB_Inner_Notch + BW_PB_Inner_Notch/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  
bpf_PB_Inner_Pitting = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Inner_Pitting - BW_PB_Inner_Pitting/2, ep), 'CutoffFrequency2', min(fc_PB_Inner_Pitting + BW_PB_Inner_Pitting/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  
bpf_PB_Inner_Natural = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Inner_Natural - BW_PB_Inner_Natural/2, ep), 'CutoffFrequency2', min(fc_PB_Inner_Natural + BW_PB_Inner_Natural/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);



% Apply filter
CWRU_Normal_Bpf = filter(bpf_CWRU_Normal, CWRU_Normal);  
CWRU_Inner_Bpf = filter(bpf_CWRU_Inner, CWRU_Inner_Notch); 
PB_Normal_Bpf = filter(bpf_PB_Normal, PB_Normal.Vib);  
PB_Inner_Notch_Bpf = filter(bpf_PB_Inner_Notch, PB_Inner_Notch.Vib);  
PB_Inner_Pitting_Bpf = filter(bpf_PB_Inner_Pitting, PB_Inner_Pitting.Vib);  
PB_Inner_Natural_Bpf = filter(bpf_PB_Inner_Natural, PB_Inner_Natural.Vib);  

% Creates envelope using optimum values
[pEnv_bpf_CWRU_Normal, fEnv_bpf_CWRU_Normal, xEnv_bpf_CWRU_Normal, tEnv_bpf_CWRU_Normal] = envspectrum(CWRU_Normal, CWRU_Fs, 'FilterOrder', 200, 'Band', [max(fc_CWRU_Normal-BW_CWRU_Normal/2,ep) min(fc_CWRU_Normal+BW_CWRU_Normal/2,CWRU_Fs/2 - ep)]);
[pEnv_bpf_CWRU_Inner, fEnv_bpf_CWRU_Inner, xEnv_bpf_CWRU_Inner, tEnv_bpf_CWRU_Inner] = envspectrum(CWRU_Inner_Notch, CWRU_Fs, 'FilterOrder', 200, 'Band', [max(fc_CWRU_Inner-BW_CWRU_Inner/2,ep) min(fc_CWRU_Inner+BW_CWRU_Inner/2,CWRU_Fs/2 - ep)]);
[pEnv_bpf_PB_Normal, fEnv_bpf_PB_Normal, xEnv_bpf_PB_Normal, tEnv_bpf_PB_Normal] = envspectrum(PB_Normal.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Normal-BW_PB_Normal/2,ep) min(fc_PB_Normal+BW_PB_Normal/2,PB_Fs/2 - ep)]);
[pEnv_bpf_PB_Inner_Notch, fEnv_bpf_PB_Inner_Notch, xEnv_bpf_PB_Inner_Notch, tEnv_bpf_PB_Inner_Notch] = envspectrum(PB_Inner_Notch.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Inner_Notch-BW_PB_Inner_Notch/2,ep) min(fc_PB_Inner_Notch+BW_PB_Inner_Notch/2,PB_Fs/2 - ep)]);
[pEnv_bpf_PB_Inner_Pitting, fEnv_bpf_PB_Inner_Pitting, xEnv_bpf_PB_Inner_Pitting, tEnv_bpf_PB_Inner_Pitting] = envspectrum(PB_Inner_Pitting.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Inner_Pitting-BW_PB_Inner_Pitting/2,ep) min(fc_PB_Inner_Pitting+BW_PB_Inner_Pitting/2,PB_Fs/2 -ep)]);
[pEnv_bpf_PB_Inner_Natural, fEnv_bpf_PB_Inner_Natural, xEnv_bpf_PB_Inner_Natural, tEnv_bpf_PB_Inner_Natural] = envspectrum(PB_Inner_Natural.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Inner_Natural-BW_PB_Inner_Natural/2,ep) min(fc_PB_Inner_Natural+BW_PB_Inner_Natural/2,PB_Fs/2 - ep)]);

%Plot the envelope spectrum
upperlim = 1000;
FontSize = 14;

subplot(2,3,1)
plot(fEnv_bpf_CWRU_Normal, pEnv_bpf_CWRU_Normal);
title("CWRU - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFI_CWRU, CWRU_Fr,2)

subplot(2,3,2)
plot(fEnv_bpf_CWRU_Inner,pEnv_bpf_CWRU_Inner);
title("CWRU - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFI_CWRU, CWRU_Fr,2)

subplot(2,3,3)
plot(fEnv_bpf_PB_Normal,pEnv_bpf_PB_Normal);
title("Paderborn - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)

subplot(2,3,4)
plot(fEnv_bpf_PB_Inner_Notch,pEnv_bpf_PB_Inner_Notch);
title("Paderborn - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)

subplot(2,3,5)
plot(fEnv_bpf_PB_Inner_Pitting,pEnv_bpf_PB_Inner_Pitting);
title("Paderborn - Inner Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)

subplot(2,3,6)
plot(fEnv_bpf_PB_Inner_Natural,pEnv_bpf_PB_Inner_Natural);
title("Paderborn - Inner Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)

linkaxes([subplot(2,3,1), subplot(2,3,2), subplot(2,3,3), subplot(2,3,5), subplot(2,3,6)])

%% Plot combs for Envelope - Inner

upperlim = 1000;
FontSize = 14;

%CWRU IR Point Fault
figure;
plot(fEnv_bpf_CWRU_Inner,pEnv_bpf_CWRU_Inner);
title("CWRU - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFI_CWRU*CWRU_Fr_Inner_Notch, CWRU_Fr_Inner_Notch,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Paderborn IR Point Fault
figure;
plot(fEnv_bpf_PB_Inner_Notch,pEnv_bpf_PB_Inner_Notch);
title("Paderborn - Inner Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Paderborn IR Pitting Fault
figure;
plot(fEnv_bpf_PB_Inner_Pitting,pEnv_bpf_PB_Inner_Pitting);
title("Paderborn - Inner Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Paderborn Natural IR Pitting Fault
figure;
plot(fEnv_bpf_PB_Inner_Natural,pEnv_bpf_PB_Inner_Natural);
title("Paderborn - Inner Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)


%% Kurtograms - Outer

level = 9;
FontSize = 20;

subplot(2,3,1)
kurtogram(CWRU_Normal, CWRU_Fs, level);

subplot(2,3,4)
kurtogram(CWRU_Outer_Notch, CWRU_Fs, level);

subplot(2,3,2)
kurtogram(PB_Normal.Vib, PB_Fs, level);

subplot(2,3,5)
kurtogram(PB_Outer_Notch.Vib, PB_Fs, level);

subplot(2,3,3)
kurtogram(PB_Outer_Pitting.Vib, PB_Fs, level);

subplot(2,3,6)
kurtogram(PB_Outer_Natural.Vib, PB_Fs, level);


%% Envelope Spectrum - Outer

level = 9;
% figure
% kurtogram(CWRU_Outer_Notch,CWRU_Fs,level)

% figure
% wc = 48;
% pkurtosis(xOuter, fsOuter, wc)

% Get optimum values from kurtogram
[~, ~, ~, fc_CWRU_Normal, ~, BW_CWRU_Normal] = kurtogram(CWRU_Normal, CWRU_Fs, level);
[~, ~, ~, fc_CWRU_Outer, ~, BW_CWRU_Outer] = kurtogram(CWRU_Outer_Notch, CWRU_Fs, level);
[~, ~, ~, fc_PB_Normal, ~, BW_PB_Normal] = kurtogram(PB_Normal.Vib, PB_Fs, level);
[~, ~, ~, fc_PB_Outer_Notch, ~, BW_PB_Outer_Notch] = kurtogram(PB_Outer_Notch.Vib, PB_Fs, level);
[~, ~, ~, fc_PB_Outer_Pitting, ~, BW_PB_Outer_Pitting] = kurtogram(PB_Outer_Pitting.Vib, PB_Fs, level); 
[~, ~, ~, fc_PB_Outer_Natural, ~, BW_PB_Outer_Natural] = kurtogram(PB_Outer_Natural.Vib, PB_Fs, level); 


% Generate optimum filters
ep = 1;

bpf_CWRU_Normal = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_CWRU_Normal - BW_CWRU_Normal/2, ep), 'CutoffFrequency2', min(fc_CWRU_Normal + BW_CWRU_Normal/2, CWRU_Fs/2 - ep), 'SampleRate', CWRU_Fs);
bpf_CWRU_Outer = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_CWRU_Outer - BW_CWRU_Outer/2, ep), 'CutoffFrequency2', min(fc_CWRU_Outer + BW_CWRU_Outer/2, CWRU_Fs/2 - ep), 'SampleRate', CWRU_Fs);  
bpf_PB_Normal = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Normal - BW_PB_Normal/2, ep), 'CutoffFrequency2', min(fc_PB_Normal + BW_PB_Normal/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  
bpf_PB_Outer_Notch = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Outer_Notch - BW_PB_Outer_Notch/2, ep), 'CutoffFrequency2', min(fc_PB_Outer_Notch + BW_PB_Outer_Notch/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  
bpf_PB_Outer_Pitting = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Outer_Pitting - BW_PB_Outer_Pitting/2, ep), 'CutoffFrequency2', min(fc_PB_Outer_Pitting + BW_PB_Outer_Pitting/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  
bpf_PB_Outer_Natural = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Outer_Natural - BW_PB_Outer_Natural/2, ep), 'CutoffFrequency2', min(fc_PB_Outer_Natural + BW_PB_Outer_Natural/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);


% Apply filter
CWRU_Normal_Bpf = filter(bpf_CWRU_Normal, CWRU_Normal);  
CWRU_Outer_Bpf = filter(bpf_CWRU_Outer, CWRU_Outer_Notch); 
PB_Normal_Bpf = filter(bpf_PB_Normal, PB_Normal.Vib);  
PB_Outer_Notch_Bpf = filter(bpf_PB_Outer_Notch, PB_Outer_Notch.Vib);  
PB_Outer_Pitting_Bpf = filter(bpf_PB_Outer_Pitting, PB_Outer_Pitting.Vib);  
PB_Outer_Natural_Bpf = filter(bpf_PB_Outer_Natural, PB_Outer_Natural.Vib);  

% Creates envelope using optimum values
[pEnv_bpf_CWRU_Normal, fEnv_bpf_CWRU_Normal, xEnv_bpf_CWRU_Normal, tEnv_bpf_CWRU_Normal] = envspectrum(CWRU_Normal, CWRU_Fs, 'FilterOrder', 200, 'Band', [max(fc_CWRU_Normal-BW_CWRU_Normal/2,ep) min(fc_CWRU_Normal+BW_CWRU_Normal/2,CWRU_Fs/2 - ep)]);
[pEnv_bpf_CWRU_Outer, fEnv_bpf_CWRU_Outer, xEnv_bpf_CWRU_Outer, tEnv_bpf_CWRU_Outer] = envspectrum(CWRU_Outer_Notch, CWRU_Fs, 'FilterOrder', 200, 'Band', [max(fc_CWRU_Outer-BW_CWRU_Outer/2,ep) min(fc_CWRU_Outer+BW_CWRU_Outer/2,CWRU_Fs/2 - ep)]);
[pEnv_bpf_PB_Normal, fEnv_bpf_PB_Normal, xEnv_bpf_PB_Normal, tEnv_bpf_PB_Normal] = envspectrum(PB_Normal.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Normal-BW_PB_Normal/2,ep) min(fc_PB_Normal+BW_PB_Normal/2,PB_Fs/2 - ep)]);
[pEnv_bpf_PB_Outer_Notch, fEnv_bpf_PB_Outer_Notch, xEnv_bpf_PB_Outer_Notch, tEnv_bpf_PB_Outer_Notch] = envspectrum(PB_Outer_Notch.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Outer_Notch-BW_PB_Outer_Notch/2,ep) min(fc_PB_Outer_Notch+BW_PB_Outer_Notch/2,PB_Fs/2 - ep)]);
[pEnv_bpf_PB_Outer_Pitting, fEnv_bpf_PB_Outer_Pitting, xEnv_bpf_PB_Outer_Pitting, tEnv_bpf_PB_Outer_Pitting] = envspectrum(PB_Outer_Pitting.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Outer_Pitting-BW_PB_Outer_Pitting/2,ep) min(fc_PB_Outer_Pitting+BW_PB_Outer_Pitting/2,PB_Fs/2 -ep)]);
[pEnv_bpf_PB_Outer_Natural, fEnv_bpf_PB_Outer_Natural, xEnv_bpf_PB_Outer_Natural, tEnv_bpf_PB_Outer_Natural] = envspectrum(PB_Outer_Natural.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Outer_Natural-BW_PB_Outer_Natural/2,ep) min(fc_PB_Outer_Natural+BW_PB_Outer_Natural/2,PB_Fs/2 - ep)]);

%Plot the envelope spectrum
upperlim = 1000;
FontSize = 14;

subplot(2,3,1)
plot(fEnv_bpf_CWRU_Normal, pEnv_bpf_CWRU_Normal);
title("CWRU - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFO_CWRU, CWRU_Fr,2)

subplot(2,3,2)
plot(fEnv_bpf_CWRU_Outer,pEnv_bpf_CWRU_Outer);
title("CWRU - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFO_CWRU, CWRU_Fr,2)

subplot(2,3,3)
plot(fEnv_bpf_PB_Normal,pEnv_bpf_PB_Normal);
title("Paderborn - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)

subplot(2,3,4)
plot(fEnv_bpf_PB_Outer_Notch,pEnv_bpf_PB_Outer_Notch);
title("Paderborn - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)

subplot(2,3,5)
plot(fEnv_bpf_PB_Outer_Pitting,pEnv_bpf_PB_Outer_Pitting);
title("Paderborn - Outer Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)

subplot(2,3,6)
plot(fEnv_bpf_PB_Outer_Natural,pEnv_bpf_PB_Outer_Natural);
title("Paderborn - Outer Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
%helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)

linkaxes([subplot(2,3,1), subplot(2,3,2), subplot(2,3,3), subplot(2,3,5), subplot(2,3,6)])

%% Plot combs for Envelope - Outer

upperlim = 1000;
FontSize = 14;

%CWRU OR Point Fault
figure;
plot(fEnv_bpf_CWRU_Outer,pEnv_bpf_CWRU_Outer);
title("CWRU - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFO_CWRU*CWRU_Fr_Outer_Notch, CWRU_Fr_Outer_Notch,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Paderborn OR Point Fault
figure;
plot(fEnv_bpf_PB_Outer_Notch,pEnv_bpf_PB_Outer_Notch);
title("Paderborn - Outer Race Point Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Paderborn OR Pitting Fault
figure;
plot(fEnv_bpf_PB_Outer_Pitting,pEnv_bpf_PB_Outer_Pitting);
title("Paderborn - Outer Race Pitting Fault (Notched)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%Paderborn Natural OR Pitting Fault
figure;
plot(fEnv_bpf_PB_Outer_Natural,pEnv_bpf_PB_Outer_Natural);
title("Paderborn - Outer Race Pitting Fault (Natural)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFO_PB,PB_Fr,2)
legend("Signal", "BPFO Harmonics", "BPFO Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)

%------------------------------------------------------------------------------------------------------------------------------------%
%This concludes the envelope analysis. We can now move on to methods that utilise TSA
%------------------------------------------------------------------------------------------------------------------------------------%
%% TSA Generation

OrderList = 1:1:5;      % Keep first 5 harmonics

TSA_Inner_CWRU_Input = [CWRU_Normal';CWRU_Inner_Notch'];                                                                                                    %Combine CWRU Inner signals
TSA_Inner_PB_Input = [PB_Normal.Vib(1,1:256000);PB_Inner_Notch.Vib(1,1:256000);PB_Inner_Pitting.Vib(1,1:256000);PB_Inner_Natural.Vib(1,1:256000)];          %Combine PB Inner signals

TSA_Outer_CWRU_Input = [CWRU_Normal';CWRU_Outer_Notch(1:485000,1)'];                                                                                                    %Combine CWRU Outer signals
TSA_Outer_PB_Input = [PB_Normal.Vib(1,1:256000);PB_Outer_Notch.Vib(1,1:256000);PB_Outer_Pitting.Vib(1,1:256000);PB_Outer_Natural.Vib(1,1:256000)];          %Combine PB Outer signals

[TSA_Inner_CWRU,TSA_RES_Inner_CWRU,TSA_DIFF_Inner_CWRU,TSA_REG_Inner_CWRU] = TSASignals2(TSA_Inner_CWRU_Input,CWRU_Fs,BPFI_CWRU,OrderList);

[TSA_Inner_PB,TSA_RES_Inner_PB,TSA_DIFF_Inner_PB,TSA_REG_Inner_PB] = TSASignals2(TSA_Inner_PB_Input,PB_Fs,BPFI_PB,OrderList);

[TSA_Outer_CWRU,TSA_RES_Outer_CWRU,TSA_DIFF_Outer_CWRU,TSA_REG_Outer_CWRU] = TSASignals2(TSA_Outer_CWRU_Input,CWRU_Fs,BPFO_CWRU,OrderList);

[TSA_Outer_PB,TSA_RES_Outer_PB,TSA_DIFF_Outer_PB,TSA_REG_Outer_PB] = TSASignals2(TSA_Outer_PB_Input,PB_Fs,BPFO_PB,OrderList);


%% Statistical measures

T_Inner = table('Size',[6 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});

T_Outer = table('Size',[6 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});

for i = 1:4
    T_Inner{i,'TSA'} = {TSA_Inner_PB(i,:)'};
    T_Inner{i,'Diff'} = {TSA_DIFF_Inner_PB(i,:)'};
    T_Inner{i,'Reg'} = {TSA_REG_Inner_PB(i,:)'};
    T_Inner{i,'Res'} = {TSA_RES_Inner_PB(i,:)'};

    T_Outer{i,'TSA'} = {TSA_Outer_PB(i,:)'};
    T_Outer{i,'Diff'} = {TSA_DIFF_Outer_PB(i,:)'};
    T_Outer{i,'Reg'} = {TSA_REG_Outer_PB(i,:)'};
    T_Outer{i,'Res'} = {TSA_RES_Outer_PB(i,:)'};
end

for i = 1:2
    T_Inner{i+4,'TSA'} = {TSA_Inner_CWRU(i,:)'};
    T_Inner{i+4,'Diff'} = {TSA_DIFF_Inner_CWRU(i,:)'};
    T_Inner{i+4,'Reg'} = {TSA_REG_Inner_CWRU(i,:)'};
    T_Inner{i+4,'Res'} = {TSA_RES_Inner_CWRU(i,:)'};

    T_Outer{i+4,'TSA'} = {TSA_Outer_CWRU(i,:)'};
    T_Outer{i+4,'Diff'} = {TSA_DIFF_Outer_CWRU(i,:)'};
    T_Outer{i+4,'Reg'} = {TSA_REG_Outer_CWRU(i,:)'};
    T_Outer{i+4,'Res'} = {TSA_RES_Outer_CWRU(i,:)'};
   
end

[gearMetrics_Inner,info_Inner] = gearConditionMetrics(T_Inner,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res');
gearMetrics_Inner.Properties.RowNames = {'PB Normal', 'PB Inner Notch', 'PB Inner Pitting', 'PB Inner Natural', 'CWRU Normal', 'CWRU Inner Notch'};

[gearMetrics_Outer,info_Outer] = gearConditionMetrics(T_Outer,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res');
gearMetrics_Outer.Properties.RowNames = {'PB Normal', 'PB Outer Notch', 'PB Outer Pitting', 'PB Outer Natural', 'CWRU Normal', 'CWRU Outer Notch'};




















