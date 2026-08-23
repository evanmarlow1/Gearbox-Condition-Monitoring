function Signal = generateTachoSignal(RPM, Fs, N)

    Tp = 60/RPM;
    
    duration = N/Fs;

    t = 0:1/Fs:duration;

    Signal = zeros(1,length(t));

    tolerance = 1e-4; % Adjust the tolerance as needed

    for i = 1:N
        if abs(mod(t(i), Tp) - 0) < tolerance
            Signal(i) = 1;
        end
    end

end

