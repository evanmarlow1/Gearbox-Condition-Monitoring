function [TSA,TSA_RES,TSA_DIFF,TSA_REG] = TSASignals2(Data,Sample_Freq, Averaging_Freq, OrderList)
%TSA2 corrects error of inputting raw data into variants.


    %We take an array of signals as input, along with the frequency to
    %average over (e.g. BPFO, etc), the RPM of the shaft, and orders.

    
    DataRows = size(Data,1);                %Number of series to analyse
    DataPoints = size(Data,2);              %Number of data points per series
    
    MaxTime = DataPoints/Sample_Freq;       %Maximum Time Value
    Averaging_RPM = Averaging_Freq*60;      %Averaging Freq in RPM

    %-------------------------------------------------------------------------------%
    %TSA

    %Define pulse that determines start of rotations
    TPulse = 0:(1/Averaging_Freq):MaxTime;
    %TPulse = 1/Averaging_Freq;

    %Initialise our output arrays
    TSA = zeros(DataRows, floor(DataPoints/length(TPulse)));
    TSA_RES = zeros(DataRows, floor(DataPoints/length(TPulse)));
    TSA_DIFF = zeros(DataRows, floor(DataPoints/length(TPulse)));
    TSA_REG = zeros(DataRows, floor(DataPoints/length(TPulse)));

    %Loop through each row in our input data, and compute each TSA variant,
    %storing in our respective output arrays
    for i = 1:DataRows

        TSARow = tsa(Data(i,:),Sample_Freq,TPulse);
        TSA(i,:) = TSARow(1:length(TSA));
        %TSA(i,:) = TSARow;

        TSA_RES_Row = tsaresidual(TSARow,Sample_Freq,Averaging_RPM,OrderList);
        TSA_RES(i,:) = TSA_RES_Row(1:length(TSA_RES));

        TSA_DIFF_Row = tsadifference(TSARow,Sample_Freq,Averaging_RPM,OrderList);
        TSA_DIFF(i,:) = TSA_DIFF_Row(1:length(TSA_DIFF));

        TSA_REG_Row = tsaregular(TSARow,Sample_Freq,Averaging_RPM,OrderList);
        TSA_REG(i,:) = TSA_REG_Row(1:length(TSA_REG));

    end

end

