% This script must be run in the dir of "Assimilation of GRACE & SWAT"
clc;
clear;

lst = dir(strcat(cd, '\Ensemble'));

load lv2;
parcount = max(hrupar);         % The number of partitions.

encount = size(lst,1)-2;        % The number of ensamble members
graceDate = importdata('GRACEdate.dat');    % The string of the time windows of GRACE observations.

% Activate the multi-core computation
matlabpool local 12

%% Perturb initial model states
perturbStd = 0.1;
init_state_path = strcat(cd, '\initial_state_2003001\');
init_state = importdata(strcat(init_state_path, 'swat_state.dat'));
for q = 3:encount+2
    filename = cd;
    filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
    perturb_state = init_state;
    for i = 1:length(perturb_state)
        std = perturbStd * perturb_state(i);
        rnd = randn(1)*std;
        if ~isempty(rnd)
            perturb_state(i) = perturb_state(i) + rnd;
        end
        if perturb_state(i)<0
            perturb_state(i) = 0;
        end
    end
    dlmwrite( strcat(filename, 'swat_state.dat'), ...
        perturb_state, 'delimiter','', 'precision','%30.15f');
    copyfile('swat2009.exe', filename);
end

'Perturbing finished'

% Main route
enpars = cell(parcount,encount);
enpars_a = cell(parcount,encount);

'Run the first 2 months'
runBegin = str2num(graceDate{1}(1:7));
runEnd = str2num(graceDate{2}(9:15))+1;
writeBegin = runBegin;
writeEnd = runEnd-1;
runSwat(lst, runBegin,runEnd, writeBegin,writeEnd);

'Do data assimilation for first 2 months'
% Read state
for q = 3:encount+2
    filename = cd;
    filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
    [pars,mts] = readState2win(graceDate{1},graceDate{2},filename,hrupar);
    for i = 1:parcount
        enpars{i,q-2} = pars{i};
    end
end
% Data assimilation
for i = 1:parcount
    n = length(pars{1});
    xf_e = zeros(n, encount);
    for q = 1:encount
        xf_e(:,q) = enpars{i,q};
    end
    mit = mts{i};
    y = graceData(i, 1:2)';
    R = [obsstd 0; 0 obsstd];
    xf_a = enkf(xf_e, mit, y, R);
    for q = 1:encount
        enpars{i,q} = xf_a;
    end
end

for t = 1:size(graceDate,1)-2
        
    % Read model states of time window T1 and T2
    t1 = graceDate(t+1,1);
    t2 = graceDate(t+2,1);
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
        [subs,mts] = readState2win(t1{1},t2{1},filename);
        for i = 1:subcount
            enpars{i,q-2} = subs{i};
        end
    end
    
    % Data Assimilation
    for i = 1:subcount
        n = size(subs{i},1);
        xf_e = zeros(n, encount);
        for q = 1:encount
            xf_e(:,q) = enpars{i,q};
        end
        mit = mts{i};
        y = graceData(i, t+1:t+2)';
        R = [20 0; 0 20];
        xf_a = enkf(xf_e, mit, y, R);
        correctZeros = (xf_a >= 0);
        xf_a = xf_a .* correctZeros;
        for q = 1:encount
            enpars{i,q} = xf_a;
        end
    end
    
    % Write model states of time window T1 and T2
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
        writeState2win(subs, t1{1}, t2{1}, filename);
    end
    
    strcat(t1{1}, ',' , t2{1}, ' finished.')
end