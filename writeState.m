function writeState( pars, strt, filePath, hrupar )
%WRITESTATE Write the model state of the sub-basins, in the obs window of
%strt.
%
%   writeState( pars, strt, filePath )
%
% INPUT
%   pars        - The cell of partitions.
%   str         - The string of time window
%   filePath    - The path of folder

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
    
    tcount = dend - dstart + 1;
    dates = cell(tcount,1);

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
    

    for t = 1:tcount
        fullPath = strcat(filePath, ...
            num2str(ystart,'%04g'), num2str(dstart+t-1,'%03g'), '.dat');
        dlmwrite( fullPath, dates{t}, 'delimiter','', 'precision','%20.4f');
    end
end

