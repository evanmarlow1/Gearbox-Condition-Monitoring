% Assuming FeatureTable2 is your table with features
%FeatureTable2.("Vibration_ps_bearing/BandPower1")



% Step 2: Extract the chosen feature and faultCode column
featureData = FeatureTable2.("Vibration_ps_bearing/PeakAmp3");
faultCode = FeatureTable2.faultCode;

% Step 3: Create scatter plot
figure;
gscatter(1:numel(featureData), featureData, faultCode, 'br', '.', 10); % Scatter plot colored by faultCode

% Step 4: Customize the plot
xlabel('Sample');
ylabel('Feature Value');
title('Scatter Plot of Peak Amplitude at first harmonic');
legend({'Healthy', 'Faulty'});
grid on; % Add grid lines if necessary
set(gca,'FontSize',14)
