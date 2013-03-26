function writeState( subs, strt, filePath )
%WRITESTATE Write the model state of the sub-basins, in the obs window of
%strt.
% INPUT
%   subs        - The cell of sub-basins.
%   str         - The string of time window
%   filePath    - The path of folder

    load subhrucount;
    subcount = size(subs,1);
    hrucount = sum(subhrucount);

    ystart = str2double(strt(1:4));
    dstart = str2double(strt(5:7));
    yend = str2double(strt(9:12));
    dend = str2double(strt(13:15));
    
    tcount = dend - dstart + 1;
    dates = cell(tcount,1);

    for t = 1:tcount
        dates{t} = zeros(hrucount, 4);
        for i = 1:subcount
            for j = 1:subhrucount(i)
                dates{t}( sum(subhrucount(1:i))-subhrucount(i)+j,: ) = ...
                    subs{i}(4*j*t-3 : 4*j*t)';
            end
        end
    end
    
    for t = 1:tcount
        fullPath = strcat(filePath, ...
            num2str(ystart,'%04g'), num2str(dstart+t-1,'%03g'), '.dat');
        dlmwrite( fullPath, dates{t}, 'delimiter','', 'precision','%20.4f');
    end
end

