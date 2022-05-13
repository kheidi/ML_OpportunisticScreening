%% Predicting Other Adverse Outcomes with KNN

%% Load Data
clear;
close all;
load('dataCleaned.mat');

kFolds = 10;
KNNfolds = 5;

%% Predict Outcomes

X = CT(:,:);
[X, maxes, mins] = normalizeMatByCols(X);

figure;

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
    
    subplot(7,2,j)
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
        percent_correct = 100*(count_correct/(length(testy)));
        accuracy(i) = percent_correct;
        bar(i,percent_correct);
        hold on

    end
    xlabel('Fold #')
    ylabel('Percent Correct')
    title([CO_desc(j)])
    ylim([0 100])
    yline(mean(accuracy),'k--')
    set(gca,'xtick',[1:kFolds],'xticklabel',[1:kFolds], 'fontSize',12)
    fprintf("%s;%f\n", CO_desc(j), mean(accuracy))

    matlab_nearestNeighbor_total = fitcknn(X,y,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
    CT_All = CT(:,:);
    [CT_All , maxes, mins] = normalizeMatByCols(CT_All );
    final_predicted = predict(matlab_nearestNeighbor_total,CT_All);
    count_wrong = sum(abs(CO(:,j)-final_predicted));
    count_correct = 100*(length(CO(:,j))-count_wrong);
    percent_correct = count_correct/(length(CO(:,j)));
%     figure;
%     bar(1,percent_correct);
%     title([CO_desc(j)," accuracy on whole set: ",percent_correct])

    
end