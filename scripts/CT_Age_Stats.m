%% Relationship Between CT and Age

%% Load Data
clear;
close all;
load('dataCleaned.mat');

%% Linear Fit - Age vs. CT Data
% for i = 1:width(CT)
%     all_linearfits{i} = fitlm(data_clean(:,5),CT(:,i));
%     figure;
%     plot(all_linearfits{i})
%     title("Age vs. "+CT_desc(i))
%     ylabel(CT_desc(i))
%     xlabel("Age")
%     disp(all_linearfits{i}.Coefficients)
% end

%% Average in buckets by sex
% for i = 1: height(CT)
%     if CT(i,10)==0
%         CT(i,10) = nan;
%     end
% end
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

disp("Size of age groups")
sum(idx_age_buckets)

for i = 1:6
   CT_age.male.mean(i,:) = mean(CT(idx_age_buckets(:,i)&idx_male,:),'omitnan');
   CT_age.male.std(i,:) = std(CT(idx_age_buckets(:,i)&idx_male,:),'omitnan');
   CT_age.female.mean(i,:) = mean(CT(idx_age_buckets(:,i)&idx_female,:),'omitnan');
   CT_age.female.std(i,:) = std(CT(idx_age_buckets(:,i)&idx_female,:),'omitnan');
end


%% Polyfit CT by Sex
CT_male=CT(idx_male,:);
CT_female=CT(idx_female,:);
age_male = CD(idx_male,4);
age_female = CD(idx_female,4);

figure
for i = 1:11
    pfit.male(i,:) = polyfit(age_male,CT_male(:,i),2);
    fit_male(:,i) = polyval(pfit.male(i,:),linspace(0,100,1000));
    pfit.female(i,:) = polyfit(age_female,CT_female(:,i),2);
    fit_female(:,i) = polyval(pfit.female(i,:),linspace(0,100,1000)); 
    
    subplot(2,6,i)
    plot(age_male,CT_male(:,1),'bo',linspace(0,100,1000),fit_male(:,i),'b*') 
    hold on
    plot(age_female,CT_female(:,1),'ro',linspace(0,100,1000),fit_female(:,i),'r*') 
end
% for i = 1:11
%     
% end
%% Plot
figure;
for i = 1:11
    subplot(2,6,i)
    errorbar([1:6],CT_age.male.mean(:,i),CT_age.male.std(:,i),'-*')
    hold on
    errorbar([1:6],CT_age.female.mean(:,i),CT_age.female.std(:,i),'-*r')
    title(CT_desc(i))
    xlim([0,7])
    set(gca,'xtick',[1:6],'xticklabel',age_buckets)
end

%% Polyfit CT by Sex
CT_male=CT(idx_male,:);
CT_female=CT(idx_male,:);
age_male = CD(idx_male,4);
age_female = CD(idx_female,4);