function ints = find_harmony_level(f, mgnt, N)
mgnt = mgnt / max(mgnt);
ints = [];
df = 44100 / N;

f0 = 440;

for i = 1:10
    i1 = round((i - 0.5) * f0 / df);
    i2 = round((i + 0.5) * f0 / df);
    level = max(mgnt(i1:i2))
    ints = [ints, level];
end


end