lst = dir('Ensemble');

% number of ensamble members
encount = size(lst,1)-2;
% encount = 2;

graceDate = importdata('GRACEdate.dat');

% Generate initial model states
runSwat('2003001','2003001','2005365',lst);

' Generating initial model states finised'

% Perturb initial model states
perturbStd = 100;
for q = 3:encount+2
    filename = cd;
    filename = strcat(filename, '\Ensemble\', lst(q,1).name,'\');
    t0 = graceDate(1,1);
    subs = readState(t0{1}, filename);
    subcount = size(subs,1);
    for i = 1:subcount
        n = size(subs{i},1);
        subs{i} = subs{i} + normrnd(0, perturbStd, [n,1]);
        correctZeros = (subs{i} >= 0);
        subs{i} = subs{i} .* correctZeros;
    end
    writeState(subs, t0{1}, filename);
end

'Perturbing finished'

% Run Open Loop after perturbing
runSwat('2003001','2003032','2005365',lst);