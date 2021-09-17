number_lines = 1000;

filename = sprintf('data_avg_dist.txt');
fileID = fopen(filename); 
j = 1;
   while j <= number_lines
        %matData = fscanf(fileID,'%s, %s %s\n');
        matData = fgetl(fileID);
        data(j,:) = str2num(matData);
        j = j+1;
   end
   fclose(fileID);
   
filename = sprintf('model_avg_dist.txt');
fileID = fopen(filename); 
j = 1;
   while j <= number_lines
        %matData = fscanf(fileID,'%s, %s %s\n');
        matData = fgetl(fileID);
        model(j,:) = str2num(matData);
        j = j+1;
   end
   fclose(fileID);
   
%% plot avg_dist

figure
subplot(2,3,1)
plot(1:1000,model(:,1))
subplot(2,3,2)
plot(1:1000,model(:,2))
subplot(2,3,3)
plot(1:1000,model(:,3))
subplot(2,3,4)
plot(1:1000,data(:,1))
subplot(2,3,5)
plot(1:1000,data(:,2))
subplot(2,3,6)
plot(1:1000,data(:,3))

figure
subplot(2,3,1)
histogram(2.254*model(:,1))
xlabel('microns')
ylabel('frequency')
title('Average centerline distance M->D: Day 5')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;
subplot(2,3,2)
histogram(2.254*model(:,2))
xlabel('microns')
ylabel('frequency')
title('Day 7')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;
subplot(2,3,3)
histogram(2.254*model(:,3))
xlabel('microns')
ylabel('frequency')
title('Day 9')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;
subplot(2,3,4)
histogram(2.254*data(:,1))
xlabel('microns')
ylabel('frequency')
title('Average centerline distance D->M: Day 5')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;
subplot(2,3,5)
histogram(2.254*data(:,2))
xlabel('microns')
ylabel('frequency')
title('Day 7')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;
subplot(2,3,6)
histogram(2.254*data(:,3))
xlabel('microns')
ylabel('frequency')
title('Day 9')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

figure
subplot(1,3,1)
boxplot([2.254*data(:,1) 2.254*model(:,1)],'Whisker',3,'notch','on','Labels',{'avg_dist(d,m)','avg_dist(m,d)'})
ylabel('microns')
title('Day 5')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

subplot(1,3,2)
boxplot([2.254*data(:,2) 2.254*model(:,2)],'Whisker',3,'notch','on')
ylabel('microns')
title('Day 7')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

subplot(1,3,3)
boxplot([2.254*data(:,3) 2.254*model(:,3)],'Whisker',3,'notch','on')
ylabel('microns')
title('Day 9')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

figure
subplot(1,3,1)
boxplot([2.254*model(:,1) 2.254*model(:,2) 2.254*model(:,3)],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('microns')
%title('avg dist(m,d)')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

subplot(1,3,2)
boxplot([2.254*data(:,1) 2.254*data(:,2) 2.254*data(:,3)],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('microns')
%title('avg dist(d,m)')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

subplot(1,3,3)
boxplot([dice(:,1) dice(:,2) dice(:,3)],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('Dice score')
%title('avg dist(m,d)')
ylim([0.44 0.66])
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

figure
boxplot([dice(:,1) dice(:,2) dice(:,3)],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('Dice score')
%title('avg dist(m,d)')
ylim([0.44 0.66])
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

%%
figure
subplot(1,2,1)
boxplot([2.254*model(:,1)/167 2.254*model(:,2)/167 2.254*model(:,3)/167],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('normalized length')
%title('avg dist(m,d)')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

subplot(1,2,2)
boxplot([2.254*data(:,1)/167 2.254*data(:,2)/167 2.254*data(:,3)/167],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('normalized length')
%title('avg dist(d,m)')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

figure
subplot(1,2,1)
boxplot([100*2.254*model(:,1)/167 100*2.254*model(:,2)/167 100*2.254*model(:,3)/167],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('normalized length (%)')
%title('avg dist(m,d)')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

subplot(1,2,2)
boxplot([100*2.254*data(:,1)/167 100*2.254*data(:,2)/167 100*2.254*data(:,3)/167],'Whisker',3,'notch','on','Labels',{'Day 5','Day 7','Day 9'})
ylabel('normalized length (%)')
%title('avg dist(d,m)')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

quantile(2.254*model(:,1)/212.3072,[.25 .5 .75])
quantile(2.254*model(:,2)/212.3072,[.25 .5 .75])
quantile(2.254*model(:,3)/212.3072,[.25 .5 .75])
quantile(2.254*data(:,1)/212.3072,[.25 .5 .75])
quantile(2.254*data(:,2)/212.3072,[.25 .5 .75])
quantile(2.254*data(:,3)/212.3072,[.25 .5 .75])

%% posterior

number_lines = 400;

filename = sprintf('avg_dist_posterior.txt');
fileID = fopen(filename); 
j = 1;
   while j <= number_lines
        %matData = fscanf(fileID,'%s, %s %s\n');
        matData = fgetl(fileID);
        posti_prob(j) = str2num(matData);
        j = j+1;
   end
   fclose(fileID);
   
%% plot posterior
params1 = linspace(200/6,1000/6,400);
y_norm = fit(params1',posti_prob','gauss1');
gauss_fit1 = y_norm(params1);
plot(params1,gauss_fit1)
figure
plot(params1,posti_prob,params1,gauss_fit1,'k','LineWidth',3)
xlabel('hours')
ylabel('probability')
%t = title('\fontsize{20}Stalk Cell Divide Time PDF', 'Units', 'normalized', 'Position', [0.65, 0.8, 0]);
legend('calibrated PDF','Gaussian fit')
H=gca;
H.LineWidth = 3;
H.YAxis.FontWeight = 'bold';
H.XAxis.FontWeight = 'bold';
H.FontSize = 16;

%% best fit

number_lines = 400;

filename = sprintf('avg_dist_best_fit1200.txt');
fileID = fopen(filename); 
j = 1;
while j <= 301*196
     %matData = fscanf(fileID,'%s, %s %s\n');
     matData = fgetl(fileID);
     best_fit1200(j) = str2num(matData);
     j = j+1;
end
fclose(fileID);

filename = sprintf('avg_dist_best_fit1680.txt');
fileID = fopen(filename); 
j = 1;
while j <= 301*196
     %matData = fscanf(fileID,'%s, %s %s\n');
     matData = fgetl(fileID);
     best_fit1680(j) = str2num(matData);
     j = j+1;
end
fclose(fileID);

filename = sprintf('avg_dist_best_fit2160.txt');
fileID = fopen(filename); 
j = 1;
while j <= 301*196
     %matData = fscanf(fileID,'%s, %s %s\n');
     matData = fgetl(fileID);
     best_fit2160(j) = str2num(matData);
     j = j+1;
end
fclose(fileID);

for i = 1:3
    filename = sprintf('data_thinned_%d.txt',1200+480*(i-1));
    fileID = fopen(filename);
    j = 1;
    while j <= 301*196
        matData = fgetl(fileID);
        data_CM2(i,j) = str2num(matData);
        j=j+1;
    end 
end
fclose(fileID);

%% 

for size_x = 1:301
    for size_y = 1:196
         best_fit(size_x,size_y,1) = best_fit1200(size_y + 196*(size_x-1));
         best_fit(size_x,size_y,2) = best_fit1680(size_y + 196*(size_x-1));
         best_fit(size_x,size_y,3) = best_fit2160(size_y + 196*(size_x-1));
         data_thinned(size_x,size_y,1) = data_CM2(1,size_y + 196*(size_x-1));
         data_thinned(size_x,size_y,2) = data_CM2(2,size_y + 196*(size_x-1));
         data_thinned(size_x,size_y,3) = data_CM2(3,size_y + 196*(size_x-1));
    end
end

best_fit_plot1(:,:,1) = best_fit(:,:,1);
best_fit_plot1(:,2:196,2) = data_thinned(:,1:195,1);
best_fit_plot1(:,1,2) = 0;
best_fit_plot1(:,:,3) = 0;

best_fit_plot2(:,:,1) = best_fit(:,:,2);
best_fit_plot2(:,2:196,2) = data_thinned(:,1:195,2);
best_fit_plot2(:,1,2) = 0;
best_fit_plot2(:,:,3) = 0;

best_fit_plot3(:,:,1) = best_fit(:,:,3);
best_fit_plot3(:,2:196,2) = data_thinned(:,1:195,3);
best_fit_plot3(:,1,2) = 0;
best_fit_plot3(:,:,3) = 0;

fig1 = figure;
imagesc(best_fit_plot1)
axis image;
axis off;
fig2 = figure;
imagesc(best_fit_plot2)
axis image;
axis off;
fig3 = figure;
imagesc(best_fit_plot3)
axis image;
axis off;


