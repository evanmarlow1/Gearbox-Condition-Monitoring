
clear all

N_Split_CWRU = 15;
CWRU_Fs = 48000;
N_Datapoints_CWRU = 480000; 

%Initialise CWRU Table
CWRUTables = cell(N_Split_CWRU,1); 

BPF = 5000;


CWRU_Normal = load("Datasets/CWRU/Normal/Normal_3.mat");
%CWRU_Normal_Vib = highpass(CWRU_Normal.X100_FE_time(1:N_Datapoints_CWRU),BPF,CWRU_Fs);
CWRU_Normal_Vib = CWRU_Normal.X100_FE_time(1:N_Datapoints_CWRU);

% Inner 14 Data
CWRU_Inner14 = load("Datasets/CWRU/Inner Race/IR_14_3.mat");
%CWRU_Faulty_Vib = highpass(CWRU_Inner14.X177_FE_time(1:N_Datapoints_CWRU),BPF,CWRU_Fs);
CWRU_Faulty_Vib = CWRU_Inner14.X177_FE_time(1:N_Datapoints_CWRU);



UpperSplit = 5;
SampleSizes = zeros(UpperSplit,1);
SpectralEntNormal = zeros(UpperSplit,1);
SpectralEntFaulty = zeros(UpperSplit,1);

SampleSizeTable = table(SampleSizes,SpectralEntNormal,SpectralEntFaulty,'VariableNames',{'Number of Samples','Average SE Normal', 'Average SE Faulty'});

for i = 1:UpperSplit

    N_Split_CWRU = i;
    CWRU_Normal_Split = SplitData(CWRU_Normal_Vib,N_Split_CWRU);
    CWRU_Inner14_Split = SplitData(CWRU_Faulty_Vib,N_Split_CWRU);

    SpectralEntropyArrayNormal = zeros(1,N_Split_CWRU);
    SpectralEntropyArrayFaulty = zeros(1,N_Split_CWRU);

    for j = 1:N_Split_CWRU              
        Current_Vib = CWRU_Normal_Split(j,:);
        % Convert to timetable
        CWRUNormalTable = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
        SpectralEntropy = pentropy(CWRUNormalTable, 'Instantaneous',false);
        SpectralEntropyArrayNormal(j) = SpectralEntropy;

        Current_Vib = CWRU_Inner14_Split(j,:);
        % Convert to timetable
        CWRUFaultyTable = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
        SpectralEntropy = pentropy(CWRUFaultyTable,'Instantaneous',false,'Scaled',true);
        SpectralEntropyArrayFaulty(j) = SpectralEntropy;
    end
    
    SampleSizeTable{i,1} = i;
    SampleSizeTable{i,2} = mean(SpectralEntropyArrayNormal);
    SampleSizeTable{i,3} = mean(SpectralEntropyArrayFaulty);

end

%% Plot

plot(SampleSizeTable{:,1},SampleSizeTable{:,2},'LineWidth',2)
hold on
plot(SampleSizeTable{:,1},SampleSizeTable{:,3},'LineWidth',2)
xlabel('Number of samples per signal')
ylabel('Average Spectral Entropy')
set(gca,'FontSize',20)
title('Spectral Entropy vs Sample Size Test')
%ylim([0.6 0.85])
legend('Healthy', 'Faulty')


%% Spectrograms

CWRU_Normal = load("Datasets/CWRU/Normal/Normal_3.mat");
CWRU_Inner14 = load("Datasets/CWRU/Inner Race/IR_14_3.mat");

N_Datapoints_CWRU = 480000;
CWRU_Fs = 48000;

CWRU_Normal_Vib = CWRU_Normal.X100_FE_time(1:N_Datapoints_CWRU);
CWRU_Faulty_Vib = CWRU_Inner14.X177_FE_time(1:N_Datapoints_CWRU);


M = 49;
L = 11;
g = bartlett(M);
Ndft = 1024;


[s_Normal,f_Normal,t_Normal] = spectrogram(CWRU_Normal_Vib,g,L,Ndft,CWRU_Fs);

waterplot(s_Normal,f_Normal,t_Normal)
title("CWRU Normal")

[s_Faulty,f_Faulty,t_Faulty] = spectrogram(CWRU_Faulty_Vib,g,L,Ndft,CWRU_Fs);

figure;
waterplot(s_Faulty,f_Faulty,t_Faulty)
title("CWRU Faulty")

% Paderborn
N_Datapoints = 250000; 

PB_Normal = load("Datasets/Paderborn/Normal/K001 Extracted/K001_3.mat");
PB_Normal_Vib = PB_Normal.Vib(1:N_Datapoints);

[s_PB,f_PB,t_PB] = spectrogram(PB_Normal_Vib,g,L,Ndft,64000);

figure;
waterplot(s_PB,f_PB,t_PB)
title("PB Normal")

PB_Faulty = load("Datasets/Paderborn/Artificial Inner Race/KI01 Extracted/KI01_1.mat");
PB_Faulty_Vib = PB_Faulty.Vib(1:N_Datapoints);

[s_PB_F,f_PB_F,t_PB_F] = spectrogram(PB_Faulty_Vib,g,L,Ndft,64000);

figure;
waterplot(s_PB_F,f_PB_F,t_PB_F)
title("PB Faulty")


%% WVD
CWRU_Fs = 48000;
PB_Fs = 64000;
split = 29;

CWRU_Normal_Split = SplitData(CWRU_Normal_Vib,split);
CWRU_Faulty_Split = SplitData(CWRU_Faulty_Vib,split);
PB_Normal_Split = SplitData(PB_Normal_Vib,split);
PB_Faulty_Split = SplitData(PB_Faulty_Vib,split);

% subplot(2,2,1)
% wvd(CWRU_Normal_Split(3,:),CWRU_Fs,"MinThreshold",0)
% title("CWRU Normal")
% set(gca,'FontSize',20)
% 
% subplot(2,2,3)
% wvd(CWRU_Faulty_Split(3,:),CWRU_Fs,"MinThreshold",0)
% title("CWRU Faulty")
% set(gca,'FontSize',20)
% 
% subplot(2,2,2)
% wvd(PB_Normal_Split(3,:),PB_Fs,"MinThreshold",0)
% title("PB Normal")
% set(gca,'FontSize',20)
% 
% subplot(2,2,4)
% wvd(PB_Faulty_Split(3,:),PB_Fs,'MinThreshold',0)
% title("PB Faulty")
% set(gca,'FontSize',20)






%% Cepstrum
CWRU_Normal_Fr = CWRU_Normal.X100RPM /60;
CWRU_Faulty_Fr = CWRU_Inner14.X177RPM /60;

C_faulty_PB = cceps(PB_Faulty_Vib);
C_faulty_PB = abs(C_faulty_PB);

C_normal_PB = cceps(PB_Normal_Vib);
C_normal_PB = abs(C_normal_PB);

C_faulty_CWRU = cceps(CWRU_Faulty_Vib);
C_faulty_CWRU = abs(C_faulty_CWRU);

C_normal_CWRU = cceps(CWRU_Normal_Vib);
C_normal_CWRU = abs(C_normal_CWRU);

T_faulty_PB = PB_Faulty.Time(1:N_Datapoints);
T_normal_PB = PB_Normal.Time(1:N_Datapoints);


CWRU_Length = length(CWRU_Faulty_Vib);
CWRU_Time = (0:CWRU_Length-1) / CWRU_Fs;

subplot(1,2,1)
plot(T_normal_PB, C_normal_PB)
title("PB Normal")
helperPlotCombsSidebands(100,1/BPFI_PB,1/25,2)


subplot(1,2,2)
plot(T_faulty_PB, C_faulty_PB)
title("PB Faulty")
helperPlotCombsSidebands(100,1/BPFI_PB,1/25,2)

linkaxes([subplot(1,2,1),subplot(1,2,2)])



figure;

diff = C_faulty_CWRU - C_normal_CWRU;
plot(CWRU_Time,diff)
helperPlotCombs(100,1/(CWRU_Faulty_Fr * BPFI_CWRU))




function waterplot(s,f,t)
% Waterfall plot of spectrogram
    waterfall(f,t,abs(s)'.^2)
    set(gca,XDir="reverse",View=[30 50])
    xlabel("Frequency (Hz)")
    ylabel("Time (s)")
end



