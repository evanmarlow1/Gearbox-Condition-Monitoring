%% clear
clear all

% Version 2 - All Key Signals, 2 Classes, PB and CWRU
%----------------------------------------------------------------------------------------------------------------------------------------%
%This Script conducts the feature extraction and classification of the data for all classes.
%
% We first need to load the data in a structure that is organised and compatible with the Diagnostic Feature Designer App.
%
% We will begin by loading the datasets.
%
% We have two fault classes for now
%
%----------------------------------------------------------------------------------------------------------------------------------------%

%% Manipulate Data

% Initialize tables
% 140 for PB only
% 147 for PB and CWRU
num_signals = 147;

VibrationTables = cell(num_signals, 1);
faultCode = zeros(num_signals,1);
TachoTables = cell(num_signals,1);

%% Paderborn Data

%Set up Tachometer data
PseudoTacho = generateTachoSignal(1500,64000,250000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',64000);

%Load all Paderborn Samples
for i = 1:20

    %Normal Data

    % Load Normal PB data
    filename = sprintf("Datasets/Paderborn/Normal/K001 Extracted/K001_%d.mat", i);
    PB_Normal = load(filename);
    Normal_Vib = PB_Normal.Vib(1:250000);
    Normal_Time = PB_Normal.Time(1:250000);
    % Convert to timetable
    normalTable = timetable(seconds(Normal_Time)', Normal_Vib', 'VariableNames', {'Vibration'});
    normalTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i} = normalTable;
    TachoTables{i} = PseudoTachotable;
    
    %Inner Data

    % Load Notched Point Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Inner Race/KI01 Extracted/KI01_%d.mat", i);
    PB_Faulty = load(filename);
    Faulty_Vib = PB_Faulty.Vib(1:250000);
    Faulty_Time = PB_Faulty.Time(1:250000);
    % Convert to timetable
    faultyTable = timetable(seconds(Faulty_Time'), Faulty_Vib', 'VariableNames', {'Vibration'});
    faultyTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i+20} = faultyTable;
    TachoTables{i+20} = PseudoTachotable;

    % Load Notched Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Inner Race/KI03 Extracted/KI03_%d.mat", i);
    PB_Faulty = load(filename);
    Faulty_Vib = PB_Faulty.Vib(1:250000);
    Faulty_Time = PB_Faulty.Time(1:250000);
    % Convert to timetable
    faultyTable = timetable(seconds(Faulty_Time'), Faulty_Vib', 'VariableNames', {'Vibration'});
    faultyTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i+40} = faultyTable;
    TachoTables{i+40} = PseudoTachotable;

    % Load Natural Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Natural Inner Race/KI04 Extracted/KI04_%d.mat", i);
    PB_Faulty = load(filename);
    Faulty_Vib = PB_Faulty.Vib(1:250000);
    Faulty_Time = PB_Faulty.Time(1:250000);
    % Convert to timetable
    faultyTable = timetable(seconds(Faulty_Time'), Faulty_Vib', 'VariableNames', {'Vibration'});
    faultyTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i+60} = faultyTable;
    TachoTables{i+60} = PseudoTachotable;

    %Outer data

    % Load Notched Point Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Outer Race/KA01 Extracted/KA01_%d.mat", i);
    PB_Faulty = load(filename);
    Faulty_Vib = PB_Faulty.Vib(1:250000);
    Faulty_Time = PB_Faulty.Time(1:250000);
    % Convert to timetable
    faultyTable = timetable(seconds(Faulty_Time'), Faulty_Vib', 'VariableNames', {'Vibration'});
    faultyTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i+80} = faultyTable;
    TachoTables{i+80} = PseudoTachotable;
    
    % Load Notched Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Outer Race/KA05 Extracted/KA05_%d.mat", i);
    PB_Faulty = load(filename);
    Faulty_Vib = PB_Faulty.Vib(1:250000);
    Faulty_Time = PB_Faulty.Time(1:250000);
    % Convert to timetable
    faultyTable = timetable(seconds(Faulty_Time'), Faulty_Vib', 'VariableNames', {'Vibration'});
    faultyTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i+100} = faultyTable;
    TachoTables{i+100} = PseudoTachotable;

    % Load Natural Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Natural Outer Race/KA04 Extracted/KA04_%d.mat", i);
    PB_Faulty = load(filename);
    Faulty_Vib = PB_Faulty.Vib(1:250000);
    Faulty_Time = PB_Faulty.Time(1:250000);
    % Convert to timetable
    faultyTable = timetable(seconds(Faulty_Time'), Faulty_Vib', 'VariableNames', {'Vibration'});
    faultyTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i+120} = faultyTable;
    TachoTables{i+120} = PseudoTachotable;

end


%% CWRU Data

%Load CWRU Samples - Comment out all 'VibrationTables' and 'TachoTables' lines if importing PB only.

i = 140;        %Number of PB Signals

% Normal data
CWRU_Normal = load("Datasets/CWRU/Normal/Normal_3.mat");
CWRUNormalTable = timetable(CWRU_Normal.X100_FE_time(1:485000),'SampleRate',48000,'VariableNames',{'Vibration'});
VibrationTables{i+1} = CWRUNormalTable;
RPM = CWRU_Normal.X100RPM;
PseudoTacho = generateTachoSignal(RPM,48000,485000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',48000);
TachoTables{i+1} = PseudoTachotable;


% Inner data
CWRU_Inner7 = load("Datasets/CWRU/Inner Race/IR_07_3.mat");
CWRUInner7Table = timetable(CWRU_Inner7.X112_FE_time(1:485000),'SampleRate',48000,'VariableNames',{'Vibration'});
VibrationTables{i+2} = CWRUInner7Table;
RPM = CWRU_Inner7.X112RPM;
PseudoTacho = generateTachoSignal(RPM,48000,485000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',48000);
TachoTables{i+2} = PseudoTachotable;

CWRU_Inner14 = load("Datasets/CWRU/Inner Race/IR_14_3.mat");
CWRUInner14Table = timetable(CWRU_Inner14.X177_FE_time(1:485000),'SampleRate',48000,'VariableNames',{'Vibration'});
VibrationTables{i+3} = CWRUInner14Table;
RPM = CWRU_Inner14.X177RPM;
PseudoTacho = generateTachoSignal(RPM,48000,485000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',48000);
TachoTables{i+3} = PseudoTachotable;

CWRU_Inner21 = load("Datasets/CWRU/Inner Race/IR_21_3.mat");
CWRUInner21Table = timetable(CWRU_Inner21.X215_FE_time(1:485000),'SampleRate',48000,'VariableNames',{'Vibration'});
VibrationTables{i+4} = CWRUInner21Table;
RPM = CWRU_Inner21.X215RPM;
PseudoTacho = generateTachoSignal(RPM,48000,485000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',48000);
TachoTables{i+4} = PseudoTachotable;

%Outer data
CWRU_Outer7 = load("Datasets/CWRU/Outer Race/OR_07_3.mat");
CWRUOuter7Table = timetable(CWRU_Outer7.X138_FE_time(1:485000),'SampleRate',48000,'VariableNames',{'Vibration'});
VibrationTables{i+5} = CWRUOuter7Table;
RPM = CWRU_Outer7.X138RPM;
PseudoTacho = generateTachoSignal(RPM,48000,485000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',48000);
TachoTables{i+5} = PseudoTachotable;

CWRU_Outer14 = load("Datasets/CWRU/Outer Race/OR_14_3.mat");
CWRUOuter14Table = timetable(CWRU_Outer14.X204_FE_time(1:485000),'SampleRate',48000,'VariableNames',{'Vibration'});
VibrationTables{i+6} = CWRUOuter14Table;
RPM = CWRU_Outer14.X204RPM;
PseudoTacho = generateTachoSignal(RPM,48000,485000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',48000);
TachoTables{i+6} = PseudoTachotable;

CWRU_Outer21 = load("Datasets/CWRU/Outer Race/OR_21_3.mat");
CWRUOuter21Table = timetable(CWRU_Outer21.X241_FE_time(1:485000),'SampleRate',48000,'VariableNames',{'Vibration'});
VibrationTables{i+7} = CWRUOuter21Table;
RPM = CWRU_Outer21.X241RPM;
PseudoTacho = generateTachoSignal(RPM,48000,485000);
PseudoTachotable = timetable(PseudoTacho','VariableNames', {'Tachometer'},'SampleRate',48000);
TachoTables{i+7} = PseudoTachotable;

%---------------------------------------------------------------------------------------------------------------
%Test with CWRU
%---------------------------------------------------------------------------------------------------------------
CWRUVib = cell(7,1);
CWRUFault = ones(7,1);
CWRUTacho = cell(7,1);
for j = 1:7
    CWRUTacho{j} = TachoTables(i+j);
end

CWRUVib{1} = CWRUNormalTable;
CWRUVib{2} = CWRUInner7Table;
CWRUVib{3} = CWRUInner14Table;
CWRUVib{4} = CWRUInner21Table;
CWRUVib{5} = CWRUOuter7Table;
CWRUVib{6} = CWRUOuter14Table;
CWRUVib{7} = CWRUOuter21Table;
CWRUFault(1) = 0;

CWRUtable = table(CWRUVib, CWRUTacho, CWRUFault, 'VariableNames', {'Vibration','Tachometer','faultCode'});

%% Fault codes and final table

% Set faultCode - we have Faulty and Healthy for now
faultCode(1:20) = 0;
faultCode(21:num_signals) = 1;
faultCode(141) = 0;                                    % Comment this out if not including CWRU

% Create the final table
dataTable = table(VibrationTables, TachoTables, faultCode, 'VariableNames', {'Vibration','Tachometer','faultCode'});

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


