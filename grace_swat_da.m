%% Initiate multi-core environment
if(matlabpool('size')<=0)
    matlabpool local 12;
end

% This script must be run in the dir of "Assimilation of GRACE & SWAT"
clc;
clear;

lst = dir(strcat(cd, '\Ensemble')); % The list of folders of ensembles.

% Select a particular scale
% load r_250km;
% load r_300km;
% load r_325km;
% load r_375km;
% load r_450km;
% load r_450km++1;
load r_450km++2;
% load r_650km;

% Necessary variables
parcount = max(hrupar);         % The number of partitions.
encount = size(lst,1)-2;        % The number of ensamble members
% graceDate = importdata('GRACEdate.dat');    % The string of the time windows of GRACE observations.
graceDate = importdata('GRACEdate2003.dat');

% Activate the multi-core computation
% matlabpool close;
% matlabpool local 12;

%% Perturb meteological forces
fprintf('Start perturbing the meteological forces.\n\n');
meteo_pert_ensemble;

%% Perturb initial model states
perturbStd = 0.15;
init_state_path = strcat(cd, '\initial_state_2003001\');
fprintf('Start perturbing the initial states.\n\n');
perturbInitState(lst, perturbStd, init_state_path);
fprintf('\nPerturbing finished.\n');
fprintf('*****************************************************************\n\n\n');

%% Main route
fprintf('Start the data assimilation:\n\n');
for t = 1:length(graceDate)
    obsT = graceDate{t};
    fprintf('Assimilating the time window--%s...\n', obsT);
    assimInOneWin(lst, obsT, hrupar, graceData(t,:), obsstd);
    fprintf('Assimilation of %s is finished.\n\n', obsT);
end

%% Calculate Ensemble Mean
ensembleMean2003;

%% Terminate multi-core environment
if(matlabpool('size')>0)
    matlabpool close;
end