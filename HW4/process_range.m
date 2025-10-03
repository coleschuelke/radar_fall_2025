function [outputArg1,outputArg2] = process_range(data, tau, fs, s)
%PROCESS_RANGE Performs range processing on a complex matrix 'data' using a
%reference chirp with specified parameters. Rows should correspond to the
%range direction. DOES NOT FFT SHIFT
rows = size(data, 1);
cols = size(data, 2);
compressed_data = zeros(size(data));
ref_chirp = make_chirp(size(data, 2), tau, fs, s);

ref_fft = fft(ref_chirp);

for i=1:rows
    range = data(i,:);
    range_fft = fft(range);
    range_compressed = ifft(range_fft.*conj(ref_fft));
    compressed_data(i,:) = range_compressed;



outputArg1 = inputArg1;
outputArg2 = inputArg2;
end