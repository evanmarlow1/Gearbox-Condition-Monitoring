%%
clear all
%---------------------------------------------------------------------------------------------------------------------------------
% This script extracts some basic gear condition features from the data and trains an ML model
%
% We use the first 8 signals, split them, and compute the key metrics.
%
% We do the same for the final 2 signals, and hold these back
%
% These metrics can be used as features for a ML model
%
% V3 - Adds SensorID as a variable
%-------------------------------------------------------------------------------------------------------------------------------------

%% Load data

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

%% Set up Feature Table

N_Split = 10;
N_Sensors = 8;

numRows = 2*10*N_Sensors*N_Split;       % 2 fault codes * 10 signals * 8 sensors * N_Split subsignals

FeatureTable = table('Size', [numRows 5],'VariableTypes',{'double','double','double','double','double'} ,'VariableNames', {'faultCode', 'FM0', 'ER', 'RMS','SensorID'});

OrderList = [5.71 5.71*3.57 81.49];

Fs = 40000;

Fr = 22.09 / 60;

%% Compute Metrics

indexoffset = 10*N_Sensors*N_Split;

for i = 1:10

    %HEALTHY DATA

    %Get each signal
    HealthySignal = healthyData{i};

    %FAULTY DATA
    FaultySignal = damagedData{i};

    for j = 1:N_Sensors

        %HEALTHY DATA
        sensor_name = sprintf('AN%d', j+2);
        

        %Get each sensor
        SensorData = HealthySignal.(sensor_name);

        %Split data
        SplitSensorData = SplitData(SensorData,N_Split);

        %Make table
        T_H = table('Size',[N_Split 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});

        %FAULTY DATA

        FaultySensorData = FaultySignal.(sensor_name);

        FaultySplitSensorData = SplitData(FaultySensorData,N_Split);

        T_F = table('Size',[N_Split 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});

        %For each subsignal
        for k = 1:N_Split

            %HEALTHY DATA

            %Compute TSA's
            TSA = tsa(SplitSensorData(k,:)',Fs,1/Fr);
            res = tsaresidual(SplitSensorData(k,:)', Fs, Fr*60, OrderList);
            diff = tsadifference(SplitSensorData(k,:)', Fs, Fr*60, OrderList);
            reg = tsaregular(SplitSensorData(k,:)', Fs, Fr*60, OrderList);

            %Add to table
            T_H(k,'TSA') = {TSA};
            T_H(k,'Diff') = {diff};
            T_H(k,'Reg') = {reg};
            T_H(k,'Res') = {res};

            %FAULTY DATA

            %Compute TSA's
            TSA = tsa(FaultySplitSensorData(k,:)',Fs,1/Fr);
            res = tsaresidual(FaultySplitSensorData(k,:)', Fs, Fr*60, OrderList);
            diff = tsadifference(FaultySplitSensorData(k,:)', Fs, Fr*60, OrderList);
            reg = tsaregular(FaultySplitSensorData(k,:)', Fs, Fr*60, OrderList);

            %Add to table
            T_F(k,'TSA') = {TSA};
            T_F(k,'Diff') = {diff};
            T_F(k,'Reg') = {reg};
            T_F(k,'Res') = {res};

            
        end

        %HEALTHY DATA

        %Calculate metrics
        [gearMetrics_H,info_H] = gearConditionMetrics(T_H,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res');

        indexStart = ((i-1) * N_Sensors + (j-1)) * N_Split + 1;
        indexEnd = indexStart + N_Split - 1;
        FeatureTable.RMS(indexStart : indexEnd) = gearMetrics_H.RMS;
        FeatureTable.FM0(indexStart : indexEnd) = gearMetrics_H.FM0;
        FeatureTable.ER(indexStart : indexEnd) = gearMetrics_H.EnergyRatio;
        FeatureTable.faultCode(indexStart : indexEnd) = 0;
        FeatureTable.SensorID(indexStart : indexEnd) = mod(j+2,N_Sensors);

        %FAULTY DATA
       [gearMetrics_F,info_F] = gearConditionMetrics(T_F,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res'); 
     
        

       indexStart = ((i-1) * N_Sensors + (j-1)) * N_Split + 1 + indexoffset;
       indexEnd = indexStart + N_Split - 1;
       FeatureTable.RMS(indexStart : indexEnd) = gearMetrics_F.RMS;
       FeatureTable.FM0(indexStart : indexEnd) = gearMetrics_F.FM0;
       FeatureTable.ER(indexStart : indexEnd) = gearMetrics_F.EnergyRatio;
       FeatureTable.faultCode(indexStart : indexEnd) = 1;
       FeatureTable.SensorID(indexStart : indexEnd) = mod(j+2,N_Sensors);
     
    end
end

%% Split into training and testing


halflength = height(FeatureTable) / 2;

sevensignals = N_Split*N_Sensors*8;

Training_Healthy = FeatureTable(1:sevensignals,:);
Test_Healthy = FeatureTable(sevensignals+1:halflength,:);

Training_Faulty = FeatureTable(halflength + 1: halflength + sevensignals,:);
Test_Faulty = FeatureTable(halflength + sevensignals + 1 : end,:);


%Training and Test tables
FeatureTable_Training = vertcat(Training_Healthy,Training_Faulty);
FeatureTable_Test = vertcat(Test_Healthy,Test_Faulty);






