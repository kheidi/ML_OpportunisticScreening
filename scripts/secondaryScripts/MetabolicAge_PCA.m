%% PCA - Principal component analysis
% Predict Metabolic Age

%% Load Data
clear;close all;clc;
load('dataCleaned.mat');

Age = CD(:,4);
CTData = [CT Age];

[coeff,score,latent,tsquared,explained,mu] = pca(CTData);


data = rand(54000,10);
cv = cvpartition(size(CTData,1),'HoldOut',0.3);
idx = cv.test;
TrainCT = data(~idx,:);
TestCT  = data(idx,:);

[coeff,scoreTrain,~,~,explained,mu] = pca(TrainCT);

idEx = find(cumsum(explained)>95,1)
scoreTrain95 = scoreTrain(:,1:idx);
mdl = fitctree(scoreTrain95,YTrain);