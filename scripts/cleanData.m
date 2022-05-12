%% Clean Data
% This code will clean the provided data into a more useable format.

% IMPORTANT NOTE:
% Add data, saved as a .csv, somewhere in your local repository. DO NOT add 
% this raw data to the git repo as it is PRIVATE.

function [] = cleanData()
close all; clear;
%% Import Data
data = readtable('OppScrData.csv', 'VariableNamingRule', 'preserve');

%% Excel Key
% CLINICAL DATA
% Cols A-C: anonymized Case ID info
% Col D:  Clinical F/U interval  [days from CT] 
% Cols E-J: pt BMI, sex, age (at time 0=CT date), smoking/drinking hx)
% Col K: FRS = Framingham Risk Score (multivariable 10-yr CV risk score)
% Cols L-M: FRAX = Fracture risk assessment score (multivariable 10-yr risk for all & hip fx)
% Col N: Metabolic Syndrome (Y/N/blank=unknown) – really more of an outcome
% 
% CLINICAL OUTCOMES
% Col P: Death
% Cols Q-V: “Cardiovascular events” w/ dates (CVD=stroke, Heart failure, MI=heart attack; any=positive)
% Col W-X: T2 Diabetes (if dx)
% Cols Y-AH: Pathologic/osteoporotic fracture w/ date (any=positive; femoral=hip fx)
% Cols AI-AJ: Alzheimer’s Dx 
% Cols AK-AN: Cancer Dx’s 
% (Col N: Metabolic Syndrome could be considered an outocome)
% 
% CT AI TOOL DATA
% Col AP: Bone measure/BMD (L1 HU)
% Cols AQ-AU: Fat measures (total/visceral/subcutaneous; V/S ratio; all total body X-section)
% Cols AV-AX: Muscle measures (HU/Area/SMI)
% Col AY: Aortic Calcification (Ag)
% Col AZ: Liver fat (HU)

%% Extract IDs
% Note: if you want to access data directly by column number, not by table
% name access with curly brackets, for example: data{3,1}.
ID = data(:,1:3);

%% Column Descriptions
descriptions = [
    "Clinical FU Interval";
    "BMI";
    "BMI>30";
    "Sex";
    "Age at CT";
    "Tobacco";
    "Alcohol Abuse";
    "FRS 10 year risk";
    "FRAX 10y Fx Prob";
    "FRAX 10y Hip Fx Prob";
    "Metabolic Syndrome";
    "Death TF";
    "Death Age [d from CT]";
    "CVD Diagnosis"
    "CVD DX [d from CT]";
    "Heart Failure Diagnosis";
    "Heart failure DX [d from CT]";
    "MI Diagnosis";
    "MI DX [d from CT]";
    "Type 2 Diabetes Diagnosis";
    "Type 2 Diabetes DX [d from CT]";
    "Femoral Neck Fracture Diagnosis";
    "Femoral Neck Fracture DX [d from CT]";
    "Unspec Femoral Fracture Diagnosis";
    "Unspec Femoral Fracture DX [d from CT]";
    "Forearm Fracture Diagnosis";
    "Forearm Fracture DX [d from CT]";
    "Humerus Fracture Diagnosis";
    "Humerus Fracture DX [d from CT]";
    "Pathologic Fracture Diagnosis";
    "Pathologic Fracture DX [d from CT]";
    "Alzheimers Diagnosis";
    "Alzheimers DX [d from CT]";
    "Primary Cancer Diagnosis";
    "Primary Cancer DX [d from CT]";
    "Primary Cancer 2 Diagnosis";
    "Primary Cancer 2 DX [d from CT]";
    "Bone Measure, BMD (L1 HU)";
    "TAT Area (cm2)";
    "Total Body Area EA (cm2)";
    "VAT Area (cm2)";
    "SAT Area (cm2)";
    "VAT/SAT Ratio";
    "Muscle HU";
    "Muscle Area (cm2)";
    "L3 SMI (cm2m2)";
    "AoCa Agaston";
    "Liver HU (Median)"];


%% 1 - Clinical F/U interval 
% Not quite sure how to handle dates?
data_clean(:,1) = data{:,4};

%% 2 - BMI
data_clean(:,end+1) = data{:,5};
% 
idxF = ismember(data{:,7},'Female');
idxM = ismember(data{:,7},'Male');

Female = data{idxF,5};
meanFemale = nanmean(Female);

Male = data{idxM,5};
meanMale = nanmean(Male);

idx = isnan(data{:,5});
for i = 1: length(idx)
if idx(i) == 1 && idxF(i) == 1
    data_clean(i,end) = meanFemale;
elseif idx(i) == 1 && idxM(i) == 1
    data_clean(i,end) = meanMale;
end
end 
clear i
%% 3 - BMI>30, not sure if we should just remove this or if this just provides
% like extra data that emphasizes that the BMI>30 is an important attribute
idx = ismember(data{:,6},'Y');
data_clean(idx,end+1) = 1;
idx = ismember(data{:,6},'N');
data_clean(idx,end) = 0;

Female = data{idxF,6};
[s,~,j]=unique(Female);
meanFemale = s{mode(j)};

Male = data{idxM,6};
[s,~,j]=unique(Male);
meanMale = s{mode(j)};

if meanFemale == 'y'
    meanFemale = 1;
else 
    meanFemale = 0;
end
Male = data{idxM,9};
[s,~,j]=unique(Male);
meanMale = s{mode(j)};
if meanMale == 'y'
    meanMale = 1;
else 
    meanMale = 0;
end

idx = ismember(data{:,6},"");
for i = 1: length(idx)
if idx(i) == 1 && idxF(i) == 1
    data_clean(i,end) = meanFemale;
elseif idx(i) == 1 && idxM(i) == 1
    data_clean(i,end) = meanMale;
end
end
clear i
%% 4 - Sex, male = 0, female = 1
idx = ismember(data{:,7},'Female');
data_clean(idx,end+1) = 1;
idx = ismember(data{:,7},'Male');
data_clean(idx,end) = 0;
idx = ismember(data{:,7},"");
data_clean(idx,end) = NaN;

%% 5 - Age at CT
data_clean(:,end+1) = data{:,8};

%% 6 - Tobacco, No = 0, Yes = 1, Unknown = NaN
idx = ismember(data{:,9},'Yes');
data_clean(idx,end+1) = 1;
idx = ismember(data{:,9},'No');
data_clean(idx,end) = 0;

Female = data{idxF,9};
[s,~,j]=unique(Female);
meanFemale = s{mode(j)};

Male = data{idxM,9};
[s,~,j]=unique(Male);
meanMale = s{mode(j)};

if meanFemale == 'y'
    meanFemale = 1;
else 
    meanFemale = 0;
end
Male = data{idxM,9};
[s,~,j]=unique(Male);
meanMale = s{mode(j)};
if meanMale == 'y'
    meanMale = 1;
else 
    meanMale = 0;
end

idx = ismember(data{:,9},"");
for i = 1: length(idx)
if idx(i) == 1 && idxF(i) == 1
    data_clean(i,end) = meanFemale;
elseif idx(i) == 1 && idxM(i) == 1
    data_clean(i,end) = meanMale;
end
end
clear i
%% 7 - Alcohol Abuse, Abuse issue = 1, no abuse = 0
% For now, any comments are taken as a '1', that the person has an alcohol
% abuse issue. Need to ask if this is what it means. 
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,10},"");
data_clean(idx,end) = 1;

%% 8 - FRS 10-year risk
temp = erase(data{:,11},"%");
temp2 = zeros(length(temp),1);

for i = 1:length(temp)
    if ismember(temp(i),"X") == 1
        temp2(i,1) = NaN;
        
    elseif ismember(temp(i),"<1") == 1 % If risk is less than 1, then set to zero?
        temp2(i,1) = 0; % Maybe this should be something different?
    else
        temp2(i,1) = str2double(cell2mat(temp(i,1)));
    end
end
temp2 = temp2/100;
data_clean(:,end+1) = temp2;

clear temp temp2 i

Female = data_clean(idxF,end);
meanFemale = nanmean(Female);

Male = data_clean(idxM,end);
meanMale = nanmean(Male);

idx = isnan(data_clean(:,end));
for i = 1: length(idx)
if idx(i) == 1 && idxF(i) == 1
    data_clean(i,end) = meanFemale;
elseif idx(i) == 1 && idxM(i) == 1
    data_clean(i,end) = meanMale;
end
end 
clear i
%% 9 - FRAX 10y Fx Prob
data_clean(:,end+1) = data{:,12};

Female = data{idxF,12};
meanFemale = nanmean(Female);

Male = data{idxM,12};
meanMale = nanmean(Male);

idx = isnan(data{:,12});
for i = 1: length(idx)
if idx(i) == 1 && idxF(i) == 1
    data_clean(i,end) = meanFemale;
elseif idx(i) == 1 && idxM(i) == 1
    data_clean(i,end) = meanMale;
end
end 
clear i

%% 10 - FRAX 10y Hip Fx Prob
data_clean(:,end+1) = data{:,13};


Female = data{idxF,13};
meanFemale = nanmean(Female);

Male = data{idxM,13};
meanMale = nanmean(Male);

idx = isnan(data{:,13});
for i = 1: length(idx)
if idx(i) == 1 && idxF(i) == 1
    data_clean(i,end) = meanFemale;
elseif idx(i) == 1 && idxM(i) == 1
    data_clean(i,end) = meanMale;
end
end 
clear i

%% 11 - Metabolic Syndrome (more of an outcome)
idx = ismember(data{:,14},'Y');
data_clean(idx,end+1) = 1;
idx = ismember(data{:,14},'N');
data_clean(idx,end) = 0;

Female = data{idxF,9};
[s,~,j]=unique(Female);
meanFemale = s{mode(j)};
if meanFemale == 'y'
    meanFemale = 1;
else 
    meanFemale = 0;
end
Male = data{idxM,9};
[s,~,j]=unique(Male);
meanMale = s{mode(j)};
if meanMale == 'y'
    meanMale = 1;
else 
    meanMale = 0;
end

idx = ismember(data{:,14},""); % Unknown is NaN for now=
if idx == idxM
    data_clean(idx,end) = meanFemale;
elseif idx == idxF
    data_clean(idx,end) = meanMale;
end


%% 12 - Death T/F
% If death is on record = 1, else = 0
% This may be a little redundant with column 13, may need to remove?
data_clean(:,end+1) = ~isnan(data{:,16});

%% 13 - Death Age [d from CT]
data_clean(:,end+1) = data{:,16};
idx = isnan(data{:,16});
data_clean(idx,end) = 0;

%% 14 - CVD Diagnosis
% For now, any comments are taken as a '1', that the person has had a CVD
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,17},"");
data_clean(idx,end) = 1;

%% 15 - CVD DX [d from CT]
data_clean(:,end+1) = data{:,18};
idx = isnan(data{:,18});
data_clean(idx,end) = 0;

%% 16 - Heart Failure Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,19},"");
data_clean(idx,end) = 1;

%% 17 - Heart failure DX [d from CT]
data_clean(:,end+1) = data{:,20};
idx = isnan(data{:,20});
data_clean(idx,end) = 0;

%% 18 - MI Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,21},"");
data_clean(idx,end) = 1;

%% 19 - MI DX [d from CT]
data_clean(:,end+1) = data{:,22};
idx = isnan(data{:,22});
data_clean(idx,end) = 0;

%% 20 - Type 2 Diabetes Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,23},"");
data_clean(idx,end) = 1;

%% 21 - Type 2 Diabetes DX [d from CT]
data_clean(:,end+1) = data{:,24};
idx = isnan(data{:,24});
data_clean(idx,end) = 0;

%% 22 - Femoral Neck Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,25},"");
data_clean(idx,end) = 1;

%% 23 - Femoral Neck Fracture DX [d from CT]
data_clean(:,end+1) = data{:,26};
idx = isnan(data{:,26});
data_clean(idx,end) = 0;

%% 24 - Unspec Femoral Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,27},"");
data_clean(idx,end) = 1;

%% 25 - Unspec Femoral Fracture DX [d from CT]
data_clean(:,end+1) = data{:,28};
idx = isnan(data{:,28});
data_clean(idx,end) = 0;

%% 26 - Forearm Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,29},"");
data_clean(idx,end) = 1;

%% 27 - Forearm Fracture DX [d from CT]
data_clean(:,end+1) = data{:,30};
idx = isnan(data{:,30});
data_clean(idx,end) = 0;

%% 28 - Humerus Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,31},"");
data_clean(idx,end) = 1;

%% 29 - Humerus Fracture DX [d from CT]
data_clean(:,end+1) = data{:,32};
idx = isnan(data{:,32});
data_clean(idx,end) = 0;

%% 30 - Pathologic Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,33},"");
data_clean(idx,end) = 1;

%% 31 - Pathologic Fracture DX [d from CT]
data_clean(:,end+1) = data{:,34};
idx = isnan(data{:,34});
data_clean(idx,end) = 0;

%% 32 - Alzheimers Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,35},"");
data_clean(idx,end) = 1;

%% 33 - Alzheimers DX [d from CT]
data_clean(:,end+1) = data{:,36};
idx = isnan(data{:,36});
data_clean(idx,end) = 0;

%% 34 - Primary Cancer Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,37},"");
data_clean(idx,end) = 1;

%% 35 - Primary Cancer DX [d from CT]
data_clean(:,end+1) = data{:,38};
idx = isnan(data{:,38});
data_clean(idx,end) = 0;

%% 36 - Primary Cancer 2 Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
data_clean(idx,end+1) = 0;
idx = ~ismember(data{:,39},"");
data_clean(idx,end) = 1;

%% 37 - Primary Cancer 2 DX [d from CT]
data_clean(:,end+1) = data{:,40};
idx = isnan(data{:,40});
data_clean(idx,end) = 0;

%% 38 - Bone Measure, BMD (L1 HU)
data_clean(:,end+1) = data{:,42};


%% 39 - TAT Area (cm2)
data_clean(:,end+1) = data{:,43};

%% 40 - Total Body Area EA (cm2)
data_clean(:,end+1) = data{:,44};

%% 41 - VAT Area (cm2)
data_clean(:,end+1) = data{:,45};

%% 42 - SAT Area (cm2)
data_clean(:,end+1) = data{:,46};

%% 43 - VAT/SAT Ratio
data_clean(:,end+1) = data{:,47};

%% 44 - Muscle HU
data_clean(:,end+1) = data{:,48};

%% 45 - Muscle Area (cm2)
data_clean(:,end+1) = data{:,49};

%% 46 - L3 SMI (cm2/m2)
data_clean(:,end+1) = data{:,50};

%% 47 - AoCa Agaston
data_clean(:,end+1) = data{:,51};

%% 48 - Liver HU (Median)
data_clean(:,end+1) = data{:,52};

%% Remove all participants that have NaN in their CT data
CT = data_clean(:,38:48);
numNaN = sum(isnan(CT),2);
idx_NaN = numNaN>0;
data_clean(idx_NaN,:) = [];

ID_clean = ID(~idx_NaN,:);



%% Seperate array into types
% Clinical Data
CD = data_clean(:,2:12);
CD_desc = descriptions(2:12);

% Clinical Outcomes
% Metabolic syndrome included in clinical data and outcomes.
% Removes dates as well
cols = [12,14,16,18,20,22,24,26,28,30,32,34,36];
CO = data_clean(:,cols);
CO_desc = descriptions(cols);

% Computerized Tomography Data
CT = data_clean(:,38:48);
CT_desc = descriptions(38:48);

%% Index by Sex
idx_male = CD(:,3)==0;
idx_female = CD(:,3)==1;

%% Clean up variables
clear idx numNaN cols

%% Save mat file

save('dataCleaned.mat')

end





