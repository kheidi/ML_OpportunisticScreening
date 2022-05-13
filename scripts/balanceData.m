%% Load Data
clear;
close all;
cleanData();
load('dataCleaned.mat');

%% Average in buckets by sex
idx_male = CD(:,3)==0;
idx_female = CD(:,3)==1;
age_buckets = [
    "<40";
    "40-49";
    "50-59";
    "60-69";
    "70-79";
    "80+"];
idx_age_buckets(:,1) = CD(:,4)<40;
idx_age_buckets(:,2) = (CD(:,4)>=40) & (CD(:,4)<=49);
idx_age_buckets(:,3) = (CD(:,4)>=50) & (CD(:,4)<=59);
idx_age_buckets(:,4) = (CD(:,4)>=60) & (CD(:,4)<=69);
idx_age_buckets(:,5) = (CD(:,4)>=70) & (CD(:,4)<=79);
idx_age_buckets(:,6) = CD(:,4)>80;

disp("Size of age groups:")
patient_count = sum(idx_age_buckets)

figure;
bar(patient_count)
ylabel('Number of Samples')
xlabel('Age Group')
set(gca,'xtick',[1:6],'xticklabel',age_buckets, 'fontSize',18)

disp("Average # of patients in each group:")

target_count = round(mean(sum(idx_age_buckets)))

%% Oversample below mean
for i = 1:width(idx_age_buckets)
    num_idx_bucket{:,i} = find(idx_age_buckets(:,i));
    if patient_count(i) < target_count 
       difference = target_count - patient_count(i);
       r = round(1 + (patient_count(i)-1)*rand(difference,1));
       temp = num_idx_bucket{:,i};
       resamp_idx(:,i) = [temp; temp(r(:,1))];
    else
        difference = patient_count(i)-target_count;
        r = randperm(patient_count(i),difference); 
        temp = num_idx_bucket{:,i};
        temp(r) = [];
        resamp_idx(:,i) = temp;
   end
end

resamp_idx_all = sort(resamp_idx(:));


%% Create resampled subsets
ID_clean = ID(~idx_NaN,:);
data_clean = data_clean(resamp_idx_all,:);
data_balanced = data_clean;


clearvars -except data_balanced data descriptions data_clean resamp_idx_all

data = data(resamp_idx_all,:);
%% Seperate array into types
% Clinical Data
CD = data_balanced(:,2:12);
CD_desc = descriptions(2:12);

% Clinical Outcomes
% Metabolic syndrome included in clinical data and outcomes.
% Removes dates as well
cols = [12,14,16,18,20,22,24,26,28,30,32,34,36];
CO = data_balanced(:,cols);
CO_desc = descriptions(cols);

% Computerized Tomography Data
CT = data_balanced(:,38:48);
CT_desc = descriptions(38:48);

ID = data(:,1:3);

idx_male = CD(:,3)==0;
idx_female = CD(:,3)==1;
age_buckets = [
    "<40";
    "40-49";
    "50-59";
    "60-69";
    "70-79";
    "80+"];
idx_age_buckets_balanced(:,1) = CD(:,4)<40;
idx_age_buckets_balanced(:,2) = (CD(:,4)>=40) & (CD(:,4)<=49);
idx_age_buckets_balanced(:,3) = (CD(:,4)>=50) & (CD(:,4)<=59);
idx_age_buckets_balanced(:,4) = (CD(:,4)>=60) & (CD(:,4)<=69);
idx_age_buckets_balanced(:,5) = (CD(:,4)>=70) & (CD(:,4)<=79);
idx_age_buckets_balanced(:,6) = CD(:,4)>80;

disp("Size balanced of age groups:")
patient_count = sum(idx_age_buckets_balanced)

disp("Average # of patients in each group:")
target_count = round(mean(sum(idx_age_buckets_balanced)))

figure;
bar(patient_count)
ylabel('Number of Samples')
xlabel('Age Group')
ylim([0 6000])
set(gca,'xtick',[1:6],'xticklabel',age_buckets, 'fontSize',18)

save('dataBalancedAndCleaned.mat')