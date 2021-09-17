% Figure Making for final results in Matlab

clear;clc;close all;
%% Let's plot the posterior

fileID = fopen('avg_dist_1000_posterior.txt','r');
number_lines = 1000;
j = 1;
while j <= number_lines
        matData = fgetl(fileID);
        posterior(j) = str2double(matData);
        j = j+1;
end

%%
params1 = linspace(30/6,300/6,1000);
f = fit(params1',posterior','gauss1');
plot(params1,posterior,params1,f(params1))

figure
plot(params1(1:500),posterior(1:500),params1(1:500),f(params1(1:500)),'k','LineWidth',4)
xlabel('stalk cell growth rate (hours)')
ylabel('probability')
%title('Calibration Samples')
H=gca;
H.LineWidth = 3
H.YAxis.FontWeight = 'bold'
H.XAxis.FontWeight = 'bold'
H.FontSize = 16
legend('calibrated pdf','gaussian fit','Location','NorthEast')
legend boxoff

%% Plot best fit (113)

num_lines = 181*201;


filename = sprintf('avg_dist_best_fit1020.txt','r');
fileID = fopen(filename); 
j = 1;
while j <= num_lines
        matData = fgetl(fileID);
        best_1020(j) = str2double(matData);
        j = j+1;
end
filename = sprintf('avg_dist_best_fit1500.txt','r');
fileID = fopen(filename); 
j = 1;
while j <= num_lines
        matData = fgetl(fileID);
        best_1500(j) = str2double(matData);
        j = j+1;
end

for number = 1:3
filename = sprintf('data_thinned_%d.txt',1020 + 480*(number-1));
fileID = fopen(filename); 
j = 1;
   while j <= num_lines
        matData = fgetl(fileID);
        data_centerline(j,number) = str2double(matData);
        j = j+1;
   end
end


for t = 1:3
    for i = 1:181
        for j = 1:201
            best_1020_final(i,j,t) = best_1020(j+201*(i-1));
            best_1500_final(i,j,t) = best_1500(j+201*(i-1));
            data_centerline_map(i,j,t) = data_centerline(j+201*(i-1),t);
        end
    end
end

%% plot best fit

fig = figure;
show_1020(:,:,1) = best_1020_final(:,:,1);
show_1020(:,:,2) = data_centerline_map(:,:,1);
show_1020(:,:,3) = 0;
imagesc(show_1020)
axis image;
axis off;

fig2 = figure;
show_1500(:,:,1) = best_1500_final(:,:,1);
show_1500(:,:,2) = data_centerline_map(:,:,2);
show_1500(:,:,3) = 0;
imagesc(show_1500)
axis image;
axis off;


%% Heat map stuff

num_lines = 181*201;

for number = 1:3
filename = sprintf('heat_map_%d.txt',1020 + 480*(number-1));
fileID = fopen(filename); 
j = 1;
   while j <= num_lines
        matData = fgetl(fileID);
        heat_map(j,number) = str2double(matData);
        j = j+1;
   end
end

for t = 1:3
    for i = 1:181
        for j = 1:201
            heat_map_final(i,j,t) = heat_map(j+201*(i-1) ,t);
        end
    end
end

%% plot heat map

rbg_test(:,:,1) = double(256*heat_map_final(:,:,1));
rbg_test(:,:,2) = double(256*data_centerline_map(:,:,1));
rbg_test(:,:,3) = 0;

fig1 = figure;
imagesc(heat_map_final(:,:,1))
axis image;
axis off;
colormap hot;

fig2 = figure;
contour(flipdim(heat_map_final(:,:,2),1))
axis image;
axis off;
colormap hot;

fig3 = figure;
contour(flipdim(heat_map_final(:,:,3),1)>=0.2)
axis image;
axis off;
colormap jet;


trial_1(:,:,1) = heat_map_final(:,:,1)>=50;
trial_1(:,:,2) = data_centerline_map(:,:,1);
trial_1(:,:,3) = 0;
trial_2(:,:,1) = heat_map_final(:,:,2)>=50;
trial_2(:,:,2) = data_centerline_map(:,:,2);
trial_2(:,:,3) = 0;
trial_3(:,:,1) = heat_map_final(:,:,3)>=50;
trial_3(:,:,2) = data_centerline_map(:,:,3);
trial_3(:,:,3) = 0;
figure;
imagesc(trial_1)
axis image;
axis off;

imagesc(trial_2)
imagesc(trial_3)

%%

trial_1(:,:,1) = heat_map_final(:,:,1)>=10;
trial_1(:,:,2) = data_centerline_map(:,:,1);
trial_1(:,:,3) = 0;
trial_2(:,:,1) = heat_map_final(:,:,2)>=10;
trial_2(:,:,2) = data_centerline_map(:,:,2);
trial_2(:,:,3) = 0;
trial_3(:,:,1) = heat_map_final(:,:,3)>=10;
trial_3(:,:,2) = data_centerline_map(:,:,3);
trial_3(:,:,3) = 0;
figure;
imagesc(trial_1)
axis image;
axis off;

figure
imagesc(trial_2)
axis image;
axis off;

figure
imagesc(trial_3)
axis image;
axis off;

%%

trial_1(:,:,1) = heat_map_final(:,:,1)>=50;
trial_1(:,:,2) = data_centerline_map(:,:,1);
trial_1(:,:,3) = 0;
trial_2(:,:,1) = heat_map_final(:,:,2)>=33;
trial_2(:,:,2) = data_centerline_map(:,:,2);
trial_2(:,:,3) = 0;
trial_3(:,:,1) = heat_map_final(:,:,3)>=50;
trial_3(:,:,2) = data_centerline_map(:,:,3);
trial_3(:,:,3) = 0;
figure;
imagesc(trial_1)
axis image;
axis off;

figure
imagesc(trial_2)
axis image;
axis off;

figure
imagesc(trial_3)
axis image;
axis off;

%%

trial_1(:,:,1) = heat_map_final(:,:,1)>=100;
trial_1(:,:,2) = data_centerline_map(:,:,1);
trial_1(:,:,3) = 0;
trial_2(:,:,1) = heat_map_final(:,:,2)>=100;
trial_2(:,:,2) = data_centerline_map(:,:,2);
trial_2(:,:,3) = 0;
trial_3(:,:,1) = heat_map_final(:,:,3)>=167;
trial_3(:,:,2) = data_centerline_map(:,:,3);
trial_3(:,:,3) = 0;
figure;
imagesc(trial_1)
axis image;
axis off;

figure
imagesc(trial_2)
axis image;
axis off;

figure
imagesc(trial_3)
axis image;
axis off;

%%

resize_heat_map1 = imresize(heat_map_final(:,:,1),0.25);
figure
imagesc(resize_heat_map1)
trial_1_resize = resize_heat_map1 >= 10;
reresize_heat_map1 = imresize(trial_1_resize(:,:,1),4);
figure
imagesc(reresize_heat_map1)


