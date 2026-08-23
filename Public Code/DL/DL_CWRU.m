%% clear
clear all

% Version 1 - CWRU Data
%----------------------------------------------------------------------------------------------------------------------------------------%
% This Script loads the data, converts it into scalograms, and saves this to an appropriate subfolder.
%
% We can then train a CNN to classify these images.
%--------------------------------------------------------------------------------------------------------------------------------------%

%% Load training data into table

%Change split length as desired.
N_Split = 50;

% Initialize tables
num_signals = 23*1*N_Split;         % 23 Signals * 1 run * N_Split Samples (for CWRU)

VibrationTables = cell(num_signals, 1);
faultCode = zeros(num_signals,1);   


%Variables for setup
N_Datapoints = 240000;   %How many datapoints we're limiting the raw signal to for consistency.
Fs = 48000;              %Sample rate for CWRU data.
Signal_Gap = N_Split;    %Index offset between signals


%Load all CWRU Samples

%Normal Data
%---------------------------------------------------------------------------------------------------
% Load Normal data
i = 1;
Normal = load("Datasets/CWRU/Normal/Normal_0.mat");
Normal_Vib = SplitData(Normal.X097_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Normal_Vib(j,:);
    % Convert to timetable
    normalTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = normalTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load Normal data - Second
Normal = load("Datasets/CWRU/Normal/Normal_1.mat");
Normal_Vib = SplitData(Normal.X098_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Normal_Vib(j,:);
    % Convert to timetable
    normalTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = normalTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load Normal data - Fourth
Normal = load("Datasets/CWRU/Normal/Normal_3.mat");
Normal_Vib = SplitData(Normal.X100_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Normal_Vib(j,:);
    % Convert to timetable
    normalTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = normalTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR Data
%----------------------------------------------------------------------------------------------------
% Load IR data - 7,0
Faulty = load("Datasets/CWRU/Inner Race/IR_07_0.mat");
Faulty_Vib = SplitData(Faulty.X109_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 7,1
Faulty = load("Datasets/CWRU/Inner Race/IR_07_1.mat");
Faulty_Vib = SplitData(Faulty.X110_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 7,3
Faulty = load("Datasets/CWRU/Inner Race/IR_07_3.mat");
Faulty_Vib = SplitData(Faulty.X112_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% % Load IR data - 14,0
% Faulty = load("Datasets/CWRU/Inner Race/IR_14_0.mat");
% Faulty_Vib = SplitData(Faulty.X173_FE_time(1:N_Datapoints),N_Split);
% 
% for j = 1:N_Split
%     Current_Vib = Faulty_Vib(j,:);
%     % Convert to timetable
%     faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
%     VibrationTables{N_Split*(i-1) + j} = faultyTable;
% end
% i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 14,1
Faulty = load("Datasets/CWRU/Inner Race/IR_14_1.mat");
Faulty_Vib = SplitData(Faulty.X175_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 14,2
Faulty = load("Datasets/CWRU/Inner Race/IR_14_2.mat");
Faulty_Vib = SplitData(Faulty.X176_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 14,3
Faulty = load("Datasets/CWRU/Inner Race/IR_14_3.mat");
Faulty_Vib = SplitData(Faulty.X177_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 21,0
Faulty = load("Datasets/CWRU/Inner Race/IR_21_0.mat");
Faulty_Vib = SplitData(Faulty.X213_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 21,2
Faulty = load("Datasets/CWRU/Inner Race/IR_21_2.mat");
Faulty_Vib = SplitData(Faulty.X215_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 21,3
Faulty = load("Datasets/CWRU/Inner Race/IR_21_3.mat");
Faulty_Vib = SplitData(Faulty.X217_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data
%----------------------------------------------------------------------------------------------------
% Load OR data - 7,0
Faulty = load("Datasets/CWRU/Outer Race/OR_07_0.mat");
Faulty_Vib = SplitData(Faulty.X135_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 7,1
Faulty = load("Datasets/CWRU/Outer Race/OR_07_1.mat");
Faulty_Vib = SplitData(Faulty.X136_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 7,2
Faulty = load("Datasets/CWRU/Outer Race/OR_07_2.mat");
Faulty_Vib = SplitData(Faulty.X137_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 7,3
Faulty = load("Datasets/CWRU/Outer Race/OR_07_3.mat");
Faulty_Vib = SplitData(Faulty.X138_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 14,0
Faulty = load("Datasets/CWRU/Outer Race/OR_14_0.mat");
Faulty_Vib = SplitData(Faulty.X201_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 14,1
Faulty = load("Datasets/CWRU/Outer Race/OR_14_1.mat");
Faulty_Vib = SplitData(Faulty.X202_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 14,2
Faulty = load("Datasets/CWRU/Outer Race/OR_14_2.mat");
Faulty_Vib = SplitData(Faulty.X203_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 21,0
Faulty = load("Datasets/CWRU/Outer Race/OR_21_0.mat");
Faulty_Vib = SplitData(Faulty.X238_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 21,1
Faulty = load("Datasets/CWRU/Outer Race/OR_21_1.mat");
Faulty_Vib = SplitData(Faulty.X239_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 21,2
Faulty = load("Datasets/CWRU/Outer Race/OR_21_2.mat");
Faulty_Vib = SplitData(Faulty.X240_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 21,3
Faulty = load("Datasets/CWRU/Outer Race/OR_21_3.mat");
Faulty_Vib = SplitData(Faulty.X241_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------


%% Fault codes and table

% Set faultCode - we have 0,1,2 = normal, IR, OR
faultCode(1:3*N_Split) = 0;
faultCode(3*N_Split+1:12*N_Split) = 1;
faultCode(12*N_Split+1:23*N_Split) = 2;


% % Alternate Binary faultCode - 0,1 = normal, faulty
% faultCode(1:3*N_Split) = 0;
% faultCode(3*N_Split+1:23*N_Split) = 1;


% Create the final table - Edit this to change faultCode
dataTable = table(VibrationTables, faultCode, 'VariableNames', {'Vibration','faultCode'});

% Display the final table
disp(dataTable);


%% Convert signals to scalogram

TrainingFolderName = 'DL_CWRU_V1_3_Training';

for k = 1:height(dataTable)


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


%% Create CNN - SqueezeNet

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



%% Create CNN - AlexNet

%squeezenet is a pretrained image classification CNN model compatible with 227x227 images
net = alexnet;

% view network - shows the layers.
%analyzeNetwork(net)

% we want to swap the final layer to have connections that correspond to class predictions.

lgraph = layerGraph(net);                                   % Get final layer

numClasses = numel(categories(imdsTrain.Labels));           % Get number of classes

newConvLayer = convolution2dLayer([1, 1],numClasses,'WeightLearnRateFactor',...
    10,'BiasLearnRateFactor',10,"Name",'new_conv');         %Create replacement layer based on number of classes

lgraph = replaceLayer(lgraph,'fc8',newConvLayer);        %Replace this layer

%This dynamically adjusts the network to have the correct number of classes at training time
newClassificationLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'output',newClassificationLayer); 

%% Create CNN - googLeNet

%googLenet is a pretrained image classification CNN model compatible with 224x224 images
net = googlenet;

% we want to swap the final later to have connections that correspond to class predictions.

lgraph = layerGraph(net);                                   % Get final layer

numClasses = numel(categories(imdsTrain.Labels));           % Get number of classes

newConvLayer = convolution2dLayer([1, 1],numClasses,'WeightLearnRateFactor',...
    10,'BiasLearnRateFactor',10,"Name",'new_conv');         %Create replacement layer based on number of classes

lgraph = replaceLayer(lgraph,'loss3-classifier',newConvLayer);        %Replace this layer

%This dynamically adjusts the network to have the correct number of classes at training time
newClassificationLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'output',newClassificationLayer); 


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
Test_num_signals = 4*1*N_Split;         % 4 Signals * 1 run * N_Split Samples (for CWRU)

Test_VibrationTables = cell(Test_num_signals,1);
Test_faultCode = zeros(Test_num_signals,1);   


%Load test data
i = 1;
%----------------------------------------------------------------------------------------------------
% Load Normal data - Third
Normal = load("Datasets/CWRU/Normal/Normal_2.mat");
Normal_Vib = SplitData(Normal.X099_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Normal_Vib(j,:);
    % Convert to timetable
    normalTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    Test_VibrationTables{N_Split*(i-1) + j} = normalTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 7,2
Faulty = load("Datasets/CWRU/Inner Race/IR_07_2.mat");
Faulty_Vib = SplitData(Faulty.X111_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    Test_VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load IR data - 21,1
Faulty = load("Datasets/CWRU/Inner Race/IR_21_1.mat");
Faulty_Vib = SplitData(Faulty.X214_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    Test_VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;
%----------------------------------------------------------------------------------------------------
% Load OR data - 14,3
Faulty = load("Datasets/CWRU/Outer Race/OR_14_3.mat");
Faulty_Vib = SplitData(Faulty.X204_FE_time(1:N_Datapoints),N_Split);

for j = 1:N_Split
    Current_Vib = Faulty_Vib(j,:);
    % Convert to timetable
    faultyTable = timetable(Current_Vib','SampleRate',Fs,'VariableNames',{'Vibration'});
    Test_VibrationTables{N_Split*(i-1) + j} = faultyTable;
end
i = i+1;




%% Test fault codes

% Set faultCode - we have 0,1,2 = normal, IR, OR
Test_faultCode(1:N_Split) = 0;
Test_faultCode(N_Split+1:3*N_Split) = 1;
Test_faultCode(3*N_Split+1:4*N_Split) = 2;

% % Alternate faultCode - Binary
% Test_faultCode(1:N_Split) = 0;
% Test_faultCode(N_Split+1:4*N_Split) = 1;

% Create the final table - Edit this to change faultCode
TestdataTable = table(Test_VibrationTables, Test_faultCode, 'VariableNames', {'Vibration','faultCode'});

% Display the final table
disp(TestdataTable);

%% Test CNN - Create images

TestFolderName = 'DL_CWRU_V1_3_Test';

for k = 1:height(TestdataTable)


    SampleVib = Test_VibrationTables{k};
    SampleCode = Test_faultCode(k);

    SignaltoScalogramWind(SampleVib,TestFolderName,k,num2str(SampleCode),Fs)
   
end

%% Test CNN - Datastore and Predictions

%TestFolderName = ;

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


