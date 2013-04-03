function setDateCtrl( filePath, runBegin, runEnd, writeBegin, writeEnd, readBegin, readEnd  )
%SETDATECTRL Set up the setDateCtrl
% INPUT
%   readstart       - Time string of start reading
%   writestart      - Time string of start writing
%   writeend        - Time string of end writing
    
    dateCtrlRun = [ runBegin; runEnd ];
    
    dlmwrite( strcat(filePath, '\da_ctrl_run.dat'), ...
        dateCtrlRun, 'delimiter','', 'precision','%7d');
    
    if ~isempty(writeBegin)
        dateCtrlWrite = [writeBegin; writeEnd];
        dlmwrite( strcat(filePath, '\da_ctrl_write.dat'), ...
            dateCtrlWrite, 'delimiter','', 'precision','%7d');
    end
    
    if ~isempty(readBegin)
        dateCtrlRead = [readBegin; readEnd];
        dlmwrite( strcat(filePath, '\da_ctrl_read.dat'), ...
            dateCtrlRead, 'delimiter','', 'precision','%7d');
    else
        delete( strcat(filePath, '\da_ctrl_read.dat') );
    end
        
end

