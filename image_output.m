function g = image_output (f, n, h)
%%% Input image
[a, b] = size(f);
d = 2 ^ nextpow2(max(a,b));
a1 = floor((d - a) / 2) + 1;
a2 = a1 + a - 1;
b1 = floor((d - b) / 2) + 1;
b2 = b1 + b - 1;

fzp = zeros(d, d);
fzp(a1:a2, b1:b2) = f;
fzp = fftshift(fzp);
F = fft2(fzp);


%%% Noise
nzp = zeros(d, d);
nzp(a1:a2, b1:b2) = n;
nzp = fftshift(nzp);
N = fft2(nzp);


%%% Linear dynamic system transfer function
[dim_h, ~] = size(h);
c1 = round((d - dim_h) / 2) + 1;
c2 = c1 + dim_h - 1;

hzp = zeros(d, d);
hzp(c1:c2, c1:c2) = h;
hzp = fftshift(hzp);
H = fft2(hzp);


%%% Output image
G = F .* H + N;
g = ifft2(G);
g = ifftshift(g);
g = g(a1:a2, b1:b2);