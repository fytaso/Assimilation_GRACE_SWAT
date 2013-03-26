function assimInWin( lst, obsT1, obsT2 )
%ASSIMINWIN Summary of this function goes here
%   Detailed explanation goes here
    
    %% Initial run
    runBegin = str2num(obsT1(1:7));
    runEnd = str2num(obsT2(9:15))+1;
    writeBegin = runBegin;
    writeEnd = runEnd-1;
    runSwat(lst, runBegin,runEnd, writeBegin,writeEnd);
    
    %% Data assimilation
    
    
    
    %% Rerun the model, and add in Kalman gains
    readBegin = writeBegin;
    readEnd = writeEnd;
    runSwatUpdate(lst, runBegin,runEnd, writeBegin,writeEnd, readBegin,readEnd);
    

end