t_min = 0;
t_max = 40;
t_delt = 0.01;
t_count = (t_max-t_min)/t_delt + 1;
y0 = [1.508870; -1.531271; 25.46091];
y = zeros(3,t_count);
y(:,1) = y0;
for i = 2:t_count
    y(:,i) = lorenz3(y(:,i-1), t_delt);
end
figure,plot3(y(1,:)',y(2,:)',y(3,:)');
clear