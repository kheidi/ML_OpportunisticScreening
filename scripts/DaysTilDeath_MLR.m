%% Age they will die

%% Load Data
clear;close all;clc;
load('dataCleaned.mat');

%% Gathering the patients that have died - Training Data
indx_dead = CO(:,1)==1;
TrainAge = (floor(CO(indx_dead,2)/365)) + CD(indx_dead,5); 
TrainCT = CT(indx_dead,:);

indx_alive = CO(:,1)==0;
TestCT = CT(indx_alive,:);

% Linear Fit: How does our data behaves
for i = 1:width(TrainCT)
    figure;
    Stats{i} = fitlm(TrainAge, TrainCT(:,i));
    plot(Stats{i})
    title("Age vs. "+CT_desc(i))
    ylabel(CT_desc(i))
    xlabel("Age")

    Rsquared = Stats{i}.Rsquared;
end


predictors=[ones(size(TrainCT)) TrainCT];
%This will create a regression model of type:
% Pre=b0+(b1*TrainCT(:,1))+(b2*TrainCT(:,2))+(b3*TrainCT(:,3))+...+(b11*TrainCT(:,11))
% it also gives stats and residuals   
[b,bint,r,rint,MLR_stats] = regress(TrainAge,predictors);




%b=mvregress(TrainCT, TrainAge)

%% Multiple Linear Regression Code found online. 

% X = [TrainCT ones(length(TrainCT),1)];
% Y = TrainAge;
% B = inv(X'*X)*X'*Y;
% Yhat = X*B;
% Res  = Y - Yhat;
% 
% SStotal = norm(Y - mean(Y)).^2;
% SSeffect = norm(Yhat - mean(Yhat)).^2;
% SSerror  = norm(Res-mean(Res)).^2;
% 
% df      = rank(X)-1;
% dferror = length(Y) - df - 1;
% R2      = SSeffect / SStotal;
% F       = (SSeffect / df) / (SSerror / dferror);
% p       = 1 - fcdf(F,df,dferror);
% 
% % make a figure
% figure('Name','Multiple Regression');
% subplot(1,2,1); plot(Y,'x','LineWidth',5);  hold on
% plot(Yhat,'r','LineWidth',2); grid on;
% title(['R^2 ' num2str(R2) ' Data and model F=' num2str(F) ' p=' num2str(p)],'FontSize',14)
% subplot(1,2,2); normplot(Res);
% 
% 
% % ------------------------------------
% % semi-partial correlation coefficient
% % ------------------------------------
% % let's think of the model and what it means it terms of geometry.
% % the data Y can be described as a vector and a point in R_20
% % a space with 20 dimensions. We then establish a model X with 5
% % regressors; that is we look for a combination of these 5 vectors which
% % will get as close as possible to Y. To find the actual contribution of x1
% % to the data for this model one needs to look at how much x1 explains
% % to the total variance, ie we want to compare the R2 between the full and
% % a reduced model without x1 - the difference will be how much x1 explains in Y.
% 
% Xreduced    = X(:,2:end); % reduced model all minus 1st regressor
% Breduced    = inv(Xreduced'*Xreduced)*Xreduced'*Y;
% Yhatreduced = Xreduced*Breduced;
% Resreduced  = Y - Yhatreduced;
% 
% dfreduced       = rank(Xreduced) -1 ;
% dferrorreduced = length(Y) - dfreduced - 1;
% SSeffectreduced = norm(Yhatreduced-mean(Yhatreduced)).^2;
% SSerrorreduced  = norm(Resreduced-mean(Resreduced)).^2;
% R2reduced       = SSeffectreduced / SStotal;
% Freduced       = (SSeffectreduced / dfreduced) / (SSerrorreduced / dferrorreduced);
% preduced       = 1 - fcdf(Freduced,dfreduced,dferrorreduced);
% 
% Semi_Partial_corr_coef = R2 - R2reduced;
% dfe_semi_partial_coef  = df - dfreduced;
% F_semi_partail_coef    = (Semi_Partial_corr_coef*dferror) / ...  % variance explained by x1
%                          ((1-R2)*dfe_semi_partial_coef); % unexplained variance overall
% p_semi_partial_coef    = 1 - fcdf(Semi_Partial_corr_coef, df, dfe_semi_partial_coef); % note df is from the full model
% 
% % make a figure
% figure('Name','Multiple Regression - Full versus reduced model');
% subplot(2,2,1); plot(Y,'x','LineWidth',5);  hold on
% plot(Yhat,'r','LineWidth',2); grid on;
% title(['Data and model F=' num2str(F) ' p=' num2str(p)])
% subplot(2,2,2); plot(Y,'x','LineWidth',5);  hold on
% plot(Yhatreduced,'r','LineWidth',2); grid on;
% title(['Data and reduced model F=' num2str(Freduced) ' p=' num2str(preduced)])
% subplot(2,2,3); plot(Yhat,'b','LineWidth',2); grid on; hold on
% plot(Yhatreduced,'r','LineWidth',2);
% title('Modelled data for both models')
% subplot(2,2,4); plot((Res-Resreduced).^2,'k','LineWidth',2); grid on; hold on
% title('Difference of residuals squared')
% 
% 
% % --------------------------------
% % partial correlation coefficient
% % --------------------------------
% % As we shall see below, this is easily obtained using projections - but
% % for now let just think about what we want to measure. We are interested
% % in knowing the correlation between y and x1 controlling for the effect of
% % the other xs, that is removing the effect of other xs. Compred to
% % semi-parital coef we also want to remove the effect of xs on y or if you
% % prefer we want to compute how much of x1 we need to get to the point
% % defined by the xs which is the closest to Y
% 
% % above we removed X(:,2:end) from Y and got Resreduced
% % we need to do the same for x1 so that we can correlate x1 and y witout xs
% x = X(:,1);
% B = inv(Xreduced'*Xreduced)*Xreduced'*x;
% xhat = Xreduced*B;
% Resx = x - xhat;
% 
% % the correlation between Resreduced and Resx is the partial coef
% Partial_coef = corr(Resx,Resreduced);
% 
% % --------------------------------------------------


%% Trying linear regression, just one variable: 
% just to understand the general idea, not useful for our case

% y = TrainAge;
% x = TrainCT(:,1);
% b0 = 0;
% b1 = x\y;
% 
% yCalc1 = b0+b1*x; %my linear regression model assuming slope goes to zero (b0=0)
% 
% scatter(y,x)
% hold on;
% plot(yCalc1,x)
% ylabel(""+CT_desc(1))
% xlabel("Age of death")
% grid on
% 
% % how to determine b0: 
% X = [ones(length(x),1) x];
% b = X\y;
% yCalc2 = X*b; %my linear model with a calculated slope - more accurate, better fit. 
% plot(yCalc2,x)
% ylabel(""+CT_desc(1))
% xlabel("Age of death")
% grid on
% 
% mdl1 = fitlm(y,yCalc1)
% mdl2 = fitlm(y,yCalc2)
% 
% % Compute R2 (Coefficient of determination): 
% R2_y1 = 1-sum((y -yCalc1).^2)/sum((y-mean(y)).^2)
% R2_y2 = 1-sum((y -yCalc2).^2)/sum((y-mean(y)).^2) %More accurate, not great eitherway (15% fit)
% Rsq_1 = (corr(y,yCalc1))^2
% Rsq_2 = (corr(y,yCalc2))^2


%%  Verify collinearity: Not sure what this is used for...
% CT_AgeDied = [TrainCT, TrainAge];
% [R,p_values]=corrplot(CT_AgeDied);


% %Trying something weird...
% x = [CT_AgeCT(:,2), CT_AgeCT(:,3), CT_AgeCT(:,4), CT_AgeCT(:,8), CT_AgeCT(:,9)];
% y = CT_AgeCT(:,12);
% mdl = fitlm(x,y)
%  
% %ignoring x5
% x1 = [CT_AgeCT(:,2), CT_AgeCT(:,3), CT_AgeCT(:,4), CT_AgeCT(:,8)];
% mdl1 = fitlm(x1,y)


