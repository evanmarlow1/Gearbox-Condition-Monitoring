

SpecEntropy = zeros(80,1);

for i = 1:width(Faulty_table)

    Signal = Faulty_table{:,i};
    %Signal = Signal{1,1};

    SPECENTROPY = pentropy(Signal,Fs,"Instantaneous",false);

    SpecEntropy(i) = SPECENTROPY;

end

%% wind

SpecEntropy = [SpecEntropyH ; SpecEntropyF];

faultCode = zeros(160,1);
faultCode(81:160) = 1;

%% Plot

% Step 3: Create scatter plot
figure;
gscatter(1:numel(SpecEntropy), SpecEntropy, faultCode, 'br', '.', 10); % Scatter plot colored by faultCode

% Step 4: Customize the plot
xlabel('Sample');
ylabel('Spectral Entropy');
title('Scatter Plot of Spectral Entropy');
legend({'Healthy', 'Faulty'});
grid on; % Add grid lines if necessary
set(gca,'FontSize',14)