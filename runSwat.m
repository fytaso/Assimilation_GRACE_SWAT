function runSwat( lst, runBegin, runEnd, writeBegin, writeEnd )
%RUNSWAT Summary of this function goes here
%   Detailed explanation goes here

    encount = size(lst,1)-2;
    
    initDir = cd;
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q).name);
        setDateCtrl(filename, runBegin,runEnd, writeBegin,writeEnd, [],[]);
        cd(filename);
        if q==encount+2
            cd(filename);
            system('swat2009.exe');
        else
            winopen('swat2009.exe');
        end
        cd(initDir);
    end
end