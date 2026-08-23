%% clear
clear all

% Version 1 - Wind only
%----------------------------------------------------------------------------------------------------------------------------------------%
% This Script loads the data, converts it into scalograms, and saves this to an appropriate subfolder.
%
% We can then train a CNN to classify these images.
%--------------------------------------------------------------------------------------------------------------------------------------%

%% Load training data into table

%Change split length as desired.
N_Split = 25;
N_Sensors = 8;

% Initialize tables
num_signals = 8*2*N_Split*N_Sensors;                         % 8/10 segments * 2 fault conditions * N_Split Samples * N_Sensors

VibrationTables = cell(num_signals, 1);
faultCode = zeros(num_signals,1);

%Variables for setup
Fs = 40000;                                         %Sample rate for Paderborn data.


% Initialize cell arrays to store data
healthyData = cell(1, 10);
damagedData = cell(1, 10);

for i = 1:10
    % Construct file names
    healthyFileName = sprintf('Datasets/OpenEI/Healthy/H%d', i);
    damagedFileName = sprintf('Datasets/OpenEI/Damaged/D%d', i);

    % Load data into cell arrays
    healthyData{i} = load(healthyFileName);
    damagedData{i} = load(damagedFileName);
end


%Collect signals in table
offset = 8*N_Sensors*N_Split;



%Loop each 1min segment
for i = 1:8

    %HEALTHY DATA

    %Get each signal
    HealthySignal = healthyData{i};

    %FAULTY DATA
    FaultySignal = damagedData{i};

    %Loop each sensor
    for j = 1:N_Sensors

        %HEALTHY DATA
        sensor_name = sprintf('AN%d', j+2);  

        %Get each sensor
        SensorData = HealthySignal.(sensor_name);

        %Split data
        HealthySplitSensorData = SplitData(SensorData,N_Split);

        %FAULTY DATA

        FaultySensorData = FaultySignal.(sensor_name);

        FaultySplitSensorData = SplitData(FaultySensorData,N_Split);


        %Loop each subsignal
        for k = 1:N_Split
            
            index = (i-1)*N_Sensors*N_Split + (j-1)*N_Split + k;

            %Healthy
            healthyTable = timetable(HealthySplitSensorData(k,:)', 'SampleRate', Fs, 'VariableNames', {'Vibration'});
            VibrationTables{index} = healthyTable;
            faultCode(index) = 0;

            %Faulty
            faultyTable = timetable(FaultySplitSensorData(k,:)', 'SampleRate', Fs, 'VariableNames', {'Vibration'});
            VibrationTables{index+offset} = faultyTable;
            faultCode(index+offset) = 1;
                  
        end
    end
end


dataTable = table(VibrationTables, faultCode, 'VariableNames', {'Vibration','faultCode'});


%% Convert Signals to Scalogram


TrainingFolderName = 'DL_Wind_V1_1_Training';

parfor k = 1:height(dataTable)


    SampleVib = VibrationTables{k};
    SampleCode = faultCode(k);

    SignaltoScalogramWind(SampleVib,TrainingFolderName,k,num2str(SampleCode),Fs)
   
end


%% Store as datastore

path = fullfile('.', TrainingFolderName);

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


%% Load Test Data


% Initialize tables
num_signals_test = 2*2*N_Split*N_Sensors;                         % 2/10 segments * 2 fault conditions * N_Split Samples * N_Sensors

VibrationTables_test = cell(num_signals_test, 1);
faultCode_test = zeros(num_signals_test,1);

offset_test = 2*N_Sensors*N_Split;


%Loop each 1min segment
for i = 9:10

    %HEALTHY DATA

    %Get each signal
    HealthySignal = healthyData{i};

    %FAULTY DATA
    FaultySignal = damagedData{i};

    %Loop each sensor
    for j = 1:N_Sensors

        %HEALTHY DATA
        sensor_name = sprintf('AN%d', j+2);  

        %Get each sensor
        SensorData = HealthySignal.(sensor_name);

        %Split data
        HealthySplitSensorData = SplitData(SensorData,N_Split);

        %FAULTY DATA

        FaultySensorData = FaultySignal.(sensor_name);

        FaultySplitSensorData = SplitData(FaultySensorData,N_Split);


        %Loop each subsignal
        for k = 1:N_Split
            
            index = ((i-9)*N_Sensors*N_Split + (j-1)*N_Split + k);

            %Healthy
            healthyTable = timetable(HealthySplitSensorData(k,:)', 'SampleRate', Fs, 'VariableNames', {'Vibration'});
            VibrationTables_test{index} = healthyTable;
            faultCode_test(index) = 0;

            %Faulty
            faultyTable = timetable(FaultySplitSensorData(k,:)', 'SampleRate', Fs, 'VariableNames', {'Vibration'});
            VibrationTables_test{index+offset_test} = faultyTable;
            faultCode_test(index+offset_test) = 1;
                  
        end
    end
end


dataTable_test = table(VibrationTables_test, faultCode_test, 'VariableNames', {'Vibration','faultCode'});

%% Test CNN - Create images

TestFolderName = 'DL_Wind_V1_1_Test';

parfor k = 1:height(dataTable_test)


    SampleVib = VibrationTables_test{k};
    SampleCode = faultCode_test(k);

    SignaltoScalogramWind(SampleVib,TestFolderName,k,num2str(SampleCode),Fs)
   
end

%% Test CNN - Datastore and Predictions

TestFolderName = TestFolderName;

path = fullfile('.', TestFolderName);

imdsTest = imageDatastore(path, ...
  'IncludeSubfolders',true,'LabelSource','foldernames');

YPred = classify(net,imdsTest,'MiniBatchSize',20);

YTest = imdsTest.Labels;
accuracy = sum(YPred == YTest)/numel(YTest)

figure;
confusionchart(YTest,YPred)

%% Check classifications

YWrong = YTest==YPred;

figure;
plot(YWrong,'rx','Linewidth',2)
xlabel('Sample')
ylabel('Error')
ylim([-0.1 1.1])
title('Misclassifications')
set(gca,'FontSize',20)


