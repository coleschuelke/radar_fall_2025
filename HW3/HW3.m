clear all;
close all;
clc;


%% Problem 1
n_samples = 2048;
fs = 10^8; % Hz
dt = 1/fs; % s
tau = 10^-5; % s
s1 = 10^12; % Hz/s
s2 = 1.01 * 10^12; % Hz/s
s3 = 1.03 * 10^12; % Hz/s

x = -tau/2:dt:(-tau/2 + dt*(n_samples-1));
% x = linspace(-tau/2, tau/2, n_samples);


chirp = make_chirp(n_samples, tau, fs, s1);

ref_perf = make_chirp(n_samples, tau, fs, s1);
ref_imp_1 = make_chirp(n_samples, tau, fs, s2);
ref_imp_2 = make_chirp(n_samples, tau, fs, s3);

fft_chirp = fft(chirp);
ifft_chirp = ifft(fft_chirp);
fft_ref_perf = fft(ref_perf);
fft_ref_imp_1 = fft(ref_imp_1);
fft_ref_imp_2 = fft(ref_imp_2);

match_1_freq = fft_chirp.*conj(fft_ref_perf);
match_2_freq = fft_chirp.*conj(fft_ref_imp_1);
match_3_freq = fft_chirp.*conj(fft_ref_imp_2);

match_1_time = real(fftshift(ifft(match_1_freq)));
match_2_time = real(fftshift(ifft(match_2_freq)));
match_3_time = real(fftshift(ifft(match_3_freq)));


% ONLY PLOT A FEW SIDE LOBES
% Why is it giving me a warning here on ignoring im parts, I call real()
figure;
subplot(3,1,1);
plot(x, 20*log10(abs(match_1_time)))
subplot(3,1,2);
plot(x, 20*log10(abs(match_2_time)))
subplot(3,1,3);
plot(x, 20*log10(abs(match_3_time)))


%% Problem 2
n_samples = 2048;
fs = 10^8; % Hz
tau = 10^-5; % s
s = 1.01 * 10^12; % Hz/s

chirp_1 = make_chirp(n_samples, tau, fs, s, 'startIndex', 100);
chirp_2 = make_chirp(n_samples, tau, fs, s, 'startIndex', 400);
chirp_3 = make_chirp(n_samples, tau, fs, s, 'startIndex', 500);

chirp_agg = chirp_1 + 5*chirp_2 + 2*chirp_3;

ref = make_chirp(n_samples, tau, fs, s);

fft_chirp = fft(chirp_agg);
fft_ref = fft(ref);
match_freq = fft_chirp.*conj(fft_ref);
match_time = fftshift(ifft(match_freq));

figure;
plot(real(match_time))

%% Problem 3
fid = fopen('ersdata');
data = fread(fid, [10218, inf], 'uint8');
data = data.';

data(:, 1:412) = [];
data = data(:, 1:2:end) + 1i * data(:, 2:2:end);

n_samples = 9806/2;
s = 4.189166 * 10^11; %Hz/s
tau = 37.12 * 10^-6; % s
fs = 18.96 * 10^6; % Hz
ers_chirp = make_chirp(n_samples, tau, fs, s);

fft_chirp = fft(ers_chirp);

% Range Compression
compressed_data = zeros(size(data));
for i=1:1024
    range = data(i,:);
    range_fft = fft(range);
    range_compressed = ifft(range_fft.*conj(fft_chirp));
    compressed_data(i,:) = real(range_compressed);
end


figure;
image(real(data))

figure;
plot(real(fftshift(abs(fft_chirp))))

figure;
image(real(compressed_data))


