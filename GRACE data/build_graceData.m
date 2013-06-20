clc;
clear;

strScale = 'r_650km'; obsstd = 10;
% strScale = 'r_450km++1'; obsstd = 20;
% strScale = 'r_450km++2'; obsstd = 20;
% strScale = 'r_375km'; obsstd = 25;
% strScale = 'r_325km'; obsstd = 27;
% strScale = 'r_300km'; obsstd = 30;

load(strcat(strScale, '_hrupar.mat'));
load(strcat(strScale, '_graceAnom.mat'));
swatDate = importdata('SWATdate.dat');
parcount = max(hrupar);
tcount = length(swatDate);

tws = zeros(tcount, parcount);

filename = cd;
filename = strcat(filename, '\Open loop\');
parfor t = 1:tcount
    obsT = swatDate{t};
    fprintf('Reading %s\n', obsT);
    [pars, mts] = readState(obsT, filename, hrupar);
    for i = 1:parcount
        tws(t,i) = mts{i} * pars{i};
    end
end

graceData = repmat(mean(tws,1), [size(graceAnom,1) 1]) + graceAnom;
filename = cd;
filename = strcat(filename, '\Assimilation_GRACE_SWAT\GRACE data\', strScale, '\', strScale, '.mat');
save(filename, 'graceData', 'hrupar', 'obsstd');