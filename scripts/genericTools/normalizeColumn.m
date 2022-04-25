function [vNew, vMax, vMin] = normalizeColumn(vec)
vMax = max(vec);
vMin = min(vec);

for i = 1:length(vec)
    vNew(i,1) = (vec(i)-vMin)/(vMax-vMin);
end

end