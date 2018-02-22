# regression_matlab
A Generic Code for using Regression Learners in MATLAB

There are two files: (1) trainRegressionModel.m, and (2) createfitfig.m

The first file creates the regression model (Robust Linear Regression) for the supplied training data. Here is the help file and explanation on how to use it. You can type "help trainRegressionModel" in matlab command window and get the relevant information about this function.

This function returns a trained regression model and its RMSE. 
  Input:
     trainingData: a matrix with the same number of columns and data type
      as imported into the app.
     
     invar: input columns in the trainingData
     outvar: output column in the training data
  Output:
    trainedModel: a struct containing the trained regression model. The
      struct contains various fields with information about the trained
      model.
      trainedModel.predictFcn: a function to make predictions on new data.
      validationRMSE: a double containing the RMSE. In the app, the
      History list displays the RMSE for each model.
 To make predictions with the returned 'trainedModel' on new data T2, use
   yfit = trainedModel.predictFcn(TestData)


The second file, creates the fitting curve for the test set. That is the plot between (True Y and Predicted Y).

# How to use these functions

Let us say you have a dataset (for regression) e.e. the popular house price prediction dataset. The format of data in the file is the following. Lets call this file as "data.txt".

__________________________________________________________________________

Feature1      Feature2       Feature3        Feature4 ...   FeatureN

1.11           2.22           3.33            4.44            6.66

2.22           3.33           4.44            5.55            7.77

__________________________________________________________________________


I have provided a main.m file. This file calls the above two functions. The main.m creates the training and testing data from the data.txt itself i.e. 70% for training and 30% testing. Of course, you can supply your own testing data. That should not be a problem.


# Note

It uses the existing matlab regression module. My program just provides you a flexibility over the specialized matlab instruction to call those modules. Note that the trainRegressionModel.m is still sub-optimal. I have not checkd a lot of input constraints such as response should not appear in the predictors itself and such like. I believe that the users will take care of those.
