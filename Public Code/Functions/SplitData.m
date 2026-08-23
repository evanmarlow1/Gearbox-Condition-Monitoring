function [SplitData] = SplitData(Data,N)
%SPLITDATA Splits an input signal into N equally sized subsets of the
%signal

DataLength = length(Data);

SplitLength = floor(DataLength/N);

SplitData = zeros(N,SplitLength);

for i = 1:N

    SplitData(i,:) = Data((i-1)*SplitLength+1:i*SplitLength);

end

end










