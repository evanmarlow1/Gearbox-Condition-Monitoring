%% clear
clear all

%% Load data

% Load Healthy datasets
for i = 1:10
    filename = sprintf('Datasets/OpenEI/Healthy/H%d.mat', i);
    varname = sprintf('Healthy%d', i);
    data = load(filename);
    eval([varname ' = data;']);
end

% Load Faulty datasets
for i = 1:10
    filename = sprintf('Datasets/OpenEI/Damaged/D%d.mat', i);
    varname = sprintf('Faulty%d', i);
    data = load(filename);
    eval([varname ' = data;']);
end


%% Sensor data

% Initialize empty tables for Healthy and Faulty datasets
num_datasets = 10;
num_sensors = 8;
Healthy_table = table();
Faulty_table = table();

% Load Healthy datasets
for i = 1:num_datasets
    filename = sprintf('Datasets/OpenEI/Healthy/H%d.mat', i);
    data = load(filename);
    for j = 3:10
        sensor_name = sprintf('AN%d', j);
        sensor_data = data.(sensor_name);
        var_name = sprintf('%s_%d', sensor_name, i);  % Unique variable name
        Healthy_table.(var_name) = sensor_data;
    end
end

% Load Faulty datasets
for i = 1:num_datasets
    filename = sprintf('Datasets/OpenEI/Damaged/D%d.mat', i);
    data = load(filename);
    for j = 3:10
        sensor_name = sprintf('AN%d', j);
        sensor_data = data.(sensor_name);
        var_name = sprintf('%s_%d', sensor_name, i);  % Unique variable name
        Faulty_table.(var_name) = sensor_data;
    end
end


%% Set parameters

Fs = 40000;
Fr = 22.09 / 60;
Fout = 1800 /60;

GearRatios = 81.49;

TestHarmonics = Fout / 4;

Harmonics  = Fr .* GearRatios;

Signal_Length = length(Faulty.AN3);

Time = (0:Signal_Length-1) / Fs;


%% Plot time series data

subplot(8,2,2)
plot(Time,Faulty.AN3)
title("Faulty","FontSize",20)
ylabel("AN3",'FontSize',18, 'FontWeight','bold')

subplot(8,2,1)
plot(Time,Healthy.AN3)
title("Healthy","FontSize",20)
ylabel("AN3",'FontSize',18, 'FontWeight','bold')

subplot(8,2,4)
plot(Time,Faulty.AN4)
ylabel("AN4",'FontSize',18, 'FontWeight','bold')

subplot(8,2,3)
plot(Time,Healthy.AN4)
ylabel("AN4",'FontSize',18, 'FontWeight','bold')

subplot(8,2,6)
plot(Time,Faulty.AN5)
ylabel("AN5",'FontSize',18, 'FontWeight','bold')

subplot(8,2,5)
plot(Time,Healthy.AN5)
ylabel("AN5",'FontSize',18, 'FontWeight','bold')

subplot(8,2,8)
plot(Time,Faulty.AN6)
ylabel("AN6",'FontSize',18, 'FontWeight','bold')

subplot(8,2,7)
plot(Time,Healthy.AN6)
ylabel("AN6",'FontSize',18, 'FontWeight','bold')

subplot(8,2,10)
plot(Time,Faulty.AN7)
ylabel("AN7",'FontSize',18, 'FontWeight','bold')

subplot(8,2,9)
plot(Time,Healthy.AN7)
ylabel("AN7",'FontSize',18, 'FontWeight','bold')

subplot(8,2,12)
plot(Time,Faulty.AN8)
ylabel("AN8",'FontSize',18, 'FontWeight','bold')

subplot(8,2,11)
plot(Time,Healthy.AN8)
ylabel("AN8",'FontSize',18, 'FontWeight','bold')

subplot(8,2,14)
plot(Time,Faulty.AN9)
ylabel("AN9",'FontSize',18, 'FontWeight','bold')

subplot(8,2,13)
plot(Time,Healthy.AN9)
ylabel("AN9",'FontSize',18, 'FontWeight','bold')

subplot(8,2,16)
plot(Time,Faulty.AN10)
ylabel("AN10",'FontSize',18, 'FontWeight','bold')
xlabel("Time /s")

subplot(8,2,15)
plot(Time,Healthy.AN10)
ylabel("AN10",'FontSize',18, 'FontWeight','bold')
xlabel("Time /s")

linkaxes([subplot(8,2,1) subplot(8,2,2) subplot(8,2,3) ...
    subplot(8,2,4) subplot(8,2,5) subplot(8,2,6) ...
    subplot(8,2,7) subplot(8,2,8) subplot(8,2,9) ...
    subplot(8,2,10) subplot(8,2,11) subplot(8,2,12) ...
    subplot(8,2,13) subplot(8,2,14) subplot(8,2,15) subplot(8,2,16) ])

sgtitle("Time series data comparison for each sensor", 'FontSize',20, 'FontWeight', 'bold')


%% Plot frequency data

subplot(1,2,1)
[y, x] = FFTPlot(Healthy.AN10, Fs);
plot(x, y,'LineWidth',2)
helperPlotCombsSidebands(200, Harmonics,Fr,0)
title("Healthy",'FontSize',20)
xlabel("Frequency / Hz")
ylabel("Amplitude")


subplot(1,2,2)
[y, x] = FFTPlot(Faulty.AN10, Fs);
plot(x,y,'LineWidth',2)
title("Faulty",'FontSize',20)
helperPlotCombsSidebands(200,Harmonics,Fr,0)
legend("Signal","Gear Harmonics","FontSize",20)
xlabel("Frequency / Hz")
ylabel("Amplitude")

linkaxes([subplot(1,2,1) subplot(1,2,2)])
xlim([0 1000])

sgtitle('AN10 Frequency Domain', 'FontSize',30,'FontWeight','bold')


%% Gear Condition Metrics



OrderList = [5.71 5.71*3.57 81.49];

T_Healthy = table('Size',[80 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});


T_Faulty = table('Size',[80 4],'VariableTypes',{'cell','cell','cell','cell'},'VariableNames',{'TSA','Diff','Reg','Res'});

for i = 1:80

    sensor_name = Healthy_table.Properties.VariableNames{i};

    %Healthy

    Signal_H = Healthy_table.(sensor_name);

    TSA = tsa(Signal_H,Fs,1/Fr);
    res = tsaresidual(Signal_H, Fs, Fr*60, OrderList);
    diff = tsadifference(Signal_H, Fs, Fr*60, OrderList);
    reg = tsaregular(Signal_H, Fs, Fr*60, OrderList);

    T_Healthy(i,'TSA') = {TSA};
    T_Healthy(i,'Diff') = {diff};
    T_Healthy(i,'Reg') = {reg};
    T_Healthy(i,'Res') = {res};

    %Faulty

    Signal_F = Faulty_table.(sensor_name);

    TSA = tsa(Signal_F,Fs,1/Fr);
    res = tsaresidual(Signal_F, Fs, Fr*60, OrderList);
    diff = tsadifference(Signal_F, Fs, Fr*60, OrderList);
    reg = tsaregular(Signal_F, Fs, Fr*60, OrderList);

    T_Faulty(i,'TSA') = {TSA};
    T_Faulty(i,'Diff') = {diff};
    T_Faulty(i,'Reg') = {reg};
    T_Faulty(i,'Res') = {res};

end


[gearMetrics_H,info_H] = gearConditionMetrics(T_Healthy,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res');

[gearMetrics_F,info_F] = gearConditionMetrics(T_Faulty,'SignalVariable','TSA','DifferenceVariable','Diff','RegularVariable','Reg','ResidualVariable','Res');

Difference = gearMetrics_F - gearMetrics_H;

%% Plot


% Step 2: Extract the chosen feature
healthy = gearMetrics_H.M6A;
faulty = gearMetrics_F.M6A;

% Step 3: Create histograms
figure;
histogram(healthy, 'Normalization', 'probability');
hold on;
histogram(faulty, 'Normalization', 'probability');

% Step 4: Customize the plot
xlabel('Feature Value');
ylabel('Probability');
title('Distribution of Feature (RMS) for Healthy vs. Faulty');
legend({'Healthy', 'Faulty'});
grid on;


%% Kurtograms
level = 9;

subplot(1,2,1)
kurtogram(Healthy.AN3,Fs,level)

subplot(1,2,2)
kurtogram(Faulty.AN3,Fs,level)


%% METRICS
