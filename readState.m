function [ pars, mts ] = readState( strt, filePath, hrupar )
%READSTATE Read the model state of the sub-basins, in the obs window of
%strt. Return the corresponding observation matrix if necessary.
% INPUT
%   strt        - The string of the time window
%   filePath    - The path of the folder
%   hrupar      - The correspondence between HRU and partition, e.g.
%                 "hrupar(i)=j" means the i-th HRU belongs to the j-th
%                 partition
%
% OUTPUT
%   pars        - The matrix of model states of the partition
%   mts         - The observation operator

    %% Load the necessary variables
    load hruarea;
    
    mvar = 4; % The number of variables except soil moistures.
    
    parcount = max(hrupar);         % The number of partitions.
    pararea = zeros(parcount,1);    % The area of each partition.
    
    config = importdata(strcat(filePath, 'configuration.dat'));
    mhru = config(1);   % The number of HRUs.
    mlyr = config(2);   % The number of soil layers.
    mch = config(3);    % The number of reaches.
    msub = config(4);   % The number of subasin.
    
    pars = cell(parcount,1);    % The matrix of model states of the partition
    mts = cell(parcount,1);     % The observation operator
    
    ystart = str2double(strt(1:4));
    dstart = str2double(strt(5:7));
    yend = str2double(strt(9:12));
    dend = str2double(strt(13:15));
    
    tcount = dend - dstart + 1;
    
    for j = 1:mhru
        pararea(hrupar(j)) = pararea(hrupar(j)) + hruarea(j);
    end
    
    %% Read the state of every day in the time window
    for y = ystart:yend
        for d = dstart:dend
            filename = strcat(filePath, ...
                num2str(y,'%04g'), num2str(d,'%03g'), '.dat');
            data = importdata(filename);
            ind = 1;
            date_state = cell(parcount,1);
            for j = 1:mhru
                par = hrupar(j);
                date_state{par} = [date_state{par}; data(ind:ind+mvar+mlyr-1)];
                ind = ind + mvar + mlyr;
            end
            for j = 1:parcount
                if ~isempty(pars{j})
                    pars{j} = pars{j} + date_state{j};
                else
                    pars{j} = date_state{j};
                end
            end
        end
    end
    for i = 1:parcount
        pars{i} = pars{i}/tcount;
    end
    
    %% Construct observation operator
    for j = 1:mhru
        par = hrupar(j);
        mts{par} = [mts{par}, (ones(1,4+mlyr))*hruarea(j)/pararea(par)];
        ind = ind + mvar + mlyr;
    end

end

