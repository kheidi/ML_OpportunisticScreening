function [predictedAgeMean, predictedAgeMode] = nearestneighbors_project(dataset, howManyNeighbors, neighbors)
%This finds the nearest neighbor

[NumOfPeople, features]=size(dataset);

for i=1:NumOfPeople %this finds the difference for 1 person
    for j=1:NumOfPeople %this compares that 1 person to the rest of the people
        dist(j)=norm(dataset(i,42:52)-dataset(j,42:52),2); %the first row has the distances for that person, each column is compared to that 1 person
        %dist(i)=norm(newvector-Xdataset(:,i),2);
    end
    NN_index=zeros(howManyNeighbors,1);
    top=max(dist);
    for k=1:howManyNeighbors
        [M,I] = min(dist);
        NN_index(k)=I;
        dist(I)=top+1;
    end

    %neighbors=dataset(:,NN_index);

    predictedAgeMean(i)=mean(dataset(NN_index,8));
    predictedAgeMode(i)=mode(dataset(NN_index,8));
    clear NN_index;
end

% NN_index=zeros(howManyNeighbors,1);
% top=max(dist);
% for j=1:howManyNeighbors
%     [M,I] = min(dist);
%     NN_index(j)=I;
%     dist(I)=top+1;
% end
%
% neighbors=dataset(:,NN_index);

%Ydataset(NN_index);
% predictedAgeMean=mean(actualAges(NN_index));
% predictedAgeMode=mode(actualAges(NN_index));

end
