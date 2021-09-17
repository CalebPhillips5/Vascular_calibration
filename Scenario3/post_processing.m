clear;clc;
cal_rawChain_ml_sub0;
cal_filtered_chain_loglikelihood_sub0;
sfpOutput_qoi_seq_sub0;

subplot(1,3,1)
histogram(cycle_cal_ip_mh_rawChain_sub0(:,1))
title('stalk cell growth time')
subplot(1,3,2)
histogram(cycle_cal_ip_mh_rawChain_sub0(:,2))
title('vegf force')
subplot(1,3,3)
histogram(cycle_cal_ip_mh_rawChain_sub0(:,3))
title('standard deviation')


figure
[f1,x1] = ksdensity(cycle_cal_ip_mh_rawChain_sub0(:,1),'function','pdf');
[f2,x2] = ksdensity(cycle_cal_ip_mh_rawChain_sub0(:,2),'function','pdf');
[f3,x3] = ksdensity(cycle_cal_ip_mh_rawChain_sub0(:,3),'function','pdf');
mean_param(:,1:3) = mean(cycle_cal_ip_mh_rawChain_sub0(:,1:3));
std_param(:,1:3) = std(cycle_cal_ip_mh_rawChain_sub0(:,1:3));
y_norm(:,1) = normpdf(x1,mean_param(1,1),std_param(1,1));
y_norm(:,2) = normpdf(x2,mean_param(1,2),std_param(1,2));
y_norm(:,3) = normpdf(x3,mean_param(1,3),std_param(1,3));
subplot(1,3,1)
plot(x1,f1,x1,y_norm(:,1))
title('stalk cell growth time pdf')
legend('calibrated pdf','gaussian pdf')
subplot(1,3,2)
plot(x2,f2,x2,y_norm(:,2))
title('vegf force pdf')
legend('calibrated pdf','gaussian pdf')
subplot(1,3,3)
plot(x3,f3,x3,y_norm(:,3))
title('standard deviation pdf')
legend('calibrated pdf','gaussian pdf')

figure
subplot(1,3,1)
plot(1:1:7000,cycle_cal_ip_mh_rawChain_sub0(:,1))
title('stalk cell divide time')
legend('calibrated')
subplot(1,3,2)
plot(1:1:7000,cycle_cal_ip_mh_rawChain_sub0(:,2))
title('vegf force pdf')
legend('calibrated')
subplot(1,3,3)
plot(1:1:7000,cycle_cal_ip_mh_rawChain_sub0(:,3))
title('standard deviation')
legend('calibrated')

% Let's get MLE values
[M,I] = max(cycle_cal_ip_logLike_sub0);
best_param = cycle_cal_ip_mh_rawChain_sub0(I,:)

% individual MAP
[M1,I1] = max(cycle_cal_ip_mh_rawChain_sub0(:,1));
best1 = cycle_cal_ip_mh_rawChain_sub0(I1,1)



%% Forward Problem
sfpOutput_qoi_seq;

figure
subplot(1,5,1)
hist(fp_mc_QoiSeq_unified(:,1))
subplot(1,5,2)
hist(fp_mc_QoiSeq_unified(:,2))
subplot(1,5,3)
hist(fp_mc_QoiSeq_unified(:,3))
subplot(1,5,4)
hist(fp_mc_QoiSeq_unified(:,4))
subplot(1,5,5)
hist(fp_mc_QoiSeq_unified(:,5))

mean_predict(1,1) = mean(fp_mc_QoiSeq_sub0(:,1));
mean_predict(2,1) = mean(fp_mc_QoiSeq_sub0(:,2));
mean_predict(3,1) = mean(fp_mc_QoiSeq_sub0(:,3));
mean_predict(4,1) = mean(fp_mc_QoiSeq_sub0(:,4));
mean_predict(5,1) = mean(fp_mc_QoiSeq_sub0(:,5));
std_predict(1,1) = std(fp_mc_QoiSeq_sub0(:,1));
std_predict(2,1) = std(fp_mc_QoiSeq_sub0(:,2));
std_predict(3,1) = std(fp_mc_QoiSeq_sub0(:,3));
std_predict(4,1) = std(fp_mc_QoiSeq_sub0(:,4));
std_predict(5,1) = std(fp_mc_QoiSeq_sub0(:,5));

day3 = [153; 41.4; 152; 54.5; 251; 134; 52.7];
day7 = [261; 99.5; 289; 218; 272; 287; 200];
day11 = [615; 259; 655; 525; 457; 478; 445];
day15 = [909; 515; 1010; 756; 621; 473; 775];
day19 = [1090; 598; 1050; 948; 783; 663; 957];

mean_data = [mean(day3); mean(day7); mean(day11); mean(day15); mean(day19)];
std_data = [std(day3); std(day7); std(day11); std(day15); std(day19)];
data_time = 24.*[3 7 11 15 19];
figpredict = figure;
figpredict.Renderer = 'painters';
%subplot(2,2,1)
plot(data_time,mean_predict,'k','LineWidth',3)
%title('\fontsize{24}Prediction of Calibrated Model')
xlabel('\fontsize{24}hours')
ylabel('\fontsize{24}sprout length (microns)')
yticks([250 500 750 1000])
%hold on
%plot(data_time,mean_predict+std_predict,'r')
%hold on
%plot(data_time,mean_predict-std_predict,'r')
hold on 
k= errorbar(data_time,mean_data,std_data,'o','LineWidth',3)
k.Color = 'black'
H = gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16;

%test fill
mean_fill = [mean_predict+1*std_predict; flip(mean_predict-1*std_predict)];
time_fill(1:5,1) = data_time;
time_fill(6:10,1) = flip(data_time);
h = fill(time_fill(:,1),mean_fill,'r')
set(h,'facealpha',0.5)


legend('mean','data','\sigma Prediction','Location','northwest')
set(legend,'fontsize',20);
legend boxoff

%subplot(2,2,2)
fig1 = figure
plot(x1./6,f1,'k','LineWidth',3)
%title('\fontsize{24}Stalk Cell Divide Time PDF')
t = title({'\fontsize{20}stalk cell divide','\fontsize{20}time PDF'}, 'Units', 'normalized', 'Position', [0.3, 0.7, 0]);
ylabel('\fontsize{24}density')
xlabel('\fontsize{24}time (hours)')
yticks([0 0.05 0.1 0.15 0.2])
%legend('calibrated')
H = gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16
%subplot(2,2,3)

figure
plot(x1./6,f1,'LineWidth',4)
hold on
%y_norm = fit(params1',posti_prob','gauss1');
%gauss_fit1 = y_norm(params1);
plot(x1./6,y_norm(:,1),'k','LineWidth',4)
xlabel('\fontsize{24}distance between tip cells (microns)','FontSize',24)
ylabel('\fontsize{24}probability','FontSize',24)
%title('Calibration Samples')
H=gca;
H.LineWidth = 3;
H.FontSize = 16;
ylabel('\fontsize{24}probability','FontSize',24)
xlabel('\fontsize{24}stalk cell divide time (hours)','FontSize',24)
xlim([2 6])
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
legend('calibrated pdf','Gaussian fit','Location','NorthEast')
set(legend,'fontsize',20);
legend boxoff


fig2 = figure
plot(x2,f2,'k','LineWidth',3)
%title('\fontsize{24}VEGF Force PDF')
t = title('\fontsize{20}VEGF force PDF', 'Units', 'normalized', 'Position', [0.7, 0.8, 0]);
ylabel('\fontsize{24}density')
xlabel('\fontsize{24}force coefficient')
yticks([0 1 2 3 4])
%legend('calibrated')
H = gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16
%subplot(2,2,4)
fig3 = figure
plot(x3,f3,'k','LineWidth',3)
%title('\fontsize{24}Standard Deviation PDF')
t = title({'\fontsize{20}standard', '\fontsize{20}deviation PDF'}, 'Units', 'normalized', 'Position', [0.7, 0.7, 0]);
ylabel('\fontsize{24}density')
xlabel('\fontsize{24}length (microns)')
yticks([0 0.005 0.01 0.015 0.02])
%legend('calibrated')
H = gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16

%% calculating the error

%mean_data = mean of data
%mean_predict = mean of prediction

for i = 1:length(mean_data)
   error(i) = abs(mean_data(i) - mean_predict(i))/mean_data(i);
end


[f1,x1] = ksdensity(fp_mc_QoiSeq_unified(:,1));
[f2,x2] = ksdensity(fp_mc_QoiSeq_unified(:,2));
[f3,x3] = ksdensity(fp_mc_QoiSeq_unified(:,3));
[f4,x4] = ksdensity(fp_mc_QoiSeq_unified(:,4));
[f5,x5] = ksdensity(fp_mc_QoiSeq_unified(:,5));

x = linspace(0,5000,10000);
for i = 1:5
    cdf_data(i,:) = cdf('Normal',x,mean_data(i),std_data(i));
    cdf_model(i,:) = cdf('Normal',x,mean_predict(i),std_predict(i));
    length_error(i) = trapz(x,abs(cdf_data(i,:)-cdf_model(i,:)))/mean_data(i);
end

mean(length_error)
std(length_error)






