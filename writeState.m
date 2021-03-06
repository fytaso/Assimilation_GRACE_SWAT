function writeState( pars, strt, filePath, hrupar )
%WRITESTATE Write the model state of the sub-basins, in the obs window of
%strt.
%
%   writeState( pars, strt, filePath, hrupar )
%
% INPUT
%   pars        - The cell of partitions
%   str         - The string of time window
%   filePath    - The path of folder
%   hrupar      - The correspondence between HRUs and partitions

    %% Load the necessary variabless
    mvar =5; % The number of variables except soil moistures.
    
    parcount = max(hrupar);         % The number of partitions.
    hrucount = length(hrupar);      % The number of HRUs.

    config = importdata(strcat(filePath, 'configuration.dat'));
    mhru = config(1);   % The number of HRUs.
    mlyr = config(2);   % The number of soil layers.
    mch = config(3);    % The number of reaches.
    msub = config(4);   % The number of subasin.
    
    ystart = str2double(strt(1:4));
    dstart = str2double(strt(5:7));
    yend = str2double(strt(9:12));
    dend = str2double(strt(13:15));
    
    tcount = dend - dstart + 1; % The number of days.
    dates = cell(tcount,1);     % The cell-array of the day states.

    %% The old codes for subasins
%     
%     for t = 1:tcount
%         dates{t} = zeros(hrucount, 4);
%         for i = 1:subcount
%             for j = 1:subhrucount(i)
%                 dates{t}( sum(subhrucount(1:i))-subhrucount(i)+j,: ) = ...
%                     pars{i}(4*j*t-3 : 4*j*t)';
%             end
%         end
%     end

    %% The new codes for partitions
    n = mvar+mlyr;     % The dimension of the state of each day.
    date_state = zeros(n*mhru,1);  % The state of the output date.
    for i = 1:parcount
        ind_hru = (hrupar==i); % The index of HURs that are in this partition.
        ind_hru_date = [];
        for j = 1:mhru
            if ind_hru(j)==1
                ind_hru_date = [ind_hru_date; true(n,1)];
            else
                ind_hru_date = [ind_hru_date; false(n,1)];
            end
        end
        ind_hru_date = logical(ind_hru_date);
        date_state(ind_hru_date) = pars{i};
    end
    for t = 1:tcount
        dates{t} = date_state;  % Everyday has the same Kalman gain, e.g. the average gain of this month.
    end

    for t = 1:tcount
        fullPath = strcat(filePath, ...
            num2str(ystart,'%04g'), num2str(dstart+t-1,'%03g'), '.dat');
        dlmwrite( fullPath, dates{t}, 'delimiter','', 'precision', '%20.4f');
    end
end

