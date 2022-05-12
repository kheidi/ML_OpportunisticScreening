%% Finding "Days till Death" 
% As an initial exploration we will be training a KNN based on study
% participants that we have data on their death. This is a small percentage
% of the data but nonetheless we are interested in seeing how reliable the
% results are.

%% Load Data
clear;
close all;
load('dataCleaned.mat');

%% Subset of known deaths
idx_D = ~isnan(data_clean(:,13));
CT_D = CT(idx_D,:);
ageCT_D = data_clean(idx_D,5); 
days_from_CT = data_clean(idx_D, 13);
ageDeath = ageCT_D + (days_from_CT/365);

y = round(ageDeath);
kFolds = 6;
KNNfolds = 5;

%% Optimized
X = CT(idx_D,:);

% X(:,13) = CD(idx_D,7);

c = cvpartition(length(y),'KFold',kFolds);

% Normalize X
[X, maxes, mins] = normalizeMatByCols(X);
X(:,12) = CD(idx_D,4);
X(:,13) = CD(idx_D,4) + (data_clean(idx_D,1)/365);

figure;
for i = 1:kFolds

    idx = training(c,i); %indexes of current fold's training set
    tid = test(c,i); 

    trainX = X(idx,:);
    trainy = y(idx,:);
    testX = X(tid,:);
    testy = y(tid,:);

%     [trainX, maxes, mins] = normalizeMatByCols(trainX);
%     for ii = 1:length(testX)
%         testX(i,:) = normalizeFromTrain(testX(i,:), maxes, mins);
%     end

    N = ceil(sqrt(length(y)));
    matlab_nearestNeighbor = fitcknn(trainX,trainy,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
    y_est = predict(matlab_nearestNeighbor,testX);

    subplot(2,kFolds/2,i)
    plot(testy,y_est,'o')
    hold on
    plot(20:105,20:105)
    xlabel('True')
    ylabel('Prediction')

    sumRMSE = sum((testy-y_est).^2);
    
    RMSE(i) = (sumRMSE/length(testy))^(1/2);
    sumRMSE = 0;
    
    title("RMSE: ",RMSE(i))

    accuracy(i) = norm(abs(testy-y_est));
    meandiff(i) = mean(abs(testy-y_est));
    diff{:,i} = testy-y_est;

end
sgtitle(["Mean RMSE: ",mean(RMSE)])
set(gcf,'Position',[100 100 1000 600])
fprintf("RMSE = %f\n", mean(RMSE))
filename = strcat(pwd,'/figures/death/A_KNN_Final','.png');
saveas(gcf,filename);

%% Full Train

X_alive = CT(~idx_D,:);
[X_alive, maxes, mins] = normalizeMatByCols(X_alive);
X_alive(:,12) = CD(~idx_D,4);
X_alive(:,13) = CD(~idx_D,4) + (data_clean(~idx_D,1)/365);

matlab_nearestNeighbor_total = fitcknn(X,y,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
final_predicted = predict(matlab_nearestNeighbor_total,X_alive);

figure;
plot(CD(~idx_D,4),final_predicted,'.')
hold on
plot(20:105,20:105)
xlabel('Age at CT (years)')
ylabel('Predicted Age at Death (years)')
filename = strcat(pwd,'/figures/death/A_KNN_Final_Applied','.png');
saveas(gcf,filename);

%% Add CO Data
X_Op_Width = width(X);
for clinical = 1:width(CD)

    % Add CO Data
    X(:,X_Op_Width+1) = CO(idx_D,clinical); 

   
    c = cvpartition(length(y),'KFold',kFolds);


    % Normalize X
    [X, maxes, mins] = normalizeMatByCols(X);
    X(:,12) = CD(idx_D,4);
    X(:,13) = CD(idx_D,4) + (data_clean(idx_D,1)/365);

    figure;
    for i = 1:kFolds

        idx = training(c,i); %indexes of current fold's training set
        tid = test(c,i); 

        trainX = X(idx,:);
        trainy = y(idx,:);
        testX = X(tid,:);
        testy = y(tid,:);

    %     [trainX, maxes, mins] = normalizeMatByCols(trainX);
    %     for ii = 1:length(testX)
    %         testX(i,:) = normalizeFromTrain(testX(i,:), maxes, mins);
    %     end

        N = ceil(sqrt(length(y)));
        matlab_nearestNeighbor = fitcknn(trainX,trainy,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
        y_est = predict(matlab_nearestNeighbor,testX);

        subplot(2,kFolds/2,i)
        plot(testy,y_est,'o')
        hold on
        plot(20:105,20:105)
        xlabel('True')
        ylabel('Prediction')
        
        sumRMSE = sum((testy-y_est).^2);
    
        RMSE_CO(i) = (sumRMSE/length(testy))^(1/2);
        sumRMSE = 0;
        title("RMSE: ",RMSE_CO(i))


        accuracy(i) = norm(abs(testy-y_est));
        meandiff(i) = mean(abs(testy-y_est));
        diff{:,i} = testy-y_est;

    end
    sgtitle(['Added: ',CO_desc(clinical), "Error: ",mean(RMSE_CO)])
    set(gcf,'Position',[100 100 1000 600])
    fprintf("Added: %s, RMSE = %f\n", CO_desc(clinical), mean(RMSE_CO))
    filename = strcat(pwd,'/figures/death/KNN_',CO_desc(clinical),'.png');
    saveas(gcf,filename);
end

%% Add clinical data
for clinical = 1:width(CD)

    % Add Clinical Data
    X(:,X_Op_Width+1) = CD(idx_D,clinical); 

    c = cvpartition(length(y),'KFold',kFolds);


    % Normalize X
    [X, maxes, mins] = normalizeMatByCols(X);
    X(:,12) = CD(idx_D,4);
    X(:,13) = CD(idx_D,4) + (data_clean(idx_D,1)/365);

    figure;
    for i = 1:kFolds

        idx = training(c,i); %indexes of current fold's training set
        tid = test(c,i); 

        trainX = X(idx,:);
        trainy = y(idx,:);
        testX = X(tid,:);
        testy = y(tid,:);

    %     [trainX, maxes, mins] = normalizeMatByCols(trainX);
    %     for ii = 1:length(testX)
    %         testX(i,:) = normalizeFromTrain(testX(i,:), maxes, mins);
    %     end

        N = ceil(sqrt(length(y)));
        matlab_nearestNeighbor = fitcknn(trainX,trainy,'NumNeighbors', KNNfolds, 'Distance','euclidean','DistanceWeight','inverse');
        y_est = predict(matlab_nearestNeighbor,testX);

        subplot(2,kFolds/2,i)
        plot(testy,y_est,'o')
        hold on
        plot(20:105,20:105)
        xlabel('True')
        ylabel('Prediction')

        sumRMSE = sum((testy-y_est).^2);
    
        RMSE_CD(i) = (sumRMSE/length(testy))^(1/2);
        sumRMSE = 0;
        title("RMSE: ",RMSE_CD(i))

        accuracy(i) = norm(abs(testy-y_est));
        meandiff(i) = mean(abs(testy-y_est));
        diff{:,i} = testy-y_est;

    end
    sgtitle(['Added: ',CD_desc(clinical), "Error: ",mean(RMSE_CD)])
    set(gcf,'Position',[100 100 1000 600])
    fprintf("Added: %s, RMSE = %f\n", CD_desc(clinical), mean(RMSE_CD))
    filename = strcat(pwd,'/figures/death/KNN_',CD_desc(clinical),'.png');
    saveas(gcf,filename);
end
