lst = dir('Ensemble');

% number of ensemble members
encount = size(lst,1)-2;

graceDate = importdata('GRACEmisDate.dat');

load lv2;
subcount = max(hrusub);

ensubs = cell(subcount,encount);
ensubmean = cell(subcount,1);

for t = 1:size(graceDate,1)
    strt = graceDate(t,1);
    
    % Read states of this time window
    for q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
        [subs,mts] = readState(strt{1},filename);
        for i = 1:subcount
            ensubs{i,q-2} = subs{i};
        end
    end
    
    % Calculate the mean of these states
    for i = 1:subcount
        ensubmean{i} = zeros(size(ensubs{i,1}),1);
    end
    for q = 1:encount
        for i = 1:subcount
            ensubmean{i} = ensubmean{i} + ensubs{i,q};
        end
    end
    for i = 1:subcount
        ensubmean{i} = ensubmean{i} ./ encount;
    end
    
    % Write the ensemble mean
    filename = cd;
    filename = strcat(filename, '\EnsembleMean\');
    writeState(ensubmean, strt{1}, filename);
end