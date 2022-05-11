%% Age they will die:
% This script uses Multi Linear Regression to calculate the age a person
% will die based on their CT scan data. It also compares how adding clinical
% outcome and clinical data affects the acuracy of the MLR model.

%% Load Data
cleanData();
clear;close all;clc;
% load('dataCleaned.mat');
% data = data_clean;
load('dataBalancedAndCleaned.mat');
data = data_balanced;

%% Training/Test Data
% Dividing data. Test data is the patients that are dead and Train data is
% the patinets that are alive.

% Train Data
indx_dead = CO(:,1)==1;
TrainAge = (floor(data(indx_dead ,13)/365)) + CD(indx_dead,4); 
TrainCT = CT(indx_dead,:);
% Test Data
indx_alive = CO(:,1)==0;
TestAge = CD(indx_alive,4);
TestCT = CT(indx_alive,:);

%% K-fold validation fit linear regression
% K-fold validation using only patients that are dead to see how accurate
% our model is. 

y = TrainAge;
kFolds = 10;
X = TrainCT;
c = cvpartition(length(y),'KFold',kFolds);

% Normalize X
[X, maxes, mins] = normalizeMatByCols(X);
X(:,12) = CD(indx_dead,4);
X(:,13) = CD(indx_dead,4) + (data(indx_dead,1)/365);

sumRMSE=0;
figure;

for i = 1:kFolds

    idx = training(c,i); %indexes of current fold's training set
    tid = test(c,i); 

    trainX = X(idx,:);
    trainy = y(idx,:);
    testX = X(tid,:);
    testy = y(tid,:);

    fit_mdl = fitlm(trainX,trainy);
    PredictedAges_fit = predict(fit_mdl,testX);

    subplot(2,kFolds/2,i)
    plot(testy,PredictedAges_fit,'o')
    hold on
    plot(20:105,20:105)
    xlabel('Actual Age')
    ylabel('Prediction')

    for n = 1:length(testy)
        sumRMSE = sumRMSE + (testy(n)-PredictedAges_fit(n))^2;
    end
    
    RMSE(i) = (sumRMSE/length(testy))^(1/2);
    title("RMSE: ",RMSE(i))
    accuracy(i) = norm(abs(testy-PredictedAges_fit));
    meandiff(i) = mean(abs(testy-PredictedAges_fit));
    diff{:,i} = testy-PredictedAges_fit;
  

end
sgtitle(["Error: ",mean(accuracy)])
set(gcf,'Position',[100 100 1000 600])
fprintf("Error = %f\n", mean(accuracy))

%% MLR all data
% Running our model in all the data. Trained with the patients that are
% dead and tested on the ones alive. 

X_alive = TestCT;
[X_alive, maxes, mins] = normalizeMatByCols(X_alive);
X_alive(:,12) = TestAge;
X_alive(:,13) = CD(indx_alive,4) + (data(indx_alive ,1)/365);

mdl = fitlm(X,y);
PredictedAges = predict(mdl,X_alive);

figure;
plot(CD(indx_alive,4),PredictedAges,'o')
hold on
plot(20:105,20:105)
title("RMSE: ",RMSE_AllData)
xlabel('Age at CT (years)')
ylabel('Predicted Age at Death (years)')

%% Add CO Data
% Here we added one Clinical outcome at a time to see how it affects the
% accuracy of our model. 

X_Op_Width = width(X);
for clinical = 2:width(CD) % Started at 2 to not use the TF if they are dead or alive

    % Add CO Data
    X(:,X_Op_Width+1) = CO(indx_dead,clinical); 
    c = cvpartition(length(y),'KFold',kFolds);

    % Normalize X
    [X, maxes, mins] = normalizeMatByCols(X);
    X(:,12) = CD(indx_dead,4);
    X(:,13) = CD(indx_dead,4) + (data(indx_dead,1)/365);

    sumRMSE = 0;
    figure;
    for i = 1:kFolds

        idx = training(c,i); %indexes of current fold's training set
        tid = test(c,i); 

        trainX = X(idx,:);
        trainy = y(idx,:);
        testX = X(tid,:);
        testy = y(tid,:);

        CO_mdl = fitlm(trainX,trainy);
        PredictedAges_CO = predict(CO_mdl,testX);

        subplot(2,kFolds/2,i)
        plot(testy,PredictedAges_CO,'o')
        hold on
        plot(20:105,20:105)
        xlabel('True')
        ylabel('Prediction')
        
        for n = 1:length(testy)
            sumRMSE = sumRMSE + (testy(n)-PredictedAges_CO(n))^2;
        end
            
        RMSE_CO(i) = (sumRMSE/length(testy))^(1/2);
        title("RMSE: ",RMSE_CO(i))

        accuracy(i) = norm(abs(testy-PredictedAges_CO));
        meandiff(i) = mean(abs(testy-PredictedAges_CO));
        diff{:,i} = testy-PredictedAges_CO;

    end
    sgtitle(['Added: ',CO_desc(clinical), "Error: ",mean(accuracy)])
    set(gcf,'Position',[100 100 1000 600])
    fprintf("Added: %s, error = %f\n", CO_desc(clinical), mean(accuracy))
   
end

%% Add clinical data
% Here we added one Clinical data at a time to see how it affects the
% accuracy of our model. 

for clinical = 1:(width(CD)-1) % -1 because I don't want to use the clumn of dead or alive. 

    % Add Clinical Data
    X(:,X_Op_Width+1) = CD(indx_dead,clinical); 
    c = cvpartition(length(y),'KFold',kFolds);

    % Normalize X
    [X, maxes, mins] = normalizeMatByCols(X);
    X(:,12) = CD(indx_dead,4);
    X(:,13) = CD(indx_dead,4) + (data(indx_dead,1)/365);

    sumRMSE = 0;
    figure;
    for i = 1:kFolds

        idx = training(c,i); %indexes of current fold's training set
        tid = test(c,i); 

        trainX = X(idx,:);
        trainy = y(idx,:);
        testX = X(tid,:);
        testy = y(tid,:);

        CD_mdl = fitlm(trainX,trainy);
        PredictedAges_CD = predict(CD_mdl,testX);        

        subplot(2,kFolds/2,i)
        plot(testy,PredictedAges_CD ,'o')
        hold on
        plot(20:105,20:105)
        xlabel('True')
        ylabel('Prediction')

        for n = 1:length(testy)
            sumRMSE = sumRMSE + (testy(n)-PredictedAges_CD (n))^2;
        end
            
        RMSE_CD(i) = (sumRMSE/length(testy))^(1/2);
        title("RMSE: ",RMSE_CD(i))
        accuracy(i) = norm(abs(testy-PredictedAges_CD));
        meandiff(i) = mean(abs(testy-PredictedAges_CD));
        diff{:,i} = testy-PredictedAges_CD ;

    end
    sgtitle(['Added: ',CD_desc(clinical), "Error: ",mean(accuracy)])
    set(gcf,'Position',[100 100 1000 600])
    fprintf("Added: %s, error = %f\n", CD_desc(clinical), mean(accuracy))
end


