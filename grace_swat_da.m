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
% matlabpool close;
% matlabpool local 12;

%% Perturb initial model states
perturbStd = 0.1;
init_state_path = strcat(cd, '\initial_state_2003001\');
fprintf('Start perturbing the initial states.\n\n');
% perturbInitState(lst, perturbStd, init_state_path);
fprintf('\nPerturbing finished.\n');
fprintf('*****************************************************************\n\n\n');

%% Main route
fprintf('Start the data assimilation:\n\n');
for t = 1:length(graceDate)
    obsT = graceDate{t};
    fprintf('Assimilating the time window--%s...\n', obsT);
    assimInOneWin(lst, obsT, hrupar, graceData, obsstd);
    fprintf('Assimilation of %s is finished.\n\n', obsT);
end

%% Calculate Ensemble Mean
ensembleMean;
% rerun the model
runBegin = str2num(graceDate{1}(1:7));
runEnd = str2num(graceData{end}(9:15));
writeBegin = runBegin;
writeEnd = runEnd;
readBegin = runBegin;
readEnd = runEnd;
initDir = cd;
filename = strcat(initDir, '\Ensemble\', lst(q).name);
setDateCtrl(filename, runBegin,runEnd, writeBegin,writeEnd, readBegin,readEnd);
cd(filename);
system('swat2009.exe');
cd(initDir);