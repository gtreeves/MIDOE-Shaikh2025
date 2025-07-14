%%
function model_predictions = calc_prediction_stats(y,t)

steady_state = y(length(y));

control_info = stepinfo(y,t,steady_state,'RiseTimeLimits',[0 0.95]);
trise = control_info.RiseTime;   
% settime = control_info.SettlingTime;
% setmax = control_info.PeakTime;
% delSet = settime - setmax;
ymax = max(y);
dely = max(y) - steady_state;
overshoot = dely/steady_state;
% [tsol,Ysol] = ode15s(@(t,y)diffun(t,y,k),tspan,y0);
% Smad24n = Ysol(:,21)+Ysol(:,22);
% Smad24n_steady_state = Smad24n(end);
% model_info = stepinfo(Smad24n,tsol);
yg = 0.37*(steady_state-y(1)) + y(1);
tau_guess = interp1(y,t,yg,'cubic');

fun = @(x,xdata)y(1) + x(1)*(1 - exp(-(xdata - x(3))/x(2)));
x0 = [steady_state,tau_guess, 2];
options = optimset('display','off');
x = lsqcurvefit(fun,x0,t,y,[0 0 0],[],options);

model_predictions.trise = trise;
model_predictions.A = x(1);
model_predictions.tau = x(2);
model_predictions.dead_time = x(3);
model_predictions.ss = steady_state;
model_predictions.dely = dely;
model_predictions.overshoot = overshoot;

%{
figure;plot(t,y)
%}
end