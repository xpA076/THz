function [hl, f_ratio] = find_harmony_level(y)
%% parapeters
hl = [];
f_ratio = [];
df = 44100 / length(y);
f0 = 440;

%% fft
[f, fftd] = fft_wave(y);
% fftd = fftd / max(abs(fftd));

%% harmony levels
for i = 1:10
    i1 = round((i - 0.5) * f0 / df);
    i2 = round((i + 0.5) * f0 / df);
    [level, ii] = max(abs(fftd(i1:i2)));
    i = i1 - 1 + ii;
    hl = [hl, fftd(i)];
    f_ratio = [f_ratio, f(i) / f0];
end


end
