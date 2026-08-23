function [CIArray] = ComputeTimeDomainCIs(Data, Sample_Freq, Averaging_Freq)
%COMPUTETIMEDOMAINCIS For a given dataset, we will return the relevant
%condition indicators as an array

%Data is an array that has a row for each time series to analyses, and a
%column for each data point e.g. 10x1000 will have 10 series with 1000 data
%points.

%CIArray has a row for each time series, and each column will be a
%specified value for a condition indicator.


    DataRows = size(Data,1);                %Number of series to analyse
    DataPoints = size(Data,2);              %Number of data points per series
    CIArray = zeros(DataRows,4);            %Output array
    MaxTime = DataPoints/Sample_Freq;       %Maximum Time Value

    %RMS
    RMS = rms(Data,2);
    CIArray(:,1) = RMS;

    %Crest Factor
    CF = peak2rms(Data,2);
    CIArray(:,2) = CF;

    %PeaktoPeak
    P2P = peak2peak(Data,2);
    CIArray(:,3) = P2P;

    %Kurtosis
    Kurtosis = kurtosis(Data,1,2);
    CIArray(:,4) = Kurtosis;

    %Now we find the TSA of the signal

    TPulse = 0:(1/Averaging_Freq):MaxTime;
    TSA_Data = zeros(DataRows, floor(DataPoints/length(TPulse))); %Intialise

    for i = 1:DataRows

        TSARow = tsa(Data(i,:),Sample_Freq,TPulse);
        TSA_Data(i,:) = TSARow(1:length(TSA_Data));

    end

    %We can't find residual, difference, or normal signal without an order
    %list & RPM.


end

