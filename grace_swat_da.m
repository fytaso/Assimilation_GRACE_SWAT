% This script must be run in the dir of "Assimilation of GRACE & SWAT"
clc;
clear;

lst = dir(strcat(cd, '\Ensemble')); % The list of folders of ensembles.

% Select a particular scale
load r_450km;

% Necessary variables
parcount = max(hrupar);         % The number of partitions.
encount = size(lst,1)-2;        % The number of ensamble members
graceDate = importdata('GRACEdate.dat');    % The string of the time windows of GRACE observations.

% Activate the multi-core computation
matlabpool local 12

%% Perturb initial model states
perturbStd = 0.1;
init_state_path = strcat(cd, '\initial_state_2003001\');
fprintf('Start perturbing the initial states.\n\n');
perturbInitState(lst, perturbStd, init_state_path);
fprintf('\nPerturbing finished.\n');
fprintf('*****************************************************************\n\n\n');

%% Main route
fprintf('Start the data assimilation:\n\n');
for t = 1:length(graceDate)
    obsT = graceDate(t,1);
    fprintf('Assimilating the time window--%s...\n', obsT);
    assimInOneWin(lst, obsT, hrupar, graceData, obsstd);
    fprintf('Assimilation of %s is finished.\n\n', obsT);
end