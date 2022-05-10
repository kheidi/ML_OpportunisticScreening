%% Unsupervised for metabolic age?
% attempt to explore results of kmeans cluster
% attempt tp explore results for Principal component analysis (PAC) of raw
% data - this is a score

%% Load Data
clear;close all;clc;
load('dataCleaned.mat');

Age = CD(:,5);
CTData = [CT Age];

%% Kmeans vs PAC

for i = 1:15
    [idex{i}, C{i}] = kmeans(CTData,i);
end


%% Kmeans only females: 
indx_female = CD(:,4)==1;
femaleCT = CTData(indx_female, :); 

for i = 1:15
[idxF{i},C_F{i}] = kmeans(femaleCT,i);
end

%% Kmeans only males: 
indx_male = CD(:,4)==0;
maleCT = CTData(indx_male, :); 

for i = 1:15
[idxM{i},C_M{i}] = kmeans(maleCT,i);
end
