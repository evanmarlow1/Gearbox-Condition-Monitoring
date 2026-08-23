function outputAmplitudes = bandpassAmplitudes(accelerometerSignal, samplingFrequency, frequencies)
    % Initialize output array
    outputAmplitudes = zeros(size(frequencies));
    
    % Length of input signal
    N = length(accelerometerSignal);
    
    % Time vector
    t = (0:N-1) / samplingFrequency;
    
    % Compute FFT of the signal
    fftSignal = fftshift(accelerometerSignal);

    % Calculate the number of points in the FFT
    N2 = length(fftSignal);
    
    % Calculate the one-sided spectrum
    FFT = 2 * abs(fftSignal(2:floor(N2/2)+1)) / N2;
    
    % Frequency axis for the one-sided spectrum
    fs = samplingFrequency; % Replace your_sampling_frequency with the actual sampling frequency
    freq = (0:floor(N/2)-1) * fs / N2;

    df = N/samplingFrequency;
    
    % Loop through each frequency
    for i = 1:length(frequencies)
        
        % Find the index of the closest frequency to the target frequency
        [~, index] = min(abs(freq - frequencies(i)));

        amplitude = mean(FFT(index-1:index+1));
        outputAmplitudes(i) = amplitude;
        
    end
end
