%% Load bearing
clear all

% Load KI05
i = 20;
filename = sprintf("Datasets/Paderborn/Artificial Inner Race/KI05 Extracted/KI05_%d.mat", i);
PB_Faulty = load(filename);
PB_Faulty_Vib = PB_Faulty.Vib;

PB_Normal = load("Datasets/Paderborn/Normal/K005 Extracted/K005_1.mat");

%Parameters

PB_Fs = 64000;
PB_Fr = 1500/60;

%PB data
d_PB = 6.75;                                                    % ball bearing diameter /mm
D_PB = 29.05;                                                   % pitch diameter /mm
n_PB = 8;                                                       % number of balls

BPFO_PB = 0.5*n_PB*PB_Fr*(1-d_PB/D_PB);                         % Outer Race Ballpass Frequency /Hz
BPFI_PB = 0.5*n_PB*PB_Fr*(1+d_PB/D_PB);                         % Inner Race Ballpass Frequency /Hz
FTF_PB = 0.5*PB_Fr*(1-d_PB/D_PB);                               % Fundamental Train Frequency /Hz
BSF_PB = (D_PB*PB_Fr/d_PB)*(1-((d_PB/D_PB)^2));                 % Ball Spin Frequency /Hz


%% Plot time data
FontSize = 20;

%PB - Faulty
subplot(2,1,2)
plot(PB_Faulty.Time,PB_Faulty_Vib)
title("Paderborn - Faulty Time data", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")
set(gca,'FontSize',FontSize)

%PB - Faulty
subplot(2,1,1)
plot(PB_Normal.Time,PB_Normal.Vib)
title("Paderborn - Normal Time data", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
grid on;
xlabel("Time (s)")
ylabel("Acceleration (m/s^2)")
set(gca,'FontSize',FontSize)

linkaxes([subplot(2,1,1) subplot(2,1,2)]);

%% Plot frequency spectrum
upperlim = 1000;

%Notched Point Fault
figure;
[y, x] = FFTPlot(PB_Faulty.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Faulty data with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,1)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 0.01])


%Normal data
figure;
[y, x] = FFTPlot(PB_Normal.Vib, PB_Fs);
plot(x, y,'LineWidth',2)
title("Paderborn - Normal data with Harmonics and Sidebands", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)

xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)",'FontSize',FontSize)
ylabel("Amplitude",'FontSize',FontSize)
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,1)
legend("Signal", "BPFI Harmonics", "BPFI Sidebands",'FontSize', FontSize)
set(gca,'FontSize', FontSize)
ylim([0 0.01])



%% Cepstrum

c_Healthy = cceps(PB_Normal.Vib);
c_Faulty = cceps(PB_Faulty_Vib);

subplot(2,1,1)
plot(PB_Normal.Time,abs(c_Healthy),'LineWidth',2)
helperPlotCombs(200,1/PB_Fr)
title("Cepstrum - Healthy")
legend("Data","Shaft Harmonic")
set(gca,'FontSize',20)
xlabel('Quefrency / s')
ylabel('Amplitude')

subplot(2,1,2)
plot(PB_Faulty.Time,abs(c_Faulty),'LineWidth',2)
helperPlotCombs(200,1/PB_Fr)
title("Cepstrum - Faulty")
xlabel('Quefrency / s')
ylabel('Amplitude')


linkaxes([subplot(2,1,1) subplot(2,1,2)])
xlim([0 0.2])
ylim([0 5])
set(gca,'FontSize',20)

%% Kurtograms

level = 9;

subplot(1,2,1)
kurtogram(PB_Normal.Vib, PB_Fs, level);

subplot(1,2,2)
kurtogram(PB_Faulty.Vib, PB_Fs, level);


[~, ~, ~, fc_PB_Normal, ~, BW_PB_Normal] = kurtogram(PB_Normal.Vib, PB_Fs, level);
[~, ~, ~, fc_PB_Faulty, ~, BW_PB_Faulty] = kurtogram(PB_Faulty.Vib, PB_Fs, level);

ep = 1;
bpf_PB_Normal = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Normal - BW_PB_Normal/2, ep), 'CutoffFrequency2', min(fc_PB_Normal + BW_PB_Normal/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  
bpf_PB_Faulty = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc_PB_Faulty - BW_PB_Faulty/2, ep), 'CutoffFrequency2', min(fc_PB_Faulty + BW_PB_Faulty/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);  

PB_Normal_Bpf = filter(bpf_PB_Normal, PB_Normal.Vib);  
PB_Faulty_Bpf = filter(bpf_PB_Faulty, PB_Faulty.Vib);  

[pEnv_bpf_PB_Normal, fEnv_bpf_PB_Normal, xEnv_bpf_PB_Normal, tEnv_bpf_PB_Normal] = envspectrum(PB_Normal.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Normal-BW_PB_Normal/2,ep) min(fc_PB_Normal+BW_PB_Normal/2,PB_Fs/2 - ep)]);
[pEnv_bpf_PB_Faulty, fEnv_bpf_PB_Faulty, xEnv_bpf_PB_Faulty, tEnv_bpf_PB_Faulty] = envspectrum(PB_Faulty.Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc_PB_Faulty-BW_PB_Faulty/2,ep) min(fc_PB_Faulty+BW_PB_Faulty/2,PB_Fs/2 - ep)]);

%Plot the envelope spectrum
upperlim = 1000;
FontSize = 20;

subplot(2,1,1)
plot(fEnv_bpf_PB_Normal,pEnv_bpf_PB_Normal,'LineWidth',2);
title("Normal Envelope Spectrum", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
legend("Envelope Spectrum", "BPFI Harmonics", "Sidebands")
set(gca,'FontSize',FontSize)

subplot(2,1,2)
plot(fEnv_bpf_PB_Faulty,pEnv_bpf_PB_Faulty,'LineWidth',2);
title("Faulty Envelope Spectrum", 'HorizontalAlignment', 'center', 'VerticalAlignment', 'bottom', 'FontSize', FontSize)
xlim([0 upperlim])
grid on;
xlabel("Frequency (Hz)")
ylabel("Amplitude")
helperPlotCombsSidebands(100,BPFI_PB,PB_Fr,2)
set(gca,'FontSize',FontSize)

%% Spectral Entropy

[se_PB_Normal, te_PB_Normal] = pentropy(PB_Normal.Vib,PB_Fs);

[se_PB_Faulty, te_PB_Faulty] = pentropy(PB_Faulty.Vib,PB_Fs);

subplot(2,1,1)
plot(te_PB_Normal, se_PB_Normal,'LineWidth',2)
ylabel("Spectral Entropy")
xlabel("Time")
title("Normal")
grid on
set(gca,'FontSize',FontSize)

subplot(2,1,2)
plot(te_PB_Faulty, se_PB_Faulty,'LineWidth',2)
ylabel("Spectral Entropy")
xlabel("Time")
title("Faulty")
grid on
set(gca,'FontSize',FontSize)

Normal_SE = pentropy(PB_Normal.Vib,PB_Fs,'Instantaneous',false)

Faulty_SE = pentropy(PB_Faulty.Vib,PB_Fs,'Instantaneous',false)

Var_Normal_SE = var(se_PB_Normal)
Var_Faulty_SE = var(se_PB_Faulty)

%% Gear Condition Metrics


OrderList = 1:1:5;      % Keep first 5 harmonics


[TSA_Normal_PB,TSA_RES_Normal_PB,TSA_DIFF_Normal_PB,TSA_REG_Normal_PB] = TSASignals(PB_Normal.Vib,PB_Fs,BPFI_PB,OrderList);
[TSA_Faulty_PB,TSA_RES_Faulty_PB,TSA_DIFF_Faulty_PB,TSA_REG_Faulty_PB] = TSASignals(PB_Faulty.Vib,PB_Fs,BPFI_PB,OrderList);


T_Normal = table('Size',[1 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});
T_Faulty = table('Size',[1 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});

for i = 1:1

    T_Normal{i,'TSA'} = {TSA_Normal_PB(i,:)'};
    T_Normal{i,'Diff'} = {TSA_DIFF_Normal_PB(i,:)'};
    T_Normal{i,'Reg'} = {TSA_REG_Normal_PB(i,:)'};
    T_Normal{i,'Res'} = {TSA_RES_Normal_PB(i,:)'};

    T_Faulty{i,'TSA'} = {TSA_Faulty_PB(i,:)'};
    T_Faulty{i,'Diff'} = {TSA_DIFF_Faulty_PB(i,:)'};
    T_Faulty{i,'Reg'} = {TSA_REG_Faulty_PB(i,:)'};
    T_Faulty{i,'Res'} = {TSA_RES_Faulty_PB(i,:)'};
end

[gearMetrics_Normal,info_Normal] = gearConditionMetrics(T_Normal,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res')

[gearMetrics_Faulty,info_Faulty] = gearConditionMetrics(T_Faulty,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res')

Ratio = gearMetrics_Faulty./gearMetrics_Normal


%%










