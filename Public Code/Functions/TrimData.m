function [TrimmedData] = TrimData(Data,N_points)
%TRIMDATA Clips off the first and last N datapoints in a signal

    n_rows = size(Data,1);
    n_cols = size(Data,2);

    TrimmedData = zeros(n_rows,n_cols - 2*N_points);

    for i = 1:n_rows
        TrimmedData(i,:) = Data(i,N_points:end - (N_points + 1));  
    end

end

