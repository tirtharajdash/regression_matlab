function [trainedModel, validationRMSE] = trainRegressionModel(trainingData,invar,outvar)
% This function returns a trained regression model and its RMSE. 
%
%  Input:
%      trainingData: a matrix with the same number of columns and data type
%       as imported into the app.
%      
%      invar: input columns in the trainingData
%      outvar: output column in the training data
%
%  Output:
%      trainedModel: a struct containing the trained regression model. The
%       struct contains various fields with information about the trained
%       model.
%
%      trainedModel.predictFcn: a function to make predictions on new data.
%
%      validationRMSE: a double containing the RMSE. In the app, the
%       History list displays the RMSE for each model.
%
% To make predictions with the returned 'trainedModel' on new data T2, use
%   yfit = trainedModel.predictFcn(TestData)

% Extract the column names from the trainingData
VariableNames = {};
k=1;
for i = 1 : size(trainingData,2)
    VariableNames{k} = sprintf('column_%d',i);
    k = k + 1;
end

inputTable = array2table(trainingData, 'VariableNames', VariableNames);

% Extract predictor variables
preductorNames = {};
k = 1;
for i = invar
    predictorNames{k} = sprintf('column_%d',i);
    k = k + 1;
end
predictors = inputTable(:, predictorNames);

% Extract response
response = inputTable.(genvarname(sprintf('column_%d',outvar)));
isCategoricalPredictor = false(1,length(invar));

% Train a regression model
% This code specifies all the model options and trains the model.
concatenatedPredictorsAndResponse = predictors;
concatenatedPredictorsAndResponse.(genvarname(sprintf('column_%d',outvar))) = response;
linearModel = fitlm(...
    concatenatedPredictorsAndResponse, ...
    'linear', ...
    'RobustOpts', 'on');

% Create the result struct with predict function
predictorExtractionFcn = @(x) array2table(x, 'VariableNames', predictorNames);
linearModelPredictFcn = @(x) predict(linearModel, x);
trainedModel.predictFcn = @(x) linearModelPredictFcn(predictorExtractionFcn(x));

% Add additional fields to the result struct
trainedModel.LinearModel = linearModel;
trainedModel.About = 'This struct is a trained model exported from Regression Learner R2017a.';
trainedModel.HowToPredict = sprintf('To make predictions on a new predictor column matrix, X, use: \n  yfit = c.predictFcn(X) \nreplacing ''c'' with the name of the variable that is this struct, e.g. ''trainedModel''. \n \nX must contain exactly 5 columns because this model was trained using 5 predictors. \nX must contain only predictor columns in exactly the same order and format as your training \ndata. Do not include the response column or any columns you did not import into the app. \n \nFor more information, see <a href="matlab:helpview(fullfile(docroot, ''stats'', ''stats.map''), ''appregression_exportmodeltoworkspace'')">How to predict using an exported model</a>.');

VariableNames = {};
k=1;
for i = 1 : size(trainingData,2)
    VariableNames{k} = sprintf('column_%d',i);
    k = k + 1;
end

inputTable = array2table(trainingData, 'VariableNames', VariableNames);

preductorNames = {};
k = 1;
for i = invar
    predictorNames{k} = sprintf('column_%d',i);
    k = k + 1;
end
predictors = inputTable(:, predictorNames);
response = inputTable.(genvarname(sprintf('column_%d',outvar)));
isCategoricalPredictor = false(1,length(invar));

% Perform cross-validation
KFolds = 5;
cvp = cvpartition(response, 'KFold', KFolds);

% Initialize the predictions to the proper sizes
validationPredictions = response;
for fold = 1:KFolds
    trainingPredictors = predictors(cvp.training(fold), :);
    trainingResponse = response(cvp.training(fold), :);
    foldIsCategoricalPredictor = isCategoricalPredictor;
    
    % Train a regression model
    % This code specifies all the model options and trains the model.
    concatenatedPredictorsAndResponse = trainingPredictors;
    concatenatedPredictorsAndResponse.(genvarname(sprintf('column_%d',outvar))) = trainingResponse;
    linearModel = fitlm(...
        concatenatedPredictorsAndResponse, ...
        'linear', ...
        'RobustOpts', 'on');
    
    % Create the result struct with predict function
    linearModelPredictFcn = @(x) predict(linearModel, x);
    validationPredictFcn = @(x) linearModelPredictFcn(x);
    
    % Add additional fields to the result struct
    
    % Compute validation predictions
    validationPredictors = predictors(cvp.test(fold), :);
    foldPredictions = validationPredictFcn(validationPredictors);
    
    % Store predictions in the original order
    validationPredictions(cvp.test(fold), :) = foldPredictions;
end

% Compute validation RMSE
validationRMSE = sqrt(nansum(( validationPredictions - response ).^2) / numel(response));
