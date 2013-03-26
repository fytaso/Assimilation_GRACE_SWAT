% clc;
% clear;

strt = '2003001-2003031';
filePath = strcat(cd, '\Open Loop\');

load lv2;
load hrusub;
load hruarea;
load subhrucount;
load subarea;

hrucount = size(hrusub,1);
subcount = max(hrusub);
parcount = max(hrupar);

ystart = str2double(strt(1:4));
dstart = str2double(strt(5:7));
yend = str2double(strt(9:12));
dend = str2double(strt(13:15));

% tcount = (yend-ystart+1)*365;
tcount = dend - dstart + 1;
subtws = zeros(subcount, tcount);
hrutws = zeros(hrucount, tcount);
partws = zeros(parcount, tcount);

pararea = zeros(parcount,1);

% Read the configuration file
filename = strcat(filePath, 'configuration.dat');
config = importdata(filename);
mhru = config(1);
mlyr = config(2);
mch = config(3);
msub = config(4);

for j = 1:hrucount
    pararea(hrupar(j)) = pararea(hrupar(j)) + hruarea(j);
end

% Read the HRU states of every day in the time window
for y = ystart:yend    
    for d = dstart:dend
        t = (y-ystart)*365 + d;
        filename = strcat(filePath, ...
            num2str(y,'%04g'), num2str(d,'%03g'), '.dat');
        data = importdata(filename);
        ind = 1;
        for j = 1:hrucount
            hrutws(j,t) = hrutws(j,t) + data(ind);   % surf_bs(1,j)
            hrutws(j,t) = hrutws(j,t) + data(ind+1); % bss(1,j)
            hrutws(j,t) = hrutws(j,t) + data(ind+2); % shallst(j)
            hrutws(j,t) = hrutws(j,t) + data(ind+3); % deepst(j)
            hrutws(j,t) = hrutws(j,t) + data(ind+4); % canstor(j)
            for k = 1:mlyr
                hrutws(j,t) = hrutws(j,t) + data(ind+4+k); % sol_st(k,j)
            end
            hrutws(j,t) = hrutws(j,t);
            ind = ind + 5 + mlyr;
        end
        for j = 1:hrucount
            subtws(hrusub(j),t) = subtws(hrusub(j),t) + hrutws(j,t) * hruarea(j);
            partws(hrupar(j),t) = partws(hrupar(j),t) + hrutws(j,t) * hruarea(j);
        end
        subtws(:,t) = subtws(:,t) ./ subarea;
        partws(:,t) = partws(:,t) ./ pararea;
    end
end