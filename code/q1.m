clc;
clear;
close all;
rng(42);

M_iters = 500;

% Parameters
% True
mu_true = 10;
s_true = 4;
% Prior 1:
mu_prior = 10.5;
s_prior = 1;
% Prior 2:
a = 9.5;
b = 11.5;

N_vals = [5, 10, 20, 40, 60, 80, 100, 500, 10^3, 10^4];
len_n = length(N_vals);
MLE = zeros(len_n, M_iters);
MAP1 = zeros(len_n, M_iters);
MAP2 = zeros(len_n, M_iters);

for i = 1:1:len_n
    N = N_vals(i);
    for j = 1:1:M_iters
        % Data generation
        data = mu_true + s_true*randn([N, 1]);
        avg = sum(data)/N;

        % ML Estimate
        ml_estimate = avg;
        e_mle = abs(ml_estimate - mu_true)/mu_true;
        MLE(i, j) = e_mle;

        % MAP_1 Estimate
        weights = [s_prior^2; (s_true^2)/N];
        mus = [avg; mu_prior];
        map1_estimate = (weights'*mus)/sum(weights);
        e_map1 = abs(map1_estimate - mu_true)/mu_true;
        MAP1(i, j) = e_map1;

        % MAP_2 Estimate
        map2_estimate = min(max(avg, a), b);
        e_map2 = abs(map2_estimate - mu_true)/mu_true;
        MAP2(i, j) = e_map2;
    end
end

% Remove unnecessary data from the workspace:
clear i;
clear j;
clear N;
clear avg;
clear mus;
clear weights;
clear e_mle;
clear e_map1;
clear e_map2;
clear ml_estimate;
clear map1_estimate;
clear map2_estimate;

% Boxplots:

max_error = max([max(MLE(:)), max(MAP1(:)), max(MAP2(:))]);

% MLE:
boxplot(MLE', N_vals);
xlabel("N values");
ylabel("Relative error");
ylim([0 max_error]);
title("ML Estimate");
saveas(gcf, "plots/q1/mle.jpg");

% MAP1:
figure;
boxplot(MAP1', N_vals);
xlabel("N values");
ylabel("Relative error");
ylim([0 max_error]);
title("MAP_1 Estimate");
saveas(gcf, "plots/q1/map1.jpg");

% MAP2:
figure;
boxplot(MAP2', N_vals);
xlabel("N values");
ylabel("Relative error");
ylim([0 max_error]);
title("MAP_2 Estimate");
saveas(gcf, "plots/q1/map2.jpg");
