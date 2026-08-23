%% Clear

clear all

%% Load data

CWRU_Inner_Notch = load("Datasets/CWRU/Inner Race/IR_07_3.mat");
PB_Inner_Notch = load("Datasets/Paderborn/Artificial Inner Race/KI01 Extracted/KI01_2.mat");
PB_Inner_Pitting = load("Datasets/Paderborn/Artificial Inner Race/KI03 Extracted/KI03_1.mat");
PB_Inner_Natural = load("Datasets/Paderborn/Natural Inner Race/KI04 Extracted/KI04_1.mat");

CWRU_Fr_Inner_Notch = CWRU_Inner_Notch.X112RPM/60;
CWRU_Inner_Notch = CWRU_Inner_Notch.X112_FE_time(1:485000);


CWRU_Outer_Notch = load("Datasets/CWRU/Outer Race/OR_07_3.mat");
PB_Outer_Notch = load("Datasets/Paderborn/Artificial Outer Race/KA01 Extracted/KA01_1.mat");
PB_Outer_Pitting = load("Datasets/Paderborn/Artificial Outer Race/KA05 Extracted/KA05_1.mat");
PB_Outer_Natural = load("Datasets/Paderborn/Natural Outer Race/KA04 Extracted/KA04_1.mat");

CWRU_Fr_Outer_Notch = CWRU_Outer_Notch.X138RPM/60;
CWRU_Outer_Notch = CWRU_Outer_Notch.X138_FE_time(1:485000);

CWRU_Ball_Notch = load("Datasets/CWRU/Ball/B_07_3.mat");

CWRU_Fr_Ball_Notch = CWRU_Ball_Notch.X125RPM/60;
CWRU_Ball_Notch = CWRU_Ball_Notch.X125_FE_time(1:485000);



CWRU_Normal = load("Datasets/CWRU/Normal/Normal_3.mat");
PB_Normal = load("Datasets/Paderborn/Normal/K005 Extracted/K005_1.mat");

CWRU_Fr_Normal = CWRU_Normal.X100RPM/60;
CWRU_Normal = CWRU_Normal.X100_FE_time(1:485000);



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


%% Raw Frequency

upperlim = 1000;
FontSize = 14;
upperlim2 = 32000;

subplot(2,2,1)
[y, x] = FFTPlot(PB_Normal.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Normal", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
xlim([0 upperlim2])
set(gca,'FontSize',FontSize)

subplot(2,2,2)
[y, x] = FFTPlot(PB_Outer_Notch.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Inner Race, Seeded", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
xlim([0 upperlim2])
set(gca,'FontSize',FontSize)


subplot(2,2,3)
[y, x] = FFTPlot(PB_Normal.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Normal (Zoomed)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
ylim([0 0.0035])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100, BPFI_PB, PB_Fr,2)
legend("Signal","IR Harmonics","Sidebands")
set(gca,'FontSize',FontSize)


subplot(2,2,4)
[y, x] = FFTPlot(PB_Inner_Notch.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Inner Race, Seeded (Zoomed)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100, BPFI_PB, PB_Fr,2)
xlim([0 upperlim])
ylim([0 0.05])
set(gca,'FontSize',FontSize)


%% OR

subplot(1,2,1)
[y, x] = FFTPlot(PB_Outer_Notch.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Outer Race, Seeded (Zoomed)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100, BPFO_PB, PB_Fr,2)
xlim([0 upperlim])
set(gca,'FontSize',FontSize)
ylim([0 0.014])

subplot(1,2,2)
[y, x] = FFTPlot(PB_Outer_Pitting.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Outer Race Pitting, Seeded (Zoomed)", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100, BPFO_PB, PB_Fr,2)
xlim([0 upperlim])
legend("Signal", "OR Harmonics", "Sidebands")
set(gca,'FontSize',FontSize)
ylim([0 0.014])


%% Kurtogram
Fs = CWRU_Fs;
level = 9;
FontSize = 14;


signal = CWRU_Inner_Notch;
[~, ~, ~, fc, ~, BW] = kurtogram(signal, Fs, level);    % Get optimum values from kurtogram
ep = 1;
bpf = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc - BW/2, ep), 'CutoffFrequency2', min(fc + BW/2, Fs/2 - ep), 'SampleRate', Fs);
signal_bpf = filter(bpf, signal);
[pEnv_bpf, fEnv_bpf, xEnv_bpf, tEnv_bpf] = envspectrum(signal, Fs, 'FilterOrder', 200, 'Band', [max(fc-BW/2,ep) min(fc+BW/2,Fs/2 - ep)]);


%Plot
figure;
[y, x] = FFTPlot(signal,Fs);
plot(x, y,'LineWidth',2)
title("CWRU, IR Seeded Fault, Raw Spectrum", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
xlim([0 1000])
helperPlotCombsSidebands(100,BPFI_CWRU*CWRU_Fr_Inner_Notch,CWRU_Fr_Inner_Notch,2)
legend("Signal","IR Harmonics","Sidebands")
set(gca,'FontSize',FontSize)

figure;
kurtogram(signal,CWRU_Fs,level)
set(gca,'FontSize',FontSize)

figure;
plot(fEnv_bpf, pEnv_bpf,'LineWidth',2);
xlabel("Frequency /Hz")
ylabel("Amplitude")
title("CWRU, IR Seeded Fault, Envelope Spectrum")
xlim([0 1000])
helperPlotCombsSidebands(100,BPFI_CWRU*CWRU_Fr_Inner_Notch,CWRU_Fr_Inner_Notch,2)
legend("Signal","IR Harmonics","Sidebands")
set(gca,'FontSize',FontSize)



%% Cepstrum

CWRU_Outer_Ceps = load("Datasets/CWRU/Outer Race/OR_14_3.mat");

CWRU_Inner_Ceps = load("Datasets/CWRU/Inner Race/IR_14_3.mat");

CWRU_Inner_Length = length(CWRU_Inner_Ceps.X177_FE_time);

CWRU_Inner_Time = (0:CWRU_Inner_Length-1)/CWRU_Fs;

CWRU_Inner = cceps(CWRU_Inner_Ceps.X177_FE_time);

CWRU_Fr_Inner_Notch2 = CWRU_Fr_Inner_Notch /5;
CWRU_Fr_Outer_Notch2 = CWRU_Fr_Outer_Notch;


subplot(2,1,1)
plot(CWRU_Inner_Time,abs(CWRU_Inner),'LineWidth',2)
helperPlotCombs(10,1./CWRU_Fr_Inner_Notch2)
xlabel("Quefrency /s")
ylabel("Amplitude")
set(gca,'FontSize',20)
legend("Data","Shaft Rahmonics")
title("CWRU - Inner Cepstrum")
xlim([0 0.4])
ylim([0 1])


CWRU_Outer = cceps(CWRU_Outer_Ceps.X204_FE_time);

CWRU_Outer_Length = length(CWRU_Outer_Ceps.X204_FE_time);
CWRU_Outer_Time = (0:CWRU_Outer_Length-1)/CWRU_Fs;

subplot(2,1,2)
plot(CWRU_Outer_Time,abs(CWRU_Outer),'LineWidth',2)
helperPlotCombs(10,1./CWRU_Fr_Outer_Notch2)
xlabel("Quefrency /s")
ylabel("Amplitude")
set(gca,'FontSize',20)
legend("Data","Shaft Rahmonics")
title("CWRU - Outer Cepstrum")
xlim([0 0.4])
ylim([0 1])



