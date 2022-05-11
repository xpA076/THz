function [te, ye] = find_envelope(y)
fs = 44100;
dt = 1 / fs;
t = [1:length(y)] * dt;

dte = 1 / 80;
te = [0];
ye = [0;0];
for i = 1: floor(length(y) / (dte / dt)) - 1
    te1 = dte * i;
    it1 = round((i - 0.5) * dte / dt);
    it2 = round((i + 0.5) * dte / dt);
    ye_top = max(y(it1:it2));
    ye_bot = min(y(it1:it2));
    te = [te, te1];
    ye_vec = [ye_top;ye_bot];
    ye = [ye, ye_vec];
end

te = te(1:172);
ye = ye(:, 1:172);

end
