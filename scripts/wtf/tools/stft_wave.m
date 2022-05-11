function [hl, td] = stft_wave(y)
fs = 44100;
dt = 1 / fs;
dte = 1 / 80;

Nd = 170;
td = ([1:Nd])' * dte;
hl = zeros(Nd, 10);
Nw = round(dte / dt * 1.5);
lpad = Nw;
y = [zeros(lpad, 1);y];

for i = 1: size(hl, 1)
    te1 = dte * i;
    it = round(i * dte / dt) + lpad;
    it1 = it - round(Nw / 2);
    it2 = it1 + Nw - 1;
    [hli, fri] = find_harmony_level(y(it1:it2) .* hann(Nw));
    hl(i, :) = hli;
end

end
