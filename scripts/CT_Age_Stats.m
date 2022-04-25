%% Relationship Between CT and Age

%% Load Data
clear;
close all;
load('dataCleaned.mat');

%% Linear Fit - Age vs. CT Data
for i = 1:width(CT)
    all_linearfits{i} = fitlm(data_clean(:,5),CT(:,i));
    figure;
    plot(all_linearfits{i})
    title("Age vs. "+CT_desc(i))
    ylabel(CT_desc(i))
    xlabel("Age")
    disp(all_linearfits{i}.Coefficients)
end