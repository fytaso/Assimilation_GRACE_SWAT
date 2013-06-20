function init_state_retrieve( lst )
%INIT_STATE_BACKUP Summary of this function goes here
%   Detailed explanation goes here
    
    encount = size(lst,1)-2;
    initDir = cd;
    for q = 3:encount+2
        filename = strcat(initDir, '\Ensemble\', lst(q).name, '\');
        fprintf('Retrieve the %dth ensemble...\n', q-2);
        copyfile(strcat(filename,'init_state_backup\swat_state.dat'), filename, 'f');
    end

end

