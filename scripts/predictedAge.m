clear
data= readmatrix('OppScrData.xlsx'); %change this to Heidi's other file
%%
[NumOfPeople, features]=size(data);

plot(sort(data(:,8)))
SamplesPerAge=0;

for i=1:NumOfPeople
    for age = min(data(:,8)):max(data(:,8))
        IndexByAge{age}=find(data(:,8)==age);
    end
end

figure
for i=1:95
    scatter(i,length(IndexByAge{i}))
    hold on
end
title('sample size by age')

%% Averaging CT data by age 

for age=1:length(IndexByAge)
    for j=IndexByAge{age}
        L1_HU_BMD(age)=nanmean(data(j,42));
        TAT_Area(age)=nanmean(data(j,43));
        TotalBodyArea(age)=nanmean(data(j,44));
        VAT_Area(age)=nanmean(data(j,45));
        SAT_Area(age)=nanmean(data(j,46));
        VAT_SAT_Ratio(age)=nanmean(data(j,47));
        MuscleHU(age)=nanmean(data(j,48));
        Muscle_Area(age)=nanmean(data(j,49));
        L3_SMI(age)=nanmean(data(j,50));
        AoCaAgatston(age)=nanmean(data(j,51));
        LiverHU(age)=nanmean(data(j,52));
    end
end


figure
scatter(1:95,L1_HU_BMD)
title('average L1_HU_BMD by age')

figure
scatter(1:95,TAT_Area)
title('average TAT_Area by age')

figure
scatter(1:95,TotalBodyArea)
title('average TotalBodyArea by age')


figure
scatter(1:95,VAT_Area)
title('average VAT_Area by age')


figure
scatter(1:95,SAT_Area)
title('average SAT_Area by age')

figure
scatter(1:95,VAT_SAT_Ratio)
title('average VAT_SAT_Ratio by age')
      
figure
scatter(1:95,TAT_Area)
title('average TAT_Area by age')
        
figure
scatter(1:95,Muscle_Area)
title('average Muscle_Area by age')

figure
scatter(1:95,L3_SMI)
title('average L3_SMI by age')

figure
scatter(1:95,AoCaAgatston)
title('average AoCaAgatston by age')

figure
scatter(1:95,LiverHU)
title('average LiverHU by age')
 
