function runSwatUpdate( lst, runBegin, runEnd, writeBegin, writeEnd, readBegin, readEnd )
%RUNSWATUPDATE Summary of this function goes here
%   Detailed explanation goes here

    encount = size(lst,1)-2;
    
    initDir = cd;
    for q = 3:encount + 2
        filename = strcat(initDir, '\Ensemble\', lst(q).name);
        fprintf('Set up the date control of the %dth ensemble...\n', q-2);
        setDateCtrl(filename, runBegin,runEnd, writeBegin,writeEnd, readBegin, readEnd);
    end
    for q = 3:encount+1
        filename = strcat(initDir, '\Ensemble\', lst(q).name);
%         setDateCtrl(filename, runBegin,runEnd, writeBegin,writeEnd, readBegin,readEnd);
        winopen(strcat(filename, '\swat2009.exe'));
    end

    filename = strcat(initDir, '\Ensemble\', lst(encount+2).name);
    cd(filename);
    system('swat2009.exe');
    cd(initDir);
end