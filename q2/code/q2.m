clc;
clear;
close all;

M_iters = 100;

% Parameters
l_true = 5; % True Lambda
% Gamma Prior
a = 5.5; % Alpha
b = 1; % Beta

N_vals = [5, 10, 20, 40, 60, 80, 100, 500, 10^3, 10^4];
len_n = length(N_vals);
MLE = zeros(len_n, M_iters); % Stores the ML Estimate of Lambda
PME = zeros(len_n, M_iters); % Stores the Posterior Mean Estimate of Lambda

for i = 1:1:len_n
    N = N_vals(i);
    for j = 1:1:M_iters
        rng(j);
        % Data generation
        x = rand([N, 1]);
        y = (-1/l_true)*log(x);
        y_sum = sum(y);
        
        % ML Estimate
        ml_estimate = N/y_sum;
        e_mle = abs(ml_estimate - l_true)/l_true;
        MLE(i, j) = e_mle;
        
        % PM Estimate
        pm_estimate = (N + a - 1)/(b + y_sum);
        e_pm = abs(pm_estimate - l_true)/l_true;
        PME(i, j) = e_pm;
    end
end

% Remove unnecessary data from the workspace:
clear x;
clear y;

% Boxplots:
max_error = max([max(MLE(:)), max(PME(:))]);

% MLE:
boxplot(MLE', N_vals);
xlabel("N values");
ylabel("Relative error");
ylim([0 max_error]);
title("Maximum Likelihood Estimate");
saveas(gcf, "../results/mle.jpg");

% PM:
figure;
boxplot(PME', N_vals);
xlabel("N values");
ylabel("Relative error");
ylim([0 max_error]);
title("Posterior Mean Estimate");
saveas(gcf, "../results/pme.jpg");

close all;
