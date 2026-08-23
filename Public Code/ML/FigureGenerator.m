
PB_Fr = 1500/60;
PB_Fs = 64000;

%PB data
d_PB = 6.75;                                                    % ball bearing diameter /mm
D_PB = 29.05;                                                   % pitch diameter /mm
n_PB = 8;                                                       % number of balls

BPFO_PB = 0.5*n_PB*PB_Fr*(1-d_PB/D_PB);                         % Outer Race Ballpass Frequency /Hz
BPFI_PB = 0.5*n_PB*PB_Fr*(1+d_PB/D_PB);                         % Inner Race Ballpass Frequency /Hz
FTF_PB = 0.5*PB_Fr*(1-d_PB/D_PB);                               % Fundamental Train Frequency /Hz
BSF_PB = (D_PB*PB_Fr/d_PB)*(1-((d_PB/D_PB)^2));                 % Ball Spin Frequency /Hz

HARMONIC = BPFI_PB;

[a b] = FFTPlot(Vib, PB_Fs);

plot(b(3:end),a(3:end),'LineWidth',2)
helperPlotCombsSidebands(100,HARMONIC,PB_Fr,2)
xlim([0 1000])
legend('Signal', ' BPFI Harmonics', ' BPFI Sidebands')
xlabel('Frequency / Hz')
ylabel('Amplitude')
title('Raw Frequency Spectrum for level 2 fault')
set(gca, 'FontSize', 20);            % Default font size for other text

%Envelope

level = 9;
ep = 0.001;

[~, ~, ~, fc, ~, BW] = kurtogram(Vib, PB_Fs, level);
bpf = designfilt('bandpassfir', 'FilterOrder', 200, 'CutoffFrequency1', max(fc - BW, ep), 'CutoffFrequency2', min(fc + BW/2, PB_Fs/2 - ep), 'SampleRate', PB_Fs);
Signal_BPF = filter(bpf, Vib); 

[pEnv_bpf, fEnv_bpf, xEnv_bpf, tEnv_bpf] = envspectrum(Vib, PB_Fs, 'FilterOrder', 200, 'Band', [max(fc-BW/2,ep) min(fc+BW/2,PB_Fs/2 - ep)]);

figure;
plot(fEnv_bpf,pEnv_bpf,'LineWidth',2)
xlim([0 1000])
helperPlotCombsSidebands(100,HARMONIC,PB_Fr,2)
legend('Signal', ' BPFI Harmonics', ' BPFI Sidebands')
xlabel('Frequency / Hz')
ylabel('Amplitude')
title('Envelope Spectrum for level 2 fault')
set(gca, 'FontSize', 20);            % Default font size for other text










