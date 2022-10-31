close; clear; clc;
%%% Input image
f = 255 * mat2gray(imread('CT.tif'));


%%% Linear dynamic system transfer function
dim_h = 32; var_h = 3;
h = fspecial('gaussian', [dim_h, dim_h], var_h); % Gaussian blur


for k = 1:3
    %%% Noise
    if (k == 1)
        SNR = 10;
    elseif (k == 2)
        SNR = 6;
    else
        SNR = 3;
    end
    std_n = std2(f) * 10 ^ (-SNR / 20);
    n = std_n * randn(size(f)); % Adictive White Gaussian noise


    %%% Output image
    g = image_output(f, n, h);


    %%% FILTERS
    fe_wiener_Sn_Sf = wiener_filter_Sn_Sf(f, h, n, g);
    fe_wiener_SNR = wiener_filter_SNR(h, g, SNR);
    fe_lucy = deconvlucy(g, h + 1e-3 * randn(size(h)));
    [fe_blind1, ~] = deconvblind(g, h + 1e-3 * randn(size(h)));
    [fe_blind2, ~] = deconvblind(g, h + 1e-2 * randn(size(h)));


    %%% METRICS
    Metrics_g = metrics_NRMSE_Emax_SSIM(f, g);
    Metrics_fe_wSnSf = metrics_NRMSE_Emax_SSIM(f, fe_wiener_Sn_Sf);
    Metrics_fe_wSNR = metrics_NRMSE_Emax_SSIM(f, fe_wiener_SNR);
    Metrics_fe_lucy = metrics_NRMSE_Emax_SSIM(f, fe_lucy);
    Metrics_fe_b1 = metrics_NRMSE_Emax_SSIM(f, fe_blind1);
    Metrics_fe_b2 = metrics_NRMSE_Emax_SSIM(f, fe_blind2);


    %%% EXCEL
    xlswrite('Metrics.xlsx', Metrics_g, 'Sheet1', ['B' num2str(k+1) ':D' num2str(k+1)]);
    xlswrite('Metrics.xlsx', Metrics_fe_wSnSf, 'Sheet1', ['B' num2str(k+4) ':D' num2str(k+4)]);
    xlswrite('Metrics.xlsx', Metrics_fe_wSNR, 'Sheet1', ['B' num2str(k+7) ':D' num2str(k+7)]);
    xlswrite('Metrics.xlsx', Metrics_fe_lucy, 'Sheet1', ['B' num2str(k+10) ':D' num2str(k+10)]);
    xlswrite('Metrics.xlsx', Metrics_fe_b1, 'Sheet1', ['B' num2str(k+13) ':D' num2str(k+13)]);
    xlswrite('Metrics.xlsx', Metrics_fe_b2, 'Sheet1', ['B' num2str(k+16) ':D' num2str(k+16)]);


    %%% OUTPUT
    imwrite(uint8(255 * mat2gray(g)), ['CT_Blurred_Noisy_' num2str(SNR) '.jpg']);
    imwrite(uint8(255 * mat2gray(fe_wiener_Sn_Sf)), ['CT_Est_WSnSf_' num2str(SNR) '.jpg']);
    imwrite(uint8(255 * mat2gray(fe_wiener_SNR)), ['CT_Est_WSNR_' num2str(SNR) '.jpg']);
    imwrite(uint8(255 * mat2gray(fe_lucy)), ['CT_Est_Lucy_' num2str(SNR) '.jpg']);
    imwrite(uint8(255 * mat2gray(fe_blind1)), ['CT_Est_B1_' num2str(SNR) '.jpg']);
    imwrite(uint8(255 * mat2gray(fe_blind2)), ['CT_Est_B2_' num2str(SNR) '.jpg']);
end