function convertSignalToScalogram(ensemble,folderName)
% Convert 1-D signals to scalograms and save scalograms as images
data = read(ensemble);                                                      % reads in data
fs = data.sr;                                                               % gets sample rate
x = data.gs{:};                                                             % gets vib data
label = char(data.Label);                                                   % gets fault label
fname = char(data.FileName);                                                % gets file name
ratio = 5000/97656;                                                         %
interval = ratio*fs;                                                        % These lines split signal (we have done this already)
N = floor(numel(x)/interval);                                               % 

% Create folder to save images                                              % Creates folder for images
path = fullfile('.',folderName,label);
if ~exist(path,'dir')
  mkdir(path);
end

for idx = 1:N                                                               % for each segment:
  sig = envelope(x(interval*(idx-1)+1:interval*idx));                       % computes envelope for segment
  cfs = cwt(sig,'amor', seconds(1/fs));                                     % continuous wavelet transform
  cfs = abs(cfs);                                                           % magnitude
  img = ind2rgb(round(rescale(flip(cfs),0,255)),jet(320));                  % converts to image compatible with Squeezenet
  outfname = fullfile('.',path,[fname '-' num2str(idx) '.jpg']);            % file name
  imwrite(imresize(img,[227,227]),outfname);                                % writes image to file
end
end




