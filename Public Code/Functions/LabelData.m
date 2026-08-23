function LabelData(data, variableName)
    
    [numRows, ~] = size(data);

    % Make a cell array so that we can store the titles
    globalVars = cell(1, numRows);

    % Calculate the number of digits needed for numbering
    numDigits = floor(log10(numRows)) + 1;

    % Make labels
    for i = 1:numRows

        % Create the label using 'i' with leading zeros
        uniqueVarName = [variableName, '_', sprintf(['%0', num2str(numDigits), 'd'], i)];
        
        % Store the variable name in the cell array
        globalVars{i} = uniqueVarName;
        
        % Create a new variable with the name and assign the data to it
        eval([uniqueVarName, ' = data(i, :);']);

    end

    % Make variables global using 'assignin' to assign variables globally
    for i = 1:numRows

        assignin('base', globalVars{i}, eval(globalVars{i}));

    end
end


