pianod.y_add = ym(860:1400);
pianod.y_add = [];
n = generate_piano_note(440, pianod);
% n = generate_piano_note(440, pianod);
% sound(n, 44100);
% figure;
plot_wave(n / max(n))
% hold on
% plot_wave(y / max(y))

% figure;
% fft_wave(n);
% hold on
% fft_wave(y);
