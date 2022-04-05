clear;
close all;

% cleanData();
load('dataCleaned.mat');

%% Explore age
cols=[5,13,15,17,19,21,23,25,27,29,31,33,35,37];
allDates = data_clean(:,cols);
allDates_desc = descriptions(cols);
allDates_years(:,1) = allDates(:,1);
allDates_years(:,2:length(cols)) = NaN;
allDates_years(:,2:end) = data_clean(:,5) + (allDates(:,2:end)/365);

ageAtCT = allDates_years(:,1);
ageAtDeath = allDates_years(:,2);
lastVisit = max([allDates_years(:,1),allDates_years(:,3:length(cols))],[],2);
for i = 1:length(ageAtDeath)
    if ~isnan(ageAtDeath(i))
        lastVisit(i) = NaN;
    end
end
figure;
plot(ageAtCT,lastVisit,'ro')
hold on
plot(20:110,20:110)
plot(ageAtCT,ageAtDeath,'b*')
legend("Alive", "", "Deceased")
xlabel("Age at CT")
ylabel("Age at Last Dx/Death")
disp("NaN Age at CT:")
disp(sum(isnan(ageAtCT)))
disp("NaN Age at death:")
disp(sum(isnan(ageAtDeath)))
