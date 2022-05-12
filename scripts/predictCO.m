%% Finding "Days till Death" 
% As an initial exploration we will be training a KNN based on study
% participants that we have data on their death. This is a small percentage
% of the data but nonetheless we are interested in seeing how reliable the
% results are.

%% Load Data
clear;
close all;
load('dataCleaned.mat');

kFolds = 10;
KNNfolds = 5;

%% Predict Outcomes

X = CT(:,:);
[X, maxes, mins] = normalizeMatByCols(X);


for j = 1:width(CO)
    % Set clinical outcome that you want to predict
    outcomes = CO(:,j);
    idx_pos = find(outcomes==1);
    idx_neg = find(outcomes==0);
    r = randperm(length(idx_neg),length(idx_pos)); 
    selected_neg = idx_neg(r);
    
    idx_selected = sort([idx_pos;selected_neg]);
    y = CO(idx_selected,j);
    X = CT(idx_selected,:);
    [X, maxes, mins] = normalizeMatByCols(X);

    % Generate n-fold validation folds
    c = cvpartition(length(y),'KFold',kFolds);
    
    figure;
    for i = 1:kFolds

        idx = training(c,i); %indexes of current fold's training set
        tid = test(c,i); 

        trainX = X(idx,:);
        trainy = y(idx,:);
        testX = X(tid,:);
        testy = y(tid,:);

        matlab_nearestNeighbor = fitcknn(trainX,trainy,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
        y_est = predict(matlab_nearestNeighbor,testX);
        
        count_wrong = sum(abs(testy-y_est));
        count_correct = length(testy)-count_wrong;
        percent_correct = count_correct/(length(testy));
        accuracy(i) = percent_correct;
        bar(i,percent_correct);
        hold on

    end
    xlabel('Fold #')
    ylabel('Percent Correct')
    title(["Clinical Outcome: ",CO_desc(j),"Accuracy: ",mean(accuracy)])

    matlab_nearestNeighbor_total = fitcknn(X,y,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
    CT_All = CT(:,:);
    [CT_All , maxes, mins] = normalizeMatByCols(CT_All );
    final_predicted = predict(matlab_nearestNeighbor_total,CT_All);
    count_wrong = sum(abs(CO(:,j)-final_predicted));
    count_correct = length(CO(:,j))-count_wrong;
    percent_correct = count_correct/(length(CO(:,j)));
    figure;
    bar(1,percent_correct);
    title([CO_desc(j)," accuracy on whole set: ",percent_correct])

    
end