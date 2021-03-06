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

    %% The parameters
    encount = size(lst,1)-2;    % number of ensemble members
    parcount = max(hrupar);     % number of partition
    enpars = cell(parcount, encount);   % The state of the model
    enpars_a = cell(parcount, encount); % The delta of the state
    enmts = cell(parcount, encount); % The observation operator
    runBegin = str2num(obsT(1:7));
    runEnd = str2num(obsT(9:15))+1;
    writeBegin = runBegin;
    writeEnd = runEnd-1;
    daycount = runEnd - runBegin + 1;   % The number of days of the time window

    %% Initial run
    fprintf('Backup the initial state of the model...\n');
    init_state_backup(lst);
    fprintf('Execute the initial run of the model...\n');
    runSwat(lst, runBegin,runEnd, writeBegin,writeEnd);
    
    %% Read the state of this time window
    fprintf('Reading the state of this time window...\n'); 
    tic
    parfor q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
        fprintf('Reading the %dth ensemble.\n', q-2);
        [pars, mts] = readState(obsT, filename, hrupar);
        for i = 1:parcount
            enpars{i,q-2} = pars{i};
            enmts{i,q-2} = mts{i};
        end
    end
    toc
    
    %% Data assimilation
    fprintf('Starting the assimilation...\n');
    for i = 1:parcount
        fprintf('Assimilating the %dth partition (totally %d partitions)...\n',i,parcount);
        n = length(enpars{i,1});
        xf_e = zeros(n, encount);
        for q = 1:encount
            xf_e(:,q) = enpars{i,q};
        end
        mit = enmts{i,q};
        y = graceData(i)';
        R = obsstd;
        xf_a = enkf(xf_e, mit, y, R);
        for q = 1:encount
            % Calculate the mean Kalman gain of every day in the time window
            enpars_a{i,q} = (xf_a(:,q) - xf_e(:,q)) ./ daycount; 
            % Record the new state after Kalman filter
            enpars{i,q} = xf_a(:,q);
        end
    end
    % Write the model states of the time window
    fprintf('Writing the model states of the time window.\n');
    tic
    parfor q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name, '\');
        fprintf('Writing the %dth ensemble.\n', q-2);
        writeState(enpars_a(:,q-2), obsT, filename, hrupar);
    end
    toc
    
    %% Rerun the model, and add in Kalman gains
    fprintf('Retrieve the initial state of the model...\n');
    init_state_retrieve(lst);
    fprintf('Rerun the model, and add in Kalman gains...\n');
    readBegin = writeBegin;
    readEnd = writeEnd;
    runSwatUpdate(lst, runBegin,runEnd, writeBegin,writeEnd, readBegin,readEnd);
    
end