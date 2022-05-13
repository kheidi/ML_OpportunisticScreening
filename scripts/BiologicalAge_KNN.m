%This file predicts the biological Age using K Nearest Neighbors
clear;
close all;
load('dataCleaned.mat');
%% KNN

Age = CD(:,4);
CTData = [CT Age];
%this predicts the biological age using the average of the K
%neighbors actual ages around it
[predictedAgeMean, predictedAgeMode] = nearestneighbors_cleandata_v2(CTData,CTData, CD(:,4), 5, zeros(90,1));

%% Smoker vs Nonsmoker significance
counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,5)==0)
        RoundedAge=round(CD(i,4));
        Bin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end
nonsmoCounter=1;
for age=1:95
    if ~isempty(Bin{age})
        for j=1:length(Bin{age})
            ActMinusMet{age}(j)=Bin{age}(j)-age;
            nonSmoDiff(nonsmoCounter)=Bin{age}(j)-age;
            nonsmoCounter=nonsmoCounter+1;
        end
    end
end

counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,5)==1)
        RoundedAge=round(CD(i,4));
        BadBin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end

smoCounter=1;
for age=1:95
    if ~isempty(BadBin{age})
        for j=1:length(BadBin{age})
            ActMinusMetBad{age}(j)=BadBin{age}(j)-age;
            SmoDiff(smoCounter)=BadBin{age}(j)-age;
            smoCounter=nonsmoCounter+1;
        end
    end
end


% t test
avgAgeDiff=mean(predictedAgeMean)-mean(CD(:,4));

[hSmo,pSmo] = ttest(SmoDiff,avgAgeDiff,'Tail','right');
[hnonSmo,pnonSmo] = ttest(nonSmoDiff,avgAgeDiff,'Tail','right');
%% BMI test
clear Bin; clear BadBin;
counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,2)==0)
        RoundedAge=round(CD(i,4));
        Bin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end
BMICounter=1;
for age=1:95
    if ~isempty(Bin{age})
        for j=1:length(Bin{age})
            ActMinusMet{age}(j)=Bin{age}(j)-age;
            BMIdiff(BMICounter)=Bin{age}(j)-age;
            BMICounter=BMICounter+1;
        end
    end
end

counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,2)==1)
        RoundedAge=round(CD(i,4));
        BadBin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end

BMI30Counter=1;
for age=1:91
    if ~isempty(BadBin{age})
        for j=1:length(BadBin{age})
            ActMinusMetBad{age}(j)=BadBin{age}(j)-age;
            BMI30Diff(BMI30Counter)=BadBin{age}(j)-age;
            BMI30Counter=BMI30Counter+1;
        end
    end
end

% t test
%avgAgeDiff=mean(predictedAgeMean)-mean(CD(:,4));

[hBMI,pBMI] = ttest(BMIdiff,avgAgeDiff,'Tail','right');
[hBMI30,pBMI30] = ttest(BMI30Diff,avgAgeDiff,'Tail','right');



%% metabolic test
clear Bin; clear BadBin;
counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,10)==0)
        RoundedAge=round(CD(i,4));
        Bin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end
goodCounter=1;
for age=1:95
    if ~isempty(Bin{age})
        for j=1:length(Bin{age})
            ActMinusMet{age}(j)=Bin{age}(j)-age;
            NoMetabolicSyndromeDiff(goodCounter)=Bin{age}(j)-age;
            goodCounter=goodCounter+1;
        end
    end
end

counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,10)==1)
        RoundedAge=round(CD(i,4));
        BadBin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end

BadCounter=1;
for age=1:85
    if ~isempty(BadBin{age})
        for j=1:length(BadBin{age})
            ActMinusMetBad{age}(j)=BadBin{age}(j)-age;
            MetabolicSyndromeDiff(BadCounter)=BadBin{age}(j)-age;
            BadCounter=BadCounter+1;
        end
    end
end

% t test
%avgAgeDiff=mean(predictedAgeMean)-mean(CD(:,4));

[hNoMetabolicSyndrome,pNoMetabolicSyndrome] = ttest(NoMetabolicSyndromeDiff,avgAgeDiff,'Tail','right');
[hMetabolicSyndrome,pMetabolicSyndrome] = ttest(MetabolicSyndromeDiff,avgAgeDiff,'Tail','right');

%% Alcoholic test
clear Bin; clear BadBin;
counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,6)==0)
        RoundedAge=round(CD(i,4));
        Bin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end
goodCounter=1;
for age=1:95
    if ~isempty(Bin{age})
        for j=1:length(Bin{age})
            ActMinusMet{age}(j)=Bin{age}(j)-age;
            NotAlcoholicDiff(goodCounter)=Bin{age}(j)-age;
            goodCounter=goodCounter+1;
        end
    end
end

counter=ones(95,1);
for i=1:length(predictedAgeMean)
    if (CD(i,6)==1)
        RoundedAge=round(CD(i,4));
        BadBin{RoundedAge}(counter(RoundedAge))=predictedAgeMean(i);
        counter(RoundedAge)=counter(RoundedAge)+1;
    end
end

BadCounter=1;
for age=1:81
    if ~isempty(BadBin{age})
        for j=1:length(BadBin{age})
            ActMinusMetBad{age}(j)=BadBin{age}(j)-age;
            AlcoholicDiff(BadCounter)=BadBin{age}(j)-age;
            BadCounter=BadCounter+1;
        end
    end
end

% t test

[hNotAlcoholicDiff,pNotAlcoholicDiff] = ttest(NotAlcoholicDiff,avgAgeDiff,'Tail','right');
[hAlcoholicDiff,pAlcoholicDiff] = ttest(AlcoholicDiff,avgAgeDiff,'Tail','right');




%% This splits the data into different metrics (eg smokers vs nonsmokers)
% figure
% plot(CD(CD(:,5)==0,4),predictedAgeMean(CD(:,5)==0),'b.','MarkerSize',1)
% hold on 
% plot(CD(CD(:,5)==1,4),predictedAgeMean(CD(:,5)==1),'r.','MarkerSize',1)
% plot(1:100,1:100)
% 
% xlabel('Actual Age')
% ylabel( 'Predicted KNN mean age')
% legend( 'nonsmoker','smoker','baseline')

%% Predicted Age
figure
scatter(CD(:,4),predictedAgeMean)
hold on
plot(1:95,1:95)
title('K-Nearest Neighbors')
xlabel('Age at CT (years)')
ylabel('Biological Age (years)')
