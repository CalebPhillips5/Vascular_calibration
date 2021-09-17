%% Parameter Identifiability.
% Here are the data
clear;clc;
tum_cell_data = [67592 86000 106666 123000 258333]; %cell #
endo_error = [6495 8922 8995 2608 17201];
endo_vegf_error = [92.5 54.4 79 22.2 32.5 12.3 0 0];
tum_error = [6495 8922 8995 2608 17200];
endo_cell_data = [42962 92296 135703 240000 257833]; %cell #
tum_vegf_data  = [1100 1827 2826 3165 3563 3407 3201 3806]; % vegf pg/mL
endo_vegf_data = [1100 678 250 17 16 8 0 0]; % vegf pg/mL
vegf_error = [92.5 94.8 121.2 518.5 385.1 490.9 571.4 422.6];
tum_error = [6495 8922 8995 2608 17200];

time = [24 48 72 120 168];
% These were the calibrated parameters from tumor growth
endo_growth = [0.0374,2.6746e5];
tumor_growth = 0.00889;
% params_fit(1,1) = 0.002792608109623;
% params_fit(1,2) = 3.663298969274345e+03;
% params_fit(1,3) = 7.457669552942094e-07;
% params_fit(1,4) = 0.006084024906445;


% If I constrain the half life to be 20 hours
% params_fit(1,1) = 0.003238785521844;
% params_fit(1,2) = 4.921680487752867e+03;
% params_fit(1,3) = 4.517060241736539e-07;
% params_fit(1,4) = 0.034657577756990;

% params_fit(1,1) = 0.002076992976620;     % production
% params_fit(1,2) = 4.621963283932675e+03; % capacity
% params_fit(1,3) = 7.182301009203045e-07; % consumption
% params_fit(1,4) = 0.010414369218292;     % decay

params_fit(1,1) = 0.00142;
params_fit(1,2) = 8.6e-7;
params_fit(1,3) = 4450.61;


%%
% New Data, but only 3 for PL

num_stepi = 100;
num_stepj = 100;

params1 = params_fit(1,1).*linspace(-0.5,0.75,num_stepj) + params_fit(1,1);
params2 = params_fit(1,2).*linspace(-0.5,0.75,num_stepj) + params_fit(1,2);
params3 = params_fit(1,3).*linspace(-0.25,0.25,num_stepj) + params_fit(1,3);

vegf_data(1,:) = tum_vegf_data;
vegf_data(2,:) = endo_vegf_data;

ICs = [1100 1100];

% Let's start with just varying parameter 1 (vegf_production)
%param_change = params_fit(1,dpar)*linspace(-0.25,0.25,num_stepi) + params_fit(1,dpar);

for i = 1:num_stepi
    for j = 1:num_stepj
        % Define new parameter value
        time = 0:24:168;
        %time = time/100;
        data = tum_vegf_data';
        t = 0:0.01:168;
        params = [params1(1,j) params2(1,j) params3(1,i)];
        %disp(params)
      
        for k = 1:7
          [timetime, model] = ode45(@(t,y) two_species(t,params,y,time(k)),[0 24],ICs);
          % Exact same call as before
          %  t_length(i,1) = length(model);
          model_test(k,:) = model(end,:);
    
          timetime = timetime + time(k);
        end
        
        residual_endo(j,1) = sum( (  model_test(:,2)-vegf_data(2,2:end)' ).^2);
        residual_tum(i,j) =  sum( (  model_test(:,1)-vegf_data(1,2:end)' ).^2);
        %posterior_final(i,j) = exp( -(1 - residual(i,j))^2 / (2*std^2) )*exp( -(1 - surface2(i,j))^2 / (2*std^2) )*exp( -(1 - surface4(i,j))^2 / (2*std^2) );

        % so like, right here I want to pull from a distribution
        %residual(i,j) = mean(resnorm(:));
    end
end
std_tum = 300;
std_endo = 30;
%%
holder = 1;
for std_hold = 1:holder
    std_caleb = 117;
    std_endo = 117;
for j = 1:num_stepj
    posterior_endo(j,1) = exp(- (1/(2*(std_endo^2))) * ( residual_endo(j,1) ));
    for i = 1:num_stepi
        posterior_tum(i,j) = exp(- (1/(2*(std_caleb^2))) * ( residual_tum(i,j) ));% + exp(- (1/(2*(std_endo^2))) * ( residual_tum(i,j) ));
        %posterior_prod(j,1) = exp(- (1/(2*(std_caleb^2))) * ( residual_tum(:,j) ));
        %posterior_endo(j,1) = exp(- (1/(2*(std_endo^2))) * ( residual_endo(j,1) ));
    end
end
for i = 1:num_stepi
   posterior_prod(i,std_hold) = sum(posterior_tum(:,i));
   posterior_cap(i,std_hold) = sum(posterior_tum(i,:));
   %posti_endo(i,std_hold) = sum(posterior_forrealend(i,:));
end

posti_int = trapz(params1,posterior_prod);
postj_int = trapz(params2,posterior_endo);
postk_int = trapz(params3,posterior_cap);
posti_prob = posterior_prod./posti_int;
postj_prob = posterior_endo./postj_int;
postk_prob = posterior_cap./postk_int;
% mean_param(:,1) = mean(posti(:,std_hold));
% mean_param(:,2) = mean(postj(:,std_hold));
% std_param(:,1) = std(posti(:,std_hold));
% std_param(:,2) = std(postj(:,std_hold));
% y_norm(:,1) = normpdf(x1,mean_param(1,1),std_param(1,1));
% y_norm(:,2) = normpdf(x2,mean_param(1,2),std_param(1,2));

fig = figure;
subplot(3,holder,std_hold*3 - 2)
plot(params1,posti_prob,'k','LineWidth',3,'MarkerSize',10)
%line([params_fit(1) params_fit(1)],[0 max(posti_prob)])
xlabel('Vegf Production')
ylabel('Density')
t = title('\fontsize{20}VEGF Production PDF', 'Units', 'normalized', 'Position', [0.3, 0.7, 0]);
H=gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16

subplot(3,holder,std_hold*3-1)
plot(params2,postj_prob,'k','LineWidth',3,'MarkerSize',10)
%line([params_fit(2) params_fit(2)],[0 max(postj_prob)])
xlabel('Vegf Consumption')
ylabel('Density')
t = title('\fontsize{20}VEGF Consumption PDF', 'Units', 'normalized', 'Position', [0.75, 0.7, 0]);
H=gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16

subplot(3,holder,std_hold*3)
plot(params3,postk_prob,'k','LineWidth',3,'MarkerSize',10)
%line([params_fit(3) params_fit(3)],[0 max(postk_prob)])
xlabel('VEGF Carrying Capacity')
ylabel('Density')
t = title('\fontsize{20}VEGF Carrying Capacity PDF', 'Units', 'normalized', 'Position', [0.7, 0.7, 0]);
H=gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16
end


%% Calculate statistics and do the confidence intervals
clearvars P P_hold P_hold2 P_hold3 time1 time2 time3 time_fill
y_norm = fit(params1',posti_prob,'gauss1');
y_norm2 = fit(params2',postj_prob,'gauss1');
y_norm3 = fit(params3',postk_prob,'gauss1');
conf(1,1) = -y_norm.c1;
conf(1,2) = -y_norm2.c1;
conf(1,3) = -y_norm3.c1;
conf(2,1) = 0;
conf(2,2) = 0;
conf(2,3) = 0;
conf(3,1) = y_norm.c1;
conf(3,2) = y_norm2.c1;
conf(3,3) = y_norm3.c1;

fig = figure;
subplot(3,1,1)
plot(params1,y_norm(params1),params1,posti_prob,'k','LineWidth',3,'MarkerSize',10)
%line([params_fit(1) params_fit(1)],[0 max(posti_prob)])
xlabel('VEGF production')
ylabel('density')
t = title('\fontsize{20}VEGF Production PDF', 'Units', 'normalized', 'Position', [0.3, 0.7, 0]);
H=gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16
legend('Gaussian fit','calibrated PDF')
legend boxoff

subplot(3,1,2)
plot(params2,y_norm2(params2),params2,postj_prob,'k','LineWidth',3,'MarkerSize',10)
%line([params_fit(2) params_fit(2)],[0 max(postj_prob)])
xlabel('Vegf consumption')
ylabel('density')
t = title('\fontsize{20}VEGF consumption PDF', 'Units', 'normalized', 'Position', [0.75, 0.7, 0]);
H=gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16

subplot(3,1,3)
plot(params3,y_norm3(params3),params3,postk_prob,'k','LineWidth',3,'MarkerSize',10)
%line([params_fit(3) params_fit(3)],[0 max(postk_prob)])
xlabel('VEGF carrying capacity')
ylabel('density')
t = title('\fontsize{20}VEGF carrying capacity PDF', 'Units', 'normalized', 'Position', [0.7, 0.7, 0]);
H=gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16







f = figure;
f.Renderer = 'painters';
k = errorbar(time,tum_vegf_data,vegf_error,'o','MarkerSize',5,'LineWidth',3)
k.Color = 'red'
hold on
k2 = errorbar(time,endo_vegf_data,endo_vegf_error,'o','MarkerSize',5,'LineWidth',3)
k2.Color = 'blue'
for i = 1:7      
  for p = 1:3
      params_conf = params_fit + [conf(p,1) conf(p,2) conf(p,3)];
      [timetime, P] = ode45(@(t,y) two_species(t,params_conf,y,time(i)),[0 24],ICs);
      if p == 1
        clearvars P_hold
        P_hold(:,2*p-1) = P(:,1);
        P_hold(:,2*p) = P(:,2);
        time1(:,1) = timetime(:,1);
        time1 = time1 + time(i);
      end
      if p == 2
          clearvars P_hold2
          P_hold2(:,1) = P(:,1);
          P_hold2(:,2) = P(:,2);
          time2(:,1) = timetime(:,1);
          time2 = time2 + time(i);
      end
      if p == 3
          clearvars P_hold3
          P_hold3(:,1) = P(:,1);
          P_hold3(:,2) = P(:,2);
          time3(:,1) = timetime(:,1);
          time3 = time3 + time(i);
      end
      t_length(i,1) = length(P);
      timetime = timetime + time(i);
      if p == 2
         plot(time2,P(:,1),'r',time2,P(:,2),'b','MarkerSize',10,'LineWidth',3)
         final_mean(i,:) = P(end,:);
      elseif p == 1
          final_lb(i,:) = P(end,:);
         %plot(time1,P(:,1),'k',time1,P(:,2),'k','MarkerSize',10,'LineWidth',3)
      else
         %plot(time3,P(:,1),'k',time3,P(:,2),'k','MarkerSize',10,'LineWidth',3)
      end
      hold on
  end
      mean_fill1 = [P_hold(:,1); flip(P_hold3(:,1))];
      mean_fill2 = [P_hold(:,2); flip(P_hold3(:,2))];
      time_fill(1:length(time1),1) = time1;
      time_fill(length(time1)+1:length(time1)+length(time3),1) = flip(time3);
      h = fill(time_fill(:,1),mean_fill1,'r')
      h2 = fill(time_fill(:,1),mean_fill2,'b')
      set(h,'facealpha',0.5)
      set(h2,'facealpha',0.5)
      hold on
      clearvars P_hold P P_hold3 P_hold2 time1 time2 time3
end

% errorbar(time,tum_vegf_data,vegf_error,'.k','MarkerSize',10,'LineWidth',3)
% hold on
% errorbar(time,endo_vegf_data,endo_vegf_error,'.b','MarkerSize',10,'LineWidth',3)
% plot(t,P(:,1),'k','LineWidth',3,'MarkerSize',10)
title('\fontsize{24}ELISA Calibration')
ylabel('VEGF (pg/mL)')
xlabel('Time (hours)')
H = gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16
legend('IBC3 VEGF Expression','TIME VEGF Expression','Maximum Likelihood','Maximum Likelihood','\sigma Prediction','\sigma Prediction','Location','northwest')
legend boxoff
axis([0 180 0 5000])

[M1,I1] = max(posti_prob);
[M2,I2] = max(postj_prob);
[M3,I3] = max(postk_prob);

final_parameter_values = [params1(I1); params2(I2); params3(I3)];


%% calculate the relative error in Ernesto's fancy way

x = linspace(0,5000,10000);
for i = 2:length(endo_vegf_data)
    cdf_data_endo(i-1,:) = cdf('Normal',x,endo_vegf_data(i),endo_vegf_error(i));
    cdf_model_endo(i-1,:) = cdf('Normal',x,final_mean(i-1,2),abs(final_mean(i-1,2)-final_lb(i-1,2))/1.96);
    cdf_data_tumor(i-1,:) = cdf('Normal',x,tum_vegf_data(i),vegf_error(i));
    cdf_model_tumor(i-1,:) = cdf('Normal',x,final_mean(i-1,1),abs(final_mean(i-1,1)-final_lb(i-1,1))/1.96);
end

plot(x,cdf_data_endo,x,cdf_model_endo)

for i = 1:7
    M_endo_error(i) = trapz(x,abs(cdf_data_endo(i,:)-cdf_model_endo(i,:)))/endo_vegf_data(i+1);
    M_tum_error(i) = trapz(x,abs(cdf_data_endo(i,:)-cdf_model_endo(i,:)))/tum_vegf_data(i+1);
end

M_endo_error(6:7) = 0;
mean_endo = mean(M_endo_error)
std_endo = std(M_endo_error)
mean_tum = mean(M_tum_error)
std_tum = std(M_tum_error)

for i = 1:7
relative_tum_error(i) = abs(final_mean(i,1)-tum_vegf_data(1,i+1))/tum_vegf_data(1,i+1);
relative_endo_error(i) = abs(final_mean(i,2)-endo_vegf_data(1,i+1))/endo_vegf_data(1,i+1);
end



