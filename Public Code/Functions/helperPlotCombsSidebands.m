function helperPlotCombsSidebands(ncomb, f, fm, nsidebands)
%HELPERPLOTCOMBSSIDEBANDS Plot harmonic cursors and sidebands on a power spectrum plot

ylimit = get(gca, 'YLim');
ylim(ylimit);
ycomb = repmat([ylimit nan], 1, ncomb);
hold on

% Plot harmonics
for i = 1:length(f)
    xcomb = f(i)*(1:ncomb);
    xcombs = [xcomb; xcomb; nan(1, ncomb)];
    xcombs = xcombs(:)';
    plot(xcombs, ycomb, '--','Color','red')
    
    % Plot sidebands for each harmonic
    for j = 1:nsidebands
        xsidebandsabove = (xcomb + j * fm);
        xsidebandsabove = [xsidebandsabove; xsidebandsabove; nan(1, ncomb)];
        xsidebandsabove = xsidebandsabove(:)';
        plot(xsidebandsabove, ycomb, '-.','Color',[0 0.5 0])  % Use a different linestyle for sidebands
        
        xsidebandsbelow = (xcomb - j * fm);
        xsidebandsbelow = [xsidebandsbelow; xsidebandsbelow; nan(1, ncomb)];
        xsidebandsbelow = xsidebandsbelow(:)';
        plot(xsidebandsbelow, ycomb, '-.','Color', [0 0.5 0])  % Use a different linestyle for sidebands
    end
end

hold off
end
