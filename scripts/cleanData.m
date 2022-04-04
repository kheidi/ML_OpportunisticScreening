%% Clean Data
% This code will clean the provided data into a more useable format.

% IMPORTANT NOTE:
% Add data, saved as a .csv, somewhere in your local repository. DO NOT add 
% this raw data to the git repo as it is PRIVATE.

%% Import Data
clear;
close all;
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
colDescriptions = [
    "Clinical F/U Interval";
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
    "Death T/F";
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
    "L3 SMI (cm2/m2)";
    "AoCa Agaston";
    "Liver HU (Median)"].';

%% 1 - Clinical F/U interval 
% Not quite sure how to handle dates?
X(:,1) = data{:,4};

%% 2 - BMI
X(:,end+1) = data{:,5};

%% 3 - BMI>30, not sure if we should just remove this or if this just provides
% like extra data that emphasizes that the BMI>30 is an important attribute
idx = ismember(data{:,6},'Y');
X(idx,end+1) = 1;
idx = ismember(data{:,6},'N');
X(idx,end) = 0;
idx = ismember(data{:,6},""); % Some are left blank so I left as NaN for now
X(idx,end) = NaN;

%% 4 - Sex, male = 0, female = 1
idx = ismember(data{:,7},'Female');
X(idx,end+1) = 1;
idx = ismember(data{:,7},'Male');
X(idx,end) = 0;
idx = ismember(data{:,7},"");
X(idx,end) = NaN;

%% 5 - Age at CT
X(:,end+1) = data{:,8};

%% 6 - Tobacco, No = 0, Yes = 1, Unknown = NaN
idx = ismember(data{:,9},'Yes');
X(idx,end+1) = 1;
idx = ismember(data{:,9},'No');
X(idx,end) = 0;
idx = ismember(data{:,9},"");
X(idx,end) = NaN;

%% 7 - Alcohol Abuse, Abuse issue = 1, no abuse = 0
% For now, any comments are taken as a '1', that the person has an alcohol
% abuse issue. Need to ask if this is what it means. 
X(idx,end+1) = 0;
idx = ~ismember(data{:,10},"");
X(idx,end) = 1;

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
X(:,end+1) = temp2;

%% 9 - FRAX 10y Fx Prob
X(:,end+1) = data{:,12};

%% 10 - FRAX 10y Hip Fx Prob
X(:,end+1) = data{:,13};

%% 11 - Metabolic Syndrome (more of an outcome)
idx = ismember(data{:,14},'Y');
X(idx,end+1) = 1;
idx = ismember(data{:,14},'N');
X(idx,end) = 0;
idx = ismember(data{:,14},""); % Unknown is NaN for now
X(idx,end) = NaN;

%% 12 - Death T/F
% If death is on record = 1, else = 0
% This may be a little redundant with column 13, may need to remove?
X(:,end+1) = ~isnan(data{:,16});

%% 13 - Death Age [d from CT]
X(:,end+1) = data{:,16};

%% 14 - CVD Diagnosis
% For now, any comments are taken as a '1', that the person has had a CVD
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,17},"");
X(idx,end) = 1;

%% 15 - CVD DX [d from CT]
X(:,end+1) = data{:,18};

%% 16 - Heart Failure Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,19},"");
X(idx,end) = 1;

%% 17 - Heart failure DX [d from CT]
X(:,end+1) = data{:,20};

%% 18 - MI Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,21},"");
X(idx,end) = 1;

%% 19 - MI DX [d from CT]
X(:,end+1) = data{:,22};

%% 20 - Type 2 Diabetes Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,23},"");
X(idx,end) = 1;

%% 21 - Type 2 Diabetes DX [d from CT]
X(:,end+1) = data{:,24};

%% 22 - Femoral Neck Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,25},"");
X(idx,end) = 1;

%% 23 - Femoral Neck Fracture DX [d from CT]
X(:,end+1) = data{:,26};

%% 24 - Unspec Femoral Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,27},"");
X(idx,end) = 1;

%% 25 - Unspec Femoral Fracture DX [d from CT]
X(:,end+1) = data{:,28};

%% 26 - Forearm Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,29},"");
X(idx,end) = 1;

%% 27 - Forearm Fracture DX [d from CT]
X(:,end+1) = data{:,30};

%% 28 - Humerus Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,31},"");
X(idx,end) = 1;

%% 29 - Humerus Fracture DX [d from CT]
X(:,end+1) = data{:,32};

%% 30 - Pathologic Fracture Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,33},"");
X(idx,end) = 1;

%% 31 - Pathologic Fracture DX [d from CT]
X(:,end+1) = data{:,34};

%% 32 - Alzheimers Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,35},"");
X(idx,end) = 1;

%% 33 - Alzheimers DX [d from CT]
X(:,end+1) = data{:,36};

%% 34 - Primary Cancer Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,37},"");
X(idx,end) = 1;

%% 35 - Primary Cancer DX [d from CT]
X(:,end+1) = data{:,38};

%% 36 - Primary Cancer 2 Diagnosis
% For now, any comments are taken as a '1', that the person has had a 
% diagnosis.
X(idx,end+1) = 0;
idx = ~ismember(data{:,39},"");
X(idx,end) = 1;

%% 37 - Primary Cancer 2 DX [d from CT]
X(:,end+1) = data{:,40};

%% 38 - Bone Measure, BMD (L1 HU)
X(:,end+1) = data{:,42};

%% 39 - TAT Area (cm2)
X(:,end+1) = data{:,43};

%% 40 - Total Body Area EA (cm2)
X(:,end+1) = data{:,44};

%% 41 - VAT Area (cm2)
X(:,end+1) = data{:,45};

%% 42 - SAT Area (cm2)
X(:,end+1) = data{:,46};

%% 43 - VAT/SAT Ratio
X(:,end+1) = data{:,47};

%% 44 - Muscle HU
X(:,end+1) = data{:,48};

%% 45 - Muscle Area (cm2)
X(:,end+1) = data{:,49};

%% 46 - L3 SMI (cm2/m2)
X(:,end+1) = data{:,50};

%% 47 - AoCa Agaston
X(:,end+1) = data{:,51};

%% 48 - Liver HU (Median)
X(:,end+1) = data{:,52};










