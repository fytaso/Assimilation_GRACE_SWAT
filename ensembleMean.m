lst = dir('Ensemble');

% number of ensemble members
encount = size(lst,1)-2;

graceDate = importdata('GRACEDate.dat');

load r_450km;
parcount = max(hrupar);

enpars = cell(parcount,encount);
enparmean = cell(parcount,1);

for t = 1:size(graceDate,1)
    strt = graceDate(t,1);
    
    % Read states of this time window
    fprintf('Calculating the ensemble mean of time-window: %s.\n', strt{1});
    fprintf('Reading the ensemble: ');
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
        fprintf('%dth ', q-2);
        [pars,mts] = readState(strt{1},filename,hrupar);
        for i = 1:parcount
            enpars{i,q-2} = pars{i};
        end
    end
    fprintf('Reading finished.');
    
    % Calculate the mean of these states
    for i = 1:parcount
        enparmean{i} = zeros(size(enpars{i,1}),1);
    end
    for q = 1:encount
        for i = 1:parcount
            enparmean{i} = enparmean{i} + enpars{i,q};
        end
    end
    for i = 1:parcount
        enparmean{i} = enparmean{i} ./ encount;
    end
    
    % Write the ensemble mean
    fprintf('Writing ensemble mean...\n');
    filename = cd;
    filename = strcat(filename, '\EnsembleMean\');
    writeState(enparmean, strt{1}, filename, hrupar);
end

% rerun the model
runBegin = str2num(graceDate{1}(1:7));
runEnd = str2num(graceDate{end}(9:15));
writeBegin = runBegin;
writeEnd = runEnd;
readBegin = runBegin;
readEnd = runEnd;
initDir = cd;
filename = strcat(initDir, '\Ensemble\', lst(q).name);
setDateCtrl(filename, runBegin,runEnd, writeBegin,writeEnd, readBegin,readEnd);
cd(filename);
system('swat2009.exe');
cd(initDir);