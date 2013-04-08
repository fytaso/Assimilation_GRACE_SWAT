lst = dir('Ensemble');

% number of ensemble members
encount = size(lst,1)-2;

graceDate = importdata('GRACEDate.dat');

% load r_450km;
parcount = max(hrupar);

for t = 1:size(graceDate,1)
    strt = graceDate(t,1);
    
    % Read states of this time window
    dstart = str2num(strt{1}(1:7));
    dend = str2num(strt{1}(9:15));
    for d = dstart:dend
        fprintf('Calculating the ensemble mean of %d.\n', d);
        date_state = [];
        isExist = false;
        for q = 3:encount+2
            filename = cd;
            filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\', num2str(d), '.dat');
            if exist(filename, 'file')
                if isempty(date_state)
                    date_state = importdata(filename);
                else
                    date_state = date_state + importdata(filename);
                end
                isExist = true;
            end
        end
        if isExist
           date_state = date_state / encount; 
           filename = cd;
           filename = strcat(filename, '\EnsembleMean\', num2str(d), '.dat');
           dlmwrite(filename, date_state, 'delimiter','', 'precision','%20.4f');
        end
    end
end

% rerun the model
runBegin = str2num(graceDate{1}(1:7));
runEnd = str2num(graceDate{end}(9:15));
writeBegin = runBegin;
writeEnd = runEnd;
readBegin = runBegin;
readEnd = runEnd;
initDir = cd;
filename = strcat(initDir, '\EnsembleMean\');
setDateCtrl(filename, runBegin,runEnd, [], [], [], []);
cd(filename);
system('swat2009.exe');
cd(initDir);