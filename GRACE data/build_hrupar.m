clc;

load hrusub;
% load r_650km_subpar;
% load r_450km++1_subpar;
% load r_450km++2_subpar;
% load r_375km_subpar;
% load r_325km_subpar;
load r_300km_subpar;

hrupar = zeros(size(hrusub));
for i = 1:length(hrusub)
    sub = hrusub(i);
    index = find(subpar(:,1)==sub);
    hrupar(i) = subpar(index,2);
end