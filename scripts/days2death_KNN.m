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

X = CT(idx_D,:);
y = ageDeath;

for clinical = 1:width(CD)

    %% Add Clinical Data
%     X(:,end) = CD(idx_D,4); % Age at CT
    X(:,12) = CD(idx_D,clinical); 

    %% Initial MATLAB Check
    k = 5;
    c = cvpartition(length(y),'KFold',k);


    % Normalize X
    [X, maxes, mins] = normalizeMatByCols(X);

    figure;
    for i = 1:k

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
        matlab_nearestNeighbor = fitcknn(trainX,trainy,'NumNeighbors', 2, 'Distance','cityblock');
        y_est = predict(matlab_nearestNeighbor,testX);

        subplot(1,5,i)
        plot(testy,y_est,'o')
        hold on
        plot(20:105,20:105)
        xlabel('True')
        ylabel('Prediction')
        

        accuracy(i) = norm(abs(testy-y_est));
        meandiff(i) = mean(abs(testy-y_est));
        diff{:,i} = testy-y_est;

    end
    sgtitle(['Added: ',CD_desc(clinical), "Error: ",mean(accuracy)])
    set(gcf,'Position',[100 100 1000 300])
    fprintf("Added: %s, error = %f\n", CD_desc(clinical), mean(accuracy))
    filename = strcat(pwd,'/figures/death/KNN_',CD_desc(clinical),'.png');
    saveas(gcf,filename);
end