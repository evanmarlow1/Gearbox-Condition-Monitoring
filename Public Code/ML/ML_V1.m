%% clear
clear all

% Version 1 - Two signals, Paderborn only, Faulty vs Normal
%----------------------------------------------------------------------------------------------------------------------------------------%
%This Script conducts the feature extraction and classification of the data.
%
% We first need to load the data in a structure that is organised and compatible with the Diagnostic Feature Designer App.
%
% We will begin by loading the normal data and point faulty data, so we have two fault codes for now.
%
%----------------------------------------------------------------------------------------------------------------------------------------%

%% Manipulate Data

% Load data
Normal_Vib = zeros(1, 256000);
Faulty_Vib = zeros(1, 256000);

Normal_Time = zeros(1, 256000);
Faulty_Time = zeros(1, 256000);

% Initialize tables
VibrationTables = cell(40, 1);
faultCode = zeros(40,1);

for i = 1:20
    % Load Normal data
    filename = sprintf("Datasets/Paderborn/Normal/K001 Extracted/K001_%d.mat", i);
    PB_Normal = load(filename);
    Normal_Vib = PB_Normal.Vib(1:256000);
    Normal_Time = PB_Normal.Time(1:256000);

    % Convert to timetable
    normalTable = timetable(seconds(Normal_Time)', Normal_Vib', 'VariableNames', {'Vibration'});
    normalTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i} = normalTable;

    % Load Faulty data
    filename = sprintf("Datasets/Paderborn/Artificial Inner Race/KI01 Extracted/KI01_%d.mat", i);
    PB_Faulty = load(filename);
    Faulty_Vib = PB_Faulty.Vib(1:256000);
    Faulty_Time = PB_Faulty.Time(1:256000);

    % Convert to timetable
    faultyTable = timetable(seconds(Faulty_Time'), Faulty_Vib', 'VariableNames', {'Vibration'});
    faultyTable.Properties.DimensionNames{1} = 'Time';
    VibrationTables{i+20} = faultyTable;

    % Set faultCode (assuming 0 for Normal and 1 for Faulty)
    faultCode(i) = 0;
    faultCode(i + 20) = 1;
end

% Create the final table
dataTable = table(VibrationTables, faultCode, 'VariableNames', {'Vibration', 'faultCode'});

% Display the table
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



