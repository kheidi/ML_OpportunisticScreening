function [predictedAgeMean, predictedAgeMode] = nearestneighbors_cleandata_v2(dataset, newdata, ages, howManyNeighbors, neighbors)
%This finds the nearest neighbor

[NumOfPeople, features]=size(dataset);
[newpeople, features]=size(newdata);

for j=1:newpeople %this finds the difference for a person
    for i=1:NumOfPeople %this compares that person to the rest of the people
        dist(i)=norm(dataset(i,:)-newdata(j,:),1); %the first row has the distances for that person, each column is compared to that person
    end
    NN_index=zeros(howManyNeighbors,1);
    top=max(dist);
    %this finds the closest neighbor and then replaces it with a higher
    %value so it doesn't pick it again
    for k=1:howManyNeighbors
        [M,I] = min(dist);
        NN_index(k)=I;
        dist(I)=top+1;
    end

    %this gives use the biological age using the average ages of the closest
    %N neighbors
    predictedAgeMean(j)=mean(ages(NN_index));
    predictedAgeMode(j)=mode(ages(NN_index));
    clear NN_index;

end

end
