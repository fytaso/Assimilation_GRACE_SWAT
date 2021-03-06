function perturbInitState( lst, perturbStd, init_state_path )
%PERTURBINITSATE Perturb the initial model states, based on Gaussian
%distribution
%   
%   perturbInitSate( perturbStd, init_state_path, encount )
%
%   lst -- The list of the folders of ensemble.
%   perturbStd -- The standard derivation of the Gaussian distribution.
%   init_state_path -- The filename of the initial model states.
    
    encount = size(lst,1)-2; % The number of ensemble members
    init_state = importdata(strcat(init_state_path, 'swat_state.dat'));
    parfor q = 3:encount+2
        filename = cd;
        filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
        perturb_state = init_state;
        fprintf('Perturbing the %dth ensemble.\n', q-2);
        for i = 1:length(perturb_state)
            std = perturbStd * perturb_state(i);
            rnd = randn(1)*std;
            if ~isempty(rnd)
                perturb_state(i) = perturb_state(i) + rnd;
            end
            if perturb_state(i)<0
                perturb_state(i) = 0;
            end
        end
        dlmwrite( strcat(filename, 'swat_state.dat'), ...
            perturb_state, 'delimiter','', 'precision','%30.15f');
        copyfile(strcat(init_state_path, 'swat2009.exe'), filename);
        copyfile(strcat(init_state_path, 'file.cio'), filename);
    end
    
end

