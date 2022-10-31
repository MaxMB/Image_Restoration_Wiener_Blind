function fe = wiener_filter_SNR (h, g, SNR)
[a, b] = size(g);
d = 2 ^ nextpow2(max(a,b));
a1 = floor((d - a) / 2) + 1;
a2 = a1 + a - 1;
b1 = floor((d - b) / 2) + 1;
b2 = b1 + b - 1;


%%% Linear dynamic system transfer function
[h_dim, ~] = size(h);
c1 = round((d - h_dim) / 2) + 1;
c2 = c1 + h_dim - 1;

hzp = zeros(d, d);
hzp(c1:c2, c1:c2) = h;
hzp = fftshift(hzp);
H = fft2(hzp);
H2 = abs(H) .^ 2;


%%% Output image
gzp = zeros(d, d);
gzp(a1:a2, b1:b2) = g;
gzp = fftshift(gzp);
G = fft2(gzp);


%%% Estimated input
K = 10 ^ (-SNR/10);
gamma = 1;
Fe = conj(H) .* G ./ (H2 + gamma * K);
fe = ifft2(Fe);
fe = ifftshift(fe);
fe = fe(a1:a2, b1:b2);