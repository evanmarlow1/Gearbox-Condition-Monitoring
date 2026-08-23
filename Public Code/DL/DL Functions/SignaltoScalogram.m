function SignaltoScalogram(data,folderName,fileidentifier,label)
    % Convert 1-D signals to scalograms and save scalograms as images
          
    fs = 64000;
    x = data{1,1};

    % Create folder to save images
    path = fullfile('.',folderName,label);
    if ~exist(path,'dir')
        mkdir(path);
    end
    

    sig = envelope(x.Vibration);
    cfs = cwt(sig,'amor', seconds(1/fs));
    cfs = abs(cfs);
    img = ind2rgb(round(rescale(flip(cfs),0,255)),jet(320));
    % Format file identifier with leading zeros
    fileIdentifierStr = sprintf('%06d', fileidentifier);
    
    outfname = fullfile('.', path, [fileIdentifierStr '.jpg']);
    imwrite(imresize(img, [227, 227]), outfname);

end






    


