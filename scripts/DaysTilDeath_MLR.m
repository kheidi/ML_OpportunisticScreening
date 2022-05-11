%% Age they will die

%% Load Data
clear;close all;clc;
load('dataCleaned.mat');

%% Gathering the patients that have died - Training Data
indx_dead = CO(:,1)==1;

TrainAge = (floor(data_clean(indx_dead ,13)/365)) + CD(indx_dead,4); 
TrainCT = CT(indx_dead,:);

indx_alive = CO(:,1)==0;
TestAge = CD(indx_alive,4);
TestCT = CT(indx_alive,:);


%% K-fold validation fit linear regression

y = TrainAge;
kFolds = 10;
X = TrainCT;
c = cvpartition(length(y),'KFold',kFolds);

% Normalize X
[X, maxes, mins] = normalizeMatByCols(X);
X(:,12) = CD(indx_dead,4);
X(:,13) = CD(indx_dead,4) + (data_clean(indx_dead,1)/365);

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
        sumRMSE = (testy(n)-PredictedAges_fit(n))^2;
    end
    
    RMSE(i) = (sumRMSE/length(testy))^(1/2);
    accuracy(i) = norm(abs(testy-PredictedAges_fit));
    meandiff(i) = mean(abs(testy-PredictedAges_fit));
    diff{:,i} = testy-PredictedAges_fit;
  

end
sgtitle(["Error: ",mean(accuracy)])
set(gcf,'Position',[100 100 1000 600])
fprintf("Error = %f\n", mean(accuracy))

%% MLR all data

X_alive = TestCT;
[X_alive, maxes, mins] = normalizeMatByCols(X_alive);
X_alive(:,12) = TestAge;
X_alive(:,13) = CD(indx_alive,4) + (data_clean(indx_alive ,1)/365);

mdl = fitlm(X,y);
PredictedAges = predict(mdl,X_alive);

    for n = 1:length(y)
        sumRMSE = (y(n)-PredictedAges(n))^2;
    end
    
    RMSE_AllData = (sumRMSE/length(y))^(1/2);

figure;
plot(CD(indx_alive,4),PredictedAges,'o')
hold on
plot(20:105,20:105)
xlabel('Age at CT (years)')
ylabel('Predicted Age at Death (years)')



