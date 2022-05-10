%% Trying to get an equation to calculate biological age: 

%% Load Data
clear;close all;clc;
load('dataCleaned.mat');

Age = normalizeColumn(CD(:,5));
CTData = normalizeMatByCols(CT);


for i = 1:width(CTData)
    Corr{i} = corrcoef(CTData(:,i), Age);
end