clear all

Healthy = load("Datasets/OpenEI/Healthy/H4.mat");
Faulty = load("Datasets/OpenEI/Damaged/D4.mat");

HealthySE = zeros(1,8);
FaultySE = zeros(1,8);

Fs = 40000;

for i = 3:10

    sensor_name = sprintf('AN%d', i);

    HealthySensorData = Healthy.(sensor_name); 
    HealthyTimetable = timetable(HealthySensorData,'SampleRate',Fs,'VariableNames',{'Vibration'});
    SpectralEntropy = pentropy(HealthyTimetable, 'Instantaneous',false);
    HealthySE(i-2) = SpectralEntropy;


    FaultySensorData = Faulty.(sensor_name);
    FaultyTimetable = timetable(FaultySensorData,'SampleRate',Fs,'VariableNames',{'Vibration'});
    SpectralEntropy = pentropy(FaultyTimetable, 'Instantaneous',false);
    FaultySE(i-2) = SpectralEntropy;

    
end

%% plot

Sensors = 3:10;

plot(Sensors,HealthySE,'LineWidth',2)
hold on
plot(Sensors,FaultySE,'LineWidth',2)
xlabel('Sensor ID')
ylabel('Spectral Entropy')
legend("Healthy","Faulty")
set(gca,'FontSize',20)
title('Spectral Entropy Test')


