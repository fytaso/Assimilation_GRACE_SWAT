t_min = 0;
t_max = 10;
t_delt = 0.01;
t_count = (t_max-t_min)/t_delt + 1;

% Initialize true state
xt = zeros(3,t_count);
xt0 = [1.508870; -1.531271; 25.46091];
xt(:,1) = xt0;
for i = 2:t_count
    xt(:,i) = lorenz3(xt(:,i-1), t_delt);
end

% Generate observations, with noise~N(0,2)
y = xt + normrnd(0, sqrt(2), [3 t_count]);

% Store the results without assimilation
x_na = zeros(size(xt));
x_na(:,1) = y(:,1);
for i = 2:t_count
    x_na(:,i) = lorenz3(x_na(:,i-1), t_delt);
end

% Observation operator
H = eye(3);

% The variance matrix of observations
R = eye(3) * sqrt(2);

% The interval of observations
obs_delt = 0.1;
obs_t_delt = obs_delt / t_delt;

% Store the analysis results 
xa = zeros(size(xt));
xa(:,1) = y(:,1);

% initialize ensemble
d = 1;
q = 30;
x_e = init_en(xt0, d, q);

for t = 2:t_count
    % each member in ensemble step in
    for i = 1:q
        x_e(:,i) = lorenz3(x_e(:,i), t_delt);
    end
    % update by EnKF
    if mod(t, obs_t_delt) == 0
        x_e = enkf(x_e, H, y(:,t), R);
    end
    % Save the analysis results
    xa(:,t) = mean(x_e, 2);
end
t_proc = t_min:t_delt:t_max;
t_proc_obs = t_min:obs_delt:t_max;
y_obs = y(:,1:obs_t_delt:end);

% Show the true v.s. analysis v.s. observations in 3D plot
figure, plot3(xt(1,:)',xt(2,:)',xt(3,:)', ...
              xa(1,:)',xa(2,:)',xa(3,:)', '-g', ...
              y_obs(1,:)',y_obs(2,:)',y_obs(3,:)','or');
title('true v.s. analysis v.s. observations');

% Show the true v.s. results without assimilation in 3 2-D plot
figure
subplot(3,1,1); plot(t_proc,xt(1,:), t_proc,x_na(1,:),'-r')
subplot(3,1,2); plot(t_proc,xt(2,:), t_proc,x_na(2,:),'-r')
subplot(3,1,3); plot(t_proc,xt(3,:), t_proc,x_na(3,:),'-r')

% Show the true v.s. analysis v.s. observations in 3 2-D plot
figure
subplot(3,1,1); plot(t_proc,xt(1,:), t_proc,xa(1,:),'-g', t_proc_obs,y_obs(1,:),'or')
subplot(3,1,2); plot(t_proc,xt(2,:), t_proc,xa(2,:),'-g', t_proc_obs,y_obs(2,:),'or')
subplot(3,1,3); plot(t_proc,xt(3,:), t_proc,xa(3,:),'-g', t_proc_obs,y_obs(3,:),'or')