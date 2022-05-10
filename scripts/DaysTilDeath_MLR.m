%% Age they will die

%% Load Data
clear;close all;clc;
load('dataCleaned.mat');

%% Gathering the patients that have died - Training Data
indx_dead = CO(:,1)==1;
TrainAge = (floor(CO(indx_dead,2)/365)) + CD(indx_dead,5); 
TrainCT = CT(indx_dead,:);

indx_alive = CO(:,1)==0;
TestCT = CT(indx_alive,:);

% Linear Fit: How does our data behaves
for i = 1:width(TrainCT)
    figure;
    Stats{i} = fitlm(TrainAge, TrainCT(:,i));
    plot(Stats{i})
    title("Age vs. "+CT_desc(i))
    ylabel(CT_desc(i))
    xlabel("Age")

    Rsquared = Stats{i}.Rsquared;
end


predictors=[ones(size(TrainCT)) TrainCT];
%This will create a regression model of type:
% Pre=b0+(b1*TrainCT(:,1))+(b2*TrainCT(:,2))+(b3*TrainCT(:,3))+...+(b11*TrainCT(:,11))
% it also gives stats and residuals   
[b,bint,r,rint,MLR_stats] = regress(TrainAge,predictors);

