function [f, fftd] = fft_wave(y)
N = length(y);
fs = 44100;
df = fs / N;
fftd = fft(y);
f = [0:N-1] * df;
plot(f / 440, abs(fftd) / max(abs(fftd)));xlim([0 20])
end



