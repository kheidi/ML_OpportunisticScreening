function [XNew, maxes, mins] = normalizeMatByCols(X)

for i = 1:width(X)
    [XNew(:,i), maxes(i), mins(i)] = normalizeColumn(X(:,i));
end

end