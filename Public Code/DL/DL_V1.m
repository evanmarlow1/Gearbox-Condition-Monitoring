%% clear
clear all

% Version 1 - PB only
%----------------------------------------------------------------------------------------------------------------------------------------%
% This Script loads the data, converts it into scalograms, and saves this to an appropriate subfolder
%--------------------------------------------------------------------------------------------------------------------------------------%

%% Load training data into table


%Change split length as desired.
N_Split = 25;
N_Split_CWRU = 0;

% Initialize tables
num_signals_PB = 7*20*N_Split;         % 7 Signals * 20 runs * N_Split Samples (for Paderborn)

VibrationTables = cell(num_signals_PB, 1);
faultCode = zeros(num_signals_PB+7*N_Split_CWRU,1);   


%Variables for setup
N_Datapoints = 250000;      %How many datapoints we're limiting the raw signal to for consistency.
PB_Fs = 64000;              %Sample rate for Paderborn data.
Signal_Gap = 20*N_Split;    %Index offset between signals


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
    end
    
end


%% Fault codes and table

% Set faultCode - we have 0,1,2 = normal, IR, OR
faultCode(1:20*N_Split) = 0;
faultCode(20*N_Split+1:4*20*N_Split) = 1;
faultCode(4*20*N_Split+1:7*20*N_Split) = 2;

% Alternate Binary faultCode - 0,1 = normal, faulty
faultCode(1:20*N_Split)

% Create the final table - Edit this to change faultCode
dataTable = table(VibrationTables, faultCode, 'VariableNames', {'Vibration','faultCode'});

% Display the final table
disp(dataTable);


%% Convert signals to scalogram

for k = 1:height(dataTable)


    SampleVib = dataTable{k,"Vibration"};
    SampleCode = dataTable{k,"faultCode"};

    SignaltoScalogram(SampleVib,'Data',k,num2str(SampleCode))
   
end


%% Store as datastore

path = fullfile('.', 'Data');

imds = imageDatastore(path, ...
  'IncludeSubfolders',true,'LabelSource','foldernames');


% Set aside 20% of signals by label to be validation data
[imdsTrain,imdsValidation] = splitEachLabel(imds,0.8,'randomize');



%% Create CNN

%squeezenet is a pretrained image classification CNN model compatible with 227x227 images
net = squeezenet;

% view network - shows the layers.
%analyzeNetwork(net)

% we want to swap the final layer to have connections that correspond to class predictions.

lgraph = layerGraph(net);                                   % Get final layer

numClasses = numel(categories(imdsTrain.Labels));           % Get number of classes

newConvLayer = convolution2dLayer([1, 1],numClasses,'WeightLearnRateFactor',...
    10,'BiasLearnRateFactor',10,"Name",'new_conv');         %Create replacement layer based on number of classes

lgraph = replaceLayer(lgraph,'conv10',newConvLayer);        %Replace this layer

%This dynamically adjusts the network to have the correct number of classes at training time
newClassificationLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'ClassificationLayer_predictions',newClassificationLayer); 


%% Train CNN

%set training options
options = trainingOptions('sgdm', ...
  'InitialLearnRate',0.0001, ...
  'MaxEpochs',4, ...
  'Shuffle','every-epoch', ...
  'ValidationData',imdsValidation, ...
  'ValidationFrequency',30, ...
  'Verbose',false, ...
  'MiniBatchSize',20, ...
  'Plots','training-progress');


%train
net = trainNetwork(imdsTrain,lgraph,options);



%% Test CNN - Load test data

%Initialise Test Variables
Test_num_signals_PB = 4*20*N_Split;         % 7 Signals * 20 runs * N_Split Samples (for Paderborn)

Test_VibrationTables = cell(Test_num_signals_PB, 1);
Test_faultCode = zeros(Test_num_signals_PB+4*N_Split_CWRU,1);   


%Load test data - other incipient fault bearing PB data
for i = 1:20
   

    %Normal data

    % Load Normal data
    filename = sprintf("Datasets/Paderborn/Normal/K002 Extracted/K002_%d.mat", i);
    PB_Normal = load(filename);
    PB_Normal_Vib = SplitData(PB_Normal.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Normal_Vib(j,:);
        % Convert to timetable
        normalTable = timetable(Current_Vib','SampleRate',PB_Fs,'VariableNames',{'Vibration'});
        Test_VibrationTables{N_Split*(i-1) + j} = normalTable;
    end

    %IR data

    %Notched IR Pitting data

    % Load Notched Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Artificial Inner Race/KI05 Extracted/KI05_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib', 'SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        Test_VibrationTables{1*Signal_Gap + N_Split*(i-1) + j} = faultyTable;
    end

    %Natural IR Pitting data

    % Load Notched Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Natural Inner Race/KI14 Extracted/KI14_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib', 'SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        Test_VibrationTables{2*Signal_Gap + N_Split*(i-1) + j} = faultyTable;
    end

    %OR data

    %Natural OR Pitting Data

    % Load Notched Pitting Fault data
    filename = sprintf("Datasets/Paderborn/Natural Outer Race/KA22 Extracted/KA22_%d.mat", i);
    PB_Faulty = load(filename);
    PB_Faulty_Vib = SplitData(PB_Faulty.Vib(1:N_Datapoints),N_Split);

    for j = 1:N_Split
        Current_Vib = PB_Faulty_Vib(j,:);
        % Convert to timetable
        faultyTable = timetable(Current_Vib', 'SampleRate', PB_Fs, 'VariableNames', {'Vibration'});
        Test_VibrationTables{3*Signal_Gap + N_Split*(i-1) + j} = faultyTable;
    end

end


% Set faultCode - we have 0,1,2 = normal, IR, OR
Test_faultCode(1:20*N_Split) = 0;
Test_faultCode(20*N_Split+1:3*20*N_Split) = 1;
Test_faultCode(3*20*N_Split+1:4*20*N_Split) = 2;

% Create the final table - Edit this to change faultCode
TestdataTable = table(Test_VibrationTables, Test_faultCode, 'VariableNames', {'Vibration','faultCode'});

% Display the final table
disp(TestdataTable);

%% Test CNN - Create images

for k = 1:height(TestdataTable)


    SampleVib = TestdataTable{k,"Vibration"};
    SampleCode = TestdataTable{k,"faultCode"};

    SignaltoScalogram(SampleVib,'TestData',k,num2str(SampleCode))
   
end

%% Test CNN - Datastore and Predictions

path = fullfile('.', 'TestData');

imdsTest = imageDatastore(path, ...
  'IncludeSubfolders',true,'LabelSource','foldernames');

YPred = classify(net,imdsTest,'MiniBatchSize',20);

YTest = imdsTest.Labels;
accuracy = sum(YPred == YTest)/numel(YTest)

figure
confusionchart(YTest,YPred)
