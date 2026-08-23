% Run ML_V3 first

%Get samples
Vibration = dataTable.Vibration(26);
PBSample = Vibration{1,1};

[se_PB, te_PB] = pentropy(PBSample);

subplot(2,2,1)
plot(PBSample.Time,PBSample.Vibration)
ylabel("Raw Signal - PB")
xlabel("Time")
grid on

subplot(2,2,3)
plot(se_PB.Time, se_PB.SE)
ylabel("Spectral Entropy - PB")
xlabel("Time")
grid on

result_PB = pentropy(PBSample,'Instantaneous',false)


Vibration1 = dataTable.Vibration(3505);
CWRUSample = Vibration1{1,1};


[se_CWRU,te_CWRU] = pentropy(CWRUSample);

subplot(2,2,2)
plot(CWRUSample.Time, CWRUSample.Vibration)
ylabel("Raw Signal - CWRU")
xlabel("Time")

subplot(2,2,4)
plot(se_CWRU.Time,se_CWRU.SE)
ylabel("Spectral Entropy - CWRU")
xlabel("Time")

result_CWRU = pentropy(CWRUSample,'Instantaneous',false)

sgtitle("Spectral Entropy of Normal Samples")