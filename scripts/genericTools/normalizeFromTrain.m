function [vNew] = normalizeFromTrain(testVec, trainMax, trainMin)
if length(testVec) ~= length(trainMin)
    error('Dimensions wrong')
end

for i = 1:length(testVec)
    vNew(i) = (testVec(i)-trainMin(i))/(trainMax(i)-trainMin(i)); 
end

end