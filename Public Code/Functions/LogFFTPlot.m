function [P1 , frequencies] = LogFFTPlot(Signal, Fs)
    % FFTPlot plots the positive frequencies of the FFT transform.
    
    % Compute parameters
    L = length(Signal);             % Length of signal
    T = 1/Fs;                       % Sampling period
    t = (0:L-1)*T;                  % Time vector

    % Compute the FFT
    Y = fft(Signal);

    % Compute the two-sided spectrum
    P2 = log(abs(Y/L));                      % Normalisation by Length of signal - consistent with Parseval's
    P1 = P2(1:floor(L/2)+1);            % Positive frequency amplitudes only

    % Define the frequency axis
    frequencies = Fs*(0:floor(L/2))/L;  % Positive frequencies

    % Plot the single-sided amplitude spectrum
    %figure;
    %plot(frequencies, P1);
    xlabel('Frequency (Hz)');
    ylabel('Amplitude');

end


