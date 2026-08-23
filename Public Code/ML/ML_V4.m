%% clear
clear all

% Version 4 - All Key Signals, 2 Classes, PB and CWRU, Split data, RPM Signal
%----------------------------------------------------------------------------------------------------------------------------------------%
%This Script conducts the feature extraction and classification of the data for all classes.
%
% We first need to load the data in a structure that is organised and compatible with the Diagnostic Feature Designer App.
%
% We will begin by loading the datasets.
%
% We split each signal into multiple samples to decrease overfitting issues.
%
%----------------------------------------------------------------------------------------------------------------------------------------%

%% Initialise

%Change split length as desired.
N_Split = 0;
N_Split_CWRU = 25;

% Initialize tables
num_signals_PB = 7*20*N_Split;         % 7 Signals * 20 runs * N_Split Samples (for Paderborn)

VibrationTables = cell(num_signals_PB, 1);
faultCode = zeros(num_signals_PB+7*N_Split_CWRU,1);   
TachoTables = cell(num_signals_PB,1);
RPMTables = cell(num_signals_PB,1);

%% Paderborn Data

%Variables for setup
N_Datapoints = 250000;      %How many datapoints we're limiting the raw signal to for consistency.
%N_Split = 50;               %How many samples we're splitting each signal into.
PB_Fs = 64000;              %Sample rate for Paderborn data.
Signal_Gap = 20*N_Split;    %Index offset between signals


%Set up Pseudo Tachometer data (future proofing for transient signals).
PseudoTacho = generateTachoSignal(1500,PB_Fs,N_Datapoints/N_Split - 1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',PB_Fs);

%Set up Pseudo RPM Signal
PseudoRPM = generateRPMSignal(1500,PB_Fs,N_Datapoints/N_Split - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate', PB_Fs);


%Load all Paderborn Samples
for i = 1:20

    %Normal Data

    % Load Normal PB data
    filename = sprintf("Datasets/Paderborn/Normal/K001 Extracted/K001_%d.mat", i);
    PB_Normal = load(filename);
    PB_Normal_Vib = SplitData(PB_Normal.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Normal_Vib(j,:);
        % Convert to timetable
        normalTable = timetable(Current_Vib','SampleRate',PB_Fs,'VariableNames',{'Vibration'});
        VibrationTables{N_Split*(i-1) + j} = normalTable;
        TachoTables{N_Split*(i-1) + j} = PseudoTachotable;
        RPMTables{N_Split*(i-1) + j} = PseudoRPMtable;
    end
    
    
    %Inner Data

    % Load Notched Point Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Inner Race/KI01 Extracted/KI01_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);
   
    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib', 'SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        VibrationTables{Signal_Gap + N_Split*(i-1) + j} = faultyTable;
        TachoTables{Signal_Gap + N_Split*(i-1) + j} = PseudoTachotable;
        RPMTables{Signal_Gap + N_Split*(i-1) + j} = PseudoRPMtable;
    end

    % Load Notched Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Inner Race/KI03 Extracted/KI03_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib', 'SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        VibrationTables{2*Signal_Gap + N_Split*(i-1) + j} = faultyTable;
        TachoTables{2*Signal_Gap + N_Split*(i-1) + j} = PseudoTachotable;
        RPMTables{2*Signal_Gap + N_Split*(i-1) + j} = PseudoRPMtable;
    end
    
    % Load Natural Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Natural Inner Race/KI04 Extracted/KI04_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib', 'SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        VibrationTables{3*Signal_Gap + N_Split*(i-1) + j} = faultyTable;
        TachoTables{3*Signal_Gap + N_Split*(i-1) + j} = PseudoTachotable;
        RPMTables{3*Signal_Gap + N_Split*(i-1) + j} = PseudoRPMtable;
    end
    

    %Outer data


    % Load Notched Point Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Outer Race/KA01 Extracted/KA01_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);
    
    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib','SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        VibrationTables{4 * Signal_Gap + N_Split*(i-1) + j} = faultyTable;
        TachoTables{4 * Signal_Gap + N_Split*(i-1) + j} = PseudoTachotable;
        RPMTables{4 * Signal_Gap + N_Split*(i-1) + j} = PseudoRPMtable;
    end
   
    
    % Load Notched Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Outer Race/KA05 Extracted/KA05_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);
    
    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        %Convert to timetable
        faultyTable = timetable(Current_Vib','SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        VibrationTables{5*Signal_Gap + N_Split*(i-1) + j} = faultyTable;
        TachoTables{5 * Signal_Gap + N_Split*(i-1) + j} = PseudoTachotable;
        RPMTables{5 * Signal_Gap + N_Split*(i-1) + j} = PseudoRPMtable;
    end
 

    % Load Natural Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Natural Outer Race/KA04 Extracted/KA04_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib', 'SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        VibrationTables{6 * Signal_Gap + N_Split*(i-1) + j} = faultyTable;
        TachoTables{6 * Signal_Gap + N_Split*(i-1) + j} = PseudoTachotable;
        RPMTables{6 * Signal_Gap + N_Split*(i-1) + j} = PseudoRPMtable;
    end
    
end


%% CWRU Data

i = 20*N_Split*7;               %Number of PB Signals.
N_Datapoints_CWRU = 485000;     %How many datapoints we're limiting the raw signal to for consistency.
CWRU_Fs = 48000;                %Sample rate for CWRU data.
%N_Split_CWRU = 50;              %Number of samples we are splitting each signal into.

%Initialise CWRU Table
CWRUTables = cell(7*N_Split_CWRU,1);   


% Normal data
CWRU_Normal = load("Datasets/CWRU/Normal/Normal_3.mat");
CWRU_Normal_Split = SplitData(CWRU_Normal.X100_FE_time(1:N_Datapoints_CWRU),N_Split_CWRU);

% Normal Tachometer signal
RPM = CWRU_Normal.X100RPM;
PseudoTacho = generateTachoSignal(RPM,CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU -1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',CWRU_Fs);
PseudoRPM = generateRPMSignal(RPM, CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate',CWRU_Fs);

for j = 1:N_Split_CWRU
    Current_Vib = CWRU_Normal_Split(j,:);
    % Convert to timetable
    CWRUNormalTable = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
    VibrationTables{i+j} = CWRUNormalTable;
    CWRUTables{j} = CWRUNormalTable;
    TachoTables{i+j} = PseudoTachotable;
    RPMTables{i+j} = PseudoRPMtable;
end


% Inner 7 data
CWRU_Inner7 = load("Datasets/CWRU/Inner Race/IR_07_3.mat");
CWRU_Inner7_Split = SplitData(CWRU_Inner7.X112_FE_time(1:N_Datapoints_CWRU),N_Split_CWRU);

% Inner 7 Tachometer signal
RPM = CWRU_Inner7.X112RPM;
PseudoTacho = generateTachoSignal(RPM,CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU -1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',CWRU_Fs);
PseudoRPM = generateRPMSignal(RPM, CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate',CWRU_Fs);

for j = 1:N_Split_CWRU
    Current_Vib = CWRU_Inner7_Split(j,:);
    % Convert to timetable
    CWRUInner7Table = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
    VibrationTables{i+j+1*N_Split_CWRU} = CWRUInner7Table;
    CWRUTables{j+1*N_Split_CWRU} = CWRUInner7Table;
    TachoTables{i+j+1*N_Split_CWRU} = PseudoTachotable;
    RPMTables{i+j+1*N_Split_CWRU} = PseudoRPMtable;
end


% Inner 14 Data
CWRU_Inner14 = load("Datasets/CWRU/Inner Race/IR_14_3.mat");
CWRU_Inner14_Split = SplitData(CWRU_Inner14.X177_FE_time(1:N_Datapoints_CWRU),N_Split_CWRU);

% Inner 14 Tachometer signal
RPM = CWRU_Inner14.X177RPM;
PseudoTacho = generateTachoSignal(RPM,CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',CWRU_Fs);
PseudoRPM = generateRPMSignal(RPM, CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate',CWRU_Fs);

for j = 1:N_Split_CWRU
    Current_Vib = CWRU_Inner14_Split(j,:);
    % Convert to timetable
    CWRUInner14Table = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
    VibrationTables{i+j+2*N_Split_CWRU} = CWRUInner14Table;
    CWRUTables{j+2*N_Split_CWRU} = CWRUInner14Table;
    TachoTables{i+j+2*N_Split_CWRU} = PseudoTachotable;
    RPMTables{i+j+2*N_Split_CWRU} = PseudoRPMtable;
end


% Inner 21 Data
CWRU_Inner21 = load("Datasets/CWRU/Inner Race/IR_21_3.mat");
CWRU_Inner21_Split = SplitData(CWRU_Inner21.X215_FE_time(1:N_Datapoints_CWRU),N_Split_CWRU);

% Inner 21 Tachometer Signal
RPM = CWRU_Inner21.X215RPM;
PseudoTacho = generateTachoSignal(RPM,CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',CWRU_Fs);
PseudoRPM = generateRPMSignal(RPM, CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate',CWRU_Fs);

for j = 1:N_Split_CWRU
    Current_Vib = CWRU_Inner21_Split(j,:);
    % Convert to timetable
    CWRUInner21Table = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
    VibrationTables{i+j+3*N_Split_CWRU} = CWRUInner21Table;
    CWRUTables{j + 3*N_Split_CWRU} = CWRUInner21Table;
    TachoTables{i+j+3*N_Split_CWRU} = PseudoTachotable;
    RPMTables{i+j+3*N_Split_CWRU} = PseudoRPMtable;
end


%Outer data

% Outer 7 Data
CWRU_Outer7 = load("Datasets/CWRU/Outer Race/OR_07_3.mat");
CWRU_Outer7_Split = SplitData(CWRU_Outer7.X138_FE_time(1:N_Datapoints_CWRU),N_Split_CWRU);

% Outer 7 Tachometer Signal
RPM = CWRU_Outer7.X138RPM;
PseudoTacho = generateTachoSignal(RPM,CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',CWRU_Fs);
PseudoRPM = generateRPMSignal(RPM, CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate',CWRU_Fs);

for j = 1:N_Split_CWRU
    Current_Vib = CWRU_Outer7_Split(j,:);
    % Convert to timetable
    CWRUOuter7Table = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
    VibrationTables{i+j+4*N_Split_CWRU} = CWRUOuter7Table;
    CWRUTables{j+4*N_Split_CWRU} = CWRUOuter7Table;
    TachoTables{i+j+4*N_Split_CWRU} = PseudoTachotable;
    RPMTables{i+j+4*N_Split_CWRU} = PseudoRPMtable;
end


% Outer 14 Data
CWRU_Outer14 = load("Datasets/CWRU/Outer Race/OR_14_3.mat");
CWRU_Outer14_Split = SplitData(CWRU_Outer14.X204_FE_time(1:N_Datapoints_CWRU),N_Split_CWRU);

% Outer 14 Tachometer Signal
RPM = CWRU_Outer14.X204RPM;
PseudoTacho = generateTachoSignal(RPM,CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',CWRU_Fs);
PseudoRPM = generateRPMSignal(RPM, CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate',CWRU_Fs);

for j = 1:N_Split_CWRU
    Current_Vib = CWRU_Outer14_Split(j,:);
    CWRUOuter14Table = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
    VibrationTables{i+j+5*N_Split_CWRU} = CWRUOuter14Table;
    CWRUTables{j+5*N_Split_CWRU} = CWRUOuter14Table;
    TachoTables{i+j+5*N_Split_CWRU} = PseudoTachotable;
    RPMTables{i+j+5*N_Split_CWRU} = PseudoRPMtable;
end


% Outer 21 Data
CWRU_Outer21 = load("Datasets/CWRU/Outer Race/OR_21_3.mat");
CWRU_Outer21_Split = SplitData(CWRU_Outer21.X241_FE_time(1:N_Datapoints_CWRU),N_Split_CWRU);

% Outer 21 Tachometer Signal
RPM = CWRU_Outer21.X241RPM;
PseudoTacho = generateTachoSignal(RPM,CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',CWRU_Fs);
PseudoRPM = generateRPMSignal(RPM, CWRU_Fs,N_Datapoints_CWRU/N_Split_CWRU - 1);
PseudoRPMtable = timetable(PseudoRPM','VariableNames', {'RPM'}, 'SampleRate',CWRU_Fs);

for j = 1:N_Split_CWRU
    Current_Vib = CWRU_Outer21_Split(j,:);
    CWRUOuter21Table = timetable(Current_Vib','SampleRate',CWRU_Fs,'VariableNames',{'Vibration'});
    VibrationTables{i+j+6*N_Split_CWRU} = CWRUOuter21Table;
    CWRUTables{j+6*N_Split_CWRU} = CWRUOuter21Table;
    TachoTables{i+j+6*N_Split_CWRU} = PseudoTachotable;
    RPMTables{i+j+6*N_Split_CWRU} = PseudoRPMtable;
end


%---------------------------------------------------------------------------------------------------------------
%Test with CWRU
%---------------------------------------------------------------------------------------------------------------

CWRUFault = ones(7*N_Split_CWRU,1);
CWRUTacho = cell(7*N_Split_CWRU,1);
CWRURPM = cell(7*N_Split_CWRU,1);

for j = 1:7*N_Split_CWRU
    CWRUTacho{j} = TachoTables(i+j);
    CWRURPM{j} = RPMTables(i+j);
end

CWRUFault(1:N_Split_CWRU) = 0;

CWRUTestTable = table(CWRUTables, CWRUTacho, CWRURPM, CWRUFault, 'VariableNames', {'Vibration','Tachometer','RPM','faultCode'});

%% Fault codes and final table

% Set faultCode - we have Faulty and Healthy for now
%faultCode(1:20*N_Split) = 0;
%faultCode(20*N_Split+1:7*20*N_Split) = 1;
faultCode(i+1:end) = CWRUFault;



% Create the final table - Edit this to change faultCode
dataTable = table(VibrationTables, TachoTables, RPMTables, faultCode, 'VariableNames', {'Vibration','Tachometer','RPM','faultCode'});

% Display the final table
disp(dataTable);

%% Split into training and test data

% Define the ratio for training and test split
splitRatio = 0.8;

% Initialize variables to store training and test indices
trainingIndices = [];
TestIndices = [];

%Set random seed for reproducability
rng('default')

% Loop through each fault type
for faultType = unique(dataTable.faultCode)'
    % Find indices of the current fault type
    indices = find(dataTable.faultCode == faultType);

    % Calculate the number of samples for training
    numTraining = round(splitRatio * numel(indices));

    % Randomly shuffle the indices
    shuffledIndices = indices(randperm(numel(indices)));

    % Split the indices into training and validation indices
    trainingIndices = [trainingIndices; shuffledIndices(1:numTraining)];
    TestIndices = [TestIndices; shuffledIndices(numTraining+1:end)];
end

% Extract training and validation data from the dataTable
TrainingData = dataTable(trainingIndices, :);
TestData = dataTable(TestIndices, :);

% Display the final tables
disp('Training Data:');
disp(TrainingData);

disp('Test Data:');
disp(TestData);


