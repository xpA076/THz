function ret = plot_wave(y)
fs = 44100;
t = [1:length(y)] * 1 / fs;
figure;
plot(t, y)

end