D = dlmread('data.txt','\t',1,0); %Ignore the first row

%Training data

K = randperm(size(D,1));

sz = round(0.70*size(D,1));

D_trn = D(K(1:sz),:);

D_tst = D(K(sz+1:size(D,1)),:);

invar = [1 2 4 5 6]; %Input features, or predictors. Here you can provide your input feature column IDs.

outvar = 3; %Response. Here you can provide your response column ID.


%train

X = D_trn(:,invar);

Y = D_trn(:,outvar);

[trainedModel, validationRMSE] = trainRegressionModel(D,invar,outvar);

fprintf('Trained the model; Goodness of fit\n');

trainedModel

fprintf('ValidationRMSE = %f\n\n',validationRMSE);


%test the regression model

X = D_tst(:,invar);

Y = D_tst(:,outvar);

Yfit = trainedModel.predictFcn(X);


%create the fitting results

[fitresult, gof] = createfitfig(Y, Yfit);
