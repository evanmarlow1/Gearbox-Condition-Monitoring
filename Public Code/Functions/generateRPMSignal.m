function Signal = generateRPMSignal(RPM, Fs, N)

    
    duration = N/Fs;

    t = 0:1/Fs:duration;

    Signal = RPM*ones(1,length(t));

end