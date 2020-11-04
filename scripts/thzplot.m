figure;
[data, name] = getTDSdata('plot');
plot(data(:, 1), data(:, 2));
legend(name)
grid on
