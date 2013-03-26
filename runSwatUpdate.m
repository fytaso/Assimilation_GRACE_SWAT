function runSwatUpdate( lst, runBegin, runEnd, writeBegin, writeEnd, readBegin, readEnd )
%RUNSWATUPDATE Summary of this function goes here
%   Detailed explanation goes here

    encount = size(lst,1)-2;
    
    initDir = cd;
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble', lst(q,:));
        setDateCtrl(filename, runBegin,runEnd, writeBegin,writeEnd, readBegin,readEnd);
        cd(filename);
        if q==encount+2
            cd(filename);
            system('swat2009.exe');
        else
            system('swat2009.exe &');
        end
        cd(initDir);
    end
end

