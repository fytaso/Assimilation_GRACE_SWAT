function assimInOneWin( lst, obsT, hrupar, graceData, obsstd )
%ASSIMINWIN Process data assimilation in one time window (one month)
%
%   assimInOneWin( lst, obsT, hrupar, graceData, obsstd )
%
%   lst -- The list of folders of ensembles.
%   obsT -- The string of time window, e.g. "2003001-2003031".
%   hrupar -- The corresponding table between HRU and partition. 
%             "hrupar(i)=j" means the i-th hru belongs to the j-th partition.
%   graceData -- The GRACE observation data of the time window. It is a
%                vector whose length is the number of partition.
%   obsstd -- The standard derivation of the GRACE observation.
    
    %% Initial run
    runBegin = str2num(obsT(1:7));
    runEnd = str2num(obsT(9:15))+1;
    writeBegin = runBegin;
    writeEnd = runEnd-1;
    runSwat(lst, runBegin,runEnd, writeBegin,writeEnd);
    
    %% Data assimilation
    encount = size(lst,1)-2;    % number of ensemble members
    parcount = max(hrupar);     % number of partition
    enpars = cell(parcount, encount);
    enpars_a = cell(parcount, encount);
    % Read the state of this time window
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
        [pars, mts] = readState(strt, filename, hrupar);
        for i = 1:parcount
            enpars{i,q-2} = pars{i};
        end
    end
    % Data assimilation
    for i = 1:parcount
        n = length(pars{i});
        xf_e = zeros(n, encount);
        for q = 1:encount
            xf_e(:,q) = enpars{i,q};
        end
        mit = mts{i};
        y = graceData(i)';
        R = obsstd;
        xf_a = enkf(xf_e, mit, y, R);
        for q = 1:encount
            enpars{i,q} = xf_a;
        end
    end
    % Write the model states of the time window
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name, '\');
        
    end
    
    %% Rerun the model, and add in Kalman gains
    readBegin = writeBegin;
    readEnd = writeEnd;
    runSwatUpdate(lst, runBegin,runEnd, writeBegin,writeEnd, readBegin,readEnd);
    
end