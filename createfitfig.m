function [fitresult, gof] = createfitfig(y, yfit)
[xData, yData] = prepareCurveData( y, yfit );

% Set up fittype and options.
ft = fittype( 'smoothingspline' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'Fitting' );
h = plot( fitresult, xData, yData );
legend( h, 'yfit vs. y', 'fitting curve', 'Location', 'NorthEast' );
% Label axes
xlabel y
ylabel yfit
grid on


