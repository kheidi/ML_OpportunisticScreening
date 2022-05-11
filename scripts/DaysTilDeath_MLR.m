%% Age they will die

%% Load Data
clear;close all;clc;
load('dataCleaned.mat');

%% Gathering the patients that have died - Training Data
indx_dead = CO(:,1)==1;
TrainAge = (floor(CO(indx_dead,2)/365)) + CD(indx_dead,5); 
TrainCT = CT(indx_dead,:);

indx_alive = CO(:,1)==0;
TestAge = CD(indx_alive,5);
TestCT = CT(indx_alive,:);;

%TrainAge = normalizeColumn((floor(CO(indx_dead,2)/365)) + CD(indx_dead,5)); 
%TrainCT = normalizeMatByCols(CT(indx_dead,:));


% % Linear Fit: How does our data behaves
% for i = 1:width(TrainCT)
%     figure;
%     Stats{i} = fitlm(TrainAge, TrainCT(:,i));
%     plot(Stats{i})
%     title("Age vs. "+CT_desc(i))
%     ylabel(CT_desc(i))
%     xlabel("Age")
% 
%     Rsquared = Stats{i}.Rsquared;
% end


%% MLR with CT Data

% predictors=[ones(size(TrainCT)) TrainCT];
% %This will create a regression model of type:
% % Pre=b0+(b1*TrainCT(:,1))+(b2*TrainCT(:,2))+(b3*TrainCT(:,3))+...+(b11*TrainCT(:,11))
% % it also gives stats and residuals   
% [b,bint,r,rint,MLR_stats] = regress(TrainAge,predictors);

%fit Linear regression model
fit_mdl = fitlm(TrainCT,TrainAge);
PredictedAges_fit = predict(fit_mdl,TestCT);

%stepwise linear regression model
sw_mdl = stepwiselm(TrainCT,TrainAge);
PredictedAges_sw = predict(sw_mdl,TestCT);






% %% Test and Train data: 
% 
% % Cross varidation (train: 70%, test: 30%)
% cv = cvpartition(size(CTData,1),'HoldOut',0.3);
% idx = cv.test;
% % Separate to training and test data
% TrainCT = data(~idx,:);
% TestCT  = data(idx,:);







%scatter(ActualAge, PredictedAges);


% %% Adding Clinical Data
% 
% indx_dead = CO(:,1)==1;
% TrainCD = normalizeMatByCols(CD(indx_dead,:));
% indx_alive = CO(:,1)==0;
% TestCD = normalizeMatByCols(CD(indx_alive,:));
% 
% for j = 1:width(TrainCD)
% NewTrainDataCD = [TrainCT TrainCD(:,j)];
% NewTestDataCD = [TestCT TestCD(:,j)];
% 
% mdlCD = fitlm(NewTrainDataCD,TrainAge);
% PredictedAgesCD = predict(mdlCD,NewTestDataCD);
% 
% % predictors=[ones(size(NewTrainData)) NewTrainData];
% % [bCD{j},bintCD{j},rCD{j},rintCD{j},MLR_statsCD{j}] = regress(TrainAge,predictors);
% end
% 
% %% Adding CO
% indx_dead = CO(:,1)==1;
% TrainCO = normalizeMatByCols(CO(indx_dead,:));
% indx_alive = CO(:,1)==0;
% TestCO = normalizeMatByCols(CD(indx_alive,:));
% 
% for j = 2:width(TrainCO)
% NewTrainDataCO= [TrainCT TrainCO(:,j)];
% NewTestDataCO = [TestCT TestCO(:,j)];
% 
% mdlCO = fitlm(NewTrainDataCO,TrainAge);
% PredictedAgesCO = predict(mdlCO,NewTestDataCO);
% 
% % predictors=[ones(size(NewTrainDataCO)) NewTrainDataCO];
% % [bCO{j},bintCO{j},rCO{j},rintCO{j},MLR_statsCO{j}] = regress(TrainAge,predictors);
%end 


