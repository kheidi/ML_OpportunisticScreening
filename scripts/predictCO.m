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
% X(:,12) = CD(idx_D,4);
% X(:,13) = CD(idx_D,4) + (data_clean(idx_D,1)/365);

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
%     
%     y = [outcomes(idx_pos);outcomes(selected_neg)]
%     y = CO(:,j);  
%     
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
        
        
% 
%         subplot(2,kFolds/2,i)
% %         plot(testy,y_est,'o')
% %         plotconfusion(testy.',y_est.')
%         
%         
% 
%         sumRMSE = sum((testy-y_est).^2);
% 
%         RMSE(i) = (sumRMSE/length(testy))^(1/2);
%         sumRMSE = 0;
% 
%         title("RMSE: ",RMSE(i))
% 
%         accuracy(i) = norm(abs(testy-y_est));
%         meandiff(i) = mean(abs(testy-y_est));
%         diff{:,i} = testy-y_est;

    end
    xlabel('Fold #')
    ylabel('Percent Correct')
    title(["Clinical Outcome: ",CO_desc(j),"Accuracy: ",mean(accuracy)])
%     set(gcf,'Position',[100 100 1000 600])
%     fprintf("Error = %f\n", mean(RMSE))
%     filename = strcat(pwd,'/figures/death/A_KNN_Final','.png');
%     saveas(gcf,filename);

    matlab_nearestNeighbor_total = fitcknn(X,y,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
    final_predicted = predict(matlab_nearestNeighbor_total,CT(:,:));
    count_wrong = sum(abs(CO(:,j)-final_predicted));
    count_correct = length(CO(:,j))-count_wrong;
    percent_correct = count_correct/(length(CO(:,j)));
    figure;
    bar(1,percent_correct);
    title([CO_desc(j)," accuracy on whole set: ",percent_correct])

    
end