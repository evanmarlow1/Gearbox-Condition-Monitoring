%% Load data

clear all

%PB
PB_Inner = load("Datasets/Paderborn/Natural Outer Race/KA22 Extracted/KA22_15.mat");
PB_Normal = load("Datasets/Paderborn/Normal/K005 Extracted/K005_1.mat");

%Gear
Healthy = load("Datasets/OpenEI/Healthy/H5.mat");
Faulty = load("Datasets/OpenEI/Damaged/D5.mat");

%CWRU
CWRU_Inner_Notch = load("Datasets/CWRU/Outer Race/OR_14_3.mat");
CWRU_Normal = load("Datasets/CWRU/Normal/Normal_3.mat");


%% Set up

Fs = 40000;
Fr = 22.0886 / 60;
Fout = 1800 /60;

GearRatios = [5.71 5.71*3.57 81.49];
%GearRatios = 5.71*3.57;

TestHarmonics = Fout / 4;

Harmonics  = Fr .* GearRatios;

Signal_Length = length(Faulty.AN4);

Time = (0:Signal_Length-1) / Fs;

%% Cepstrum - Wind Turbine


% Initialize a matrix to store results
results_matrix = zeros(8, length(Healthy.AN3)); % Assuming length of cceps result is consistent

for i = 3:10
    % Calculate complex cepstrum for Healthy and Faulty signals
    c_Healthy = cceps(Healthy.(['AN' num2str(i)])); % Concatenate 'AN' with the value of 'i'
    c_Faulty = cceps(Faulty.(['AN' num2str(i)])); % Concatenate 'AN' with the value of 'i'

    % Store the results in the matrix
    results_matrix(i-2, :) = c_Healthy - c_Faulty; % Store the difference of cepstrum results
end


% Plot each row overlaid on top of each other
figure;
hold on;

for i = 1:size(results_matrix, 1)
    subplot(3,3,i)
    plot(Time,abs(results_matrix(i, :)),'LineWidth',2);
    helperPlotCombs(3,1./Harmonics)
    title(['Cepstrum - Sensor ' num2str(i)])
    xlim([0 0.6])
    ylim([0 4])
    xlabel('Quefrency / s');
    ylabel('Amplitude');
    set(gca,'FontSize',14)
end


% hold off;
% xlabel('Quefrency / s');
% ylabel('Amplitude');
% helperPlotCombs(3,1./Harmonics)
% %legend('Sensor 1', 'Sensor 2', 'Sensor 3', 'Sensor 4', 'Sensor 5', 'Sensor 6', 'Sensor 7', 'Sensor 8','LS-ST Rahmonics','IMS-ST Rahmonics','HS-ST Rahmonics');
% title("NREL Difference Cepstrum - All sensors")
% %legend("Data","LS-ST Harmonic","IMS-ST Harmonic","HS-ST Harmonic")
% set(gca,'FontSize',20)

% subplot(2,1,2)
% plot(Time,abs(c_Faulty),'LineWidth',2)
% helperPlotCombs(3,1./Harmonics)
% title("NREL Cepstrum - Faulty")
% xlabel('Quefrency / s')
% ylabel('Amplitude')
% 
% 
% linkaxes([subplot(2,1,1) subplot(2,1,2)])




%% Cepstrum - CWRU

%CWRU data
d_CWRU = 0.2656 * 25.4;                                         % ball bearing diameter /mm
D_CWRU = 1.122 * 25.4;                                          % pitch diameter /mm
n_CWRU = 8;                                                     % number of balls

%These are Harmonics as RPM varies! We need to multiply by Fr's
BPFO_CWRU = 0.5*n_CWRU*(1-d_CWRU/D_CWRU);                       % Outer Race Ballpass Frequency /Hz
BPFI_CWRU = 0.5*n_CWRU*(1+d_CWRU/D_CWRU);                       % Inner Race Ballpass Frequency /Hz
FTF_CWRU = 0.5*(1-d_CWRU/D_CWRU);                               % Fundamental Train Frequency /Hz
BSF_CWRU = (D_CWRU/d_CWRU)*(1-((d_CWRU/D_CWRU)^2));             % Ball Spin Frequency /Hz


CWRU_Fs = 48000;
CWRU_Inner_Length = length(CWRU_Inner_Notch.X204_FE_time);
CWRU_Normal_Length = length(CWRU_Normal.X100_FE_time);

CWRU_Normal_Time = (0:CWRU_Normal_Length-1)/CWRU_Fs;
CWRU_Inner_Time = (0:CWRU_Inner_Length-1)/CWRU_Fs;

CWRU_Normal_Fr = CWRU_Normal.X100RPM/60;
CWRU_Faulty_Fr = CWRU_Inner_Notch.X204RPM/60;

CWRU_Normal_Harmonics = CWRU_Normal_Fr.*[1];
CWRU_Faulty_Harmonics = CWRU_Faulty_Fr.*[1];

%Cepstrum
CWRU_Faulty = cceps(CWRU_Inner_Notch.X204_FE_time);
CWRU_Healthy = cceps(CWRU_Normal.X100_FE_time);

subplot(2,1,1)
plot(CWRU_Normal_Time,abs(CWRU_Healthy),'LineWidth',2)
helperPlotCombs(10,1./CWRU_Normal_Harmonics)
xlabel("Quefrency /s")
ylabel("Amplitude")
set(gca,'FontSize',20)
legend("Data","Shaft Rahmonics")
title("CWRU - Healthy Cepstrum")

subplot(2,1,2)
plot(CWRU_Inner_Time,abs(CWRU_Faulty),'LineWidth',2)
helperPlotCombs(10,1./CWRU_Faulty_Harmonics)
xlabel("Quefrency /s")
ylabel("Amplitude")
title("CWRU - Faulty Cepstrum")

linkaxes([subplot(2,1,1) subplot(2,1,2)])
xlim([0 0.4])
ylim([0 1])
set(gca,'FontSize',20)


%% Cepstrum - PB

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

PB_Harmonics = PB_Fr;

%Cepstrum

PB_Healthy = cceps(PB_Normal.Vib);
PB_Healthy_Time = PB_Normal.Time;

PB_Faulty = cceps(PB_Inner.Vib);
PB_Faulty_Time = PB_Inner.Time;

%Cepstrum plots

subplot(2,1,1)
plot(PB_Healthy_Time,abs(PB_Healthy),'LineWidth',2)
helperPlotCombs(10,1./PB_Harmonics)
xlabel("Quefrency /s")
ylabel("Amplitude")
set(gca,'FontSize',20)
legend("Data","Shaft Rahmonics")
title("PB - Healthy Cepstrum")

subplot(2,1,2)
plot(PB_Faulty_Time,abs(PB_Faulty),'LineWidth',2)
helperPlotCombs(10,1./PB_Harmonics)
xlabel("Quefrency /s")
ylabel("Amplitude")
set(gca,'FontSize',20)
legend("Data","Shaft Rahmonics")
title("PB - Faulty Cepstrum")


linkaxes([subplot(2,1,1) subplot(2,1,2)])
xlim([0 0.1])
ylim([0 1])
set(gca,'FontSize',20)

