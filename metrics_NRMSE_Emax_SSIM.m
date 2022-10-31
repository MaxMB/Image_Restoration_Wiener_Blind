function Metrics = metrics_NRMSE_Emax_SSIM (I1, I2)
%%% Emax
I_diff = I1 - I2;
I_diff_abs = abs(I_diff);
Emax = max(max(I_diff_abs));


%%% NRMSE
I_diff_sum2 = sumsqr(I_diff);
I1_sum2 = sumsqr(I1);
NRMSE = sqrt(I_diff_sum2 / I1_sum2);


% SSIM
I1_mean = mean2(I1);
I2_mean = mean2(I2);
I1_var = std2(I1) ^ 2;
I2_var = std2(I2) ^ 2;
I12_cov = mean2(I1 .* I2) - I1_mean * I2_mean;
c = ( (max(max(I1)) - min(min(I1))) / 1e4 ) ^ 2;
SSIM = (2 * I1_mean * I2_mean + c) * (2 * I12_cov + c) /...
    ((I1_mean^2 + I1_mean^2 + c) * (I1_var + I2_var + c));

Metrics = [NRMSE, Emax, SSIM];