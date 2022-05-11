%% Load Data
clear;
close all;
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

disp("Average # of patients in each group:")
target_count = round(mean(sum(idx_age_buckets)))

%% Oversample below mean
for i = 1:width(idx_age_buckets)
    num_idx_bucket{:,i} = find(idx_age_buckets(:,i));
    if patient_count(i) < target_count 
       difference = target_count - patient_count(i);
       r = round(1 + (patient_count(i)+1)*rand(difference,1));
       temp = num_idx_bucket{:,i};
       resamp = [temp; temp(r(:,1))];
       
       
   end
end
