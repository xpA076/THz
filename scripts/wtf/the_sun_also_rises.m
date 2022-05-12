info.fs = 44100;
info.f0 = 420;
info.beats_pm = 200;
str = ['-61w,031w,031w,033q,041q|035h,031h,041h,051h|',...
    '063h,061h,051w,051w|031f|-61w,021w,021w,023q,031q|'...
    '021d,031d|053q,031q,051d,-73q,011q|-65w,-61w,011w,031w|'...
    '063q,051q,067q,051q|063q,051q,061d,053q,051q|'...
    '035w,021w,061w,051w|033q,021q,031f,021w,061w,041w|'...
    '033q,021q,031w,051w,-73q,011q|-61f'];
s = build_sound(str, info);
sound(s, info.fs);

function s = build_sound(str, info)
spl = strsplit(str, {',', '|', '~'});
s = [];
for i = 1:length(spl)
    s = [s, gen_note(spl{i}, info);];
end
end

function v = gen_note(str, info)
%% tone frequency
tone_str = str(1:end - 2);
octave = (strfind('=-0+t', tone_str(1)) - 3) * 12;
freq1 = [0, 2, 4, 5, 7, 9, 11];
freq2 = [1, 3, 6, 8, 10];
if length(tone_str) == 2
    freq_exp = octave + freq1(strfind('1234567', tone_str(2)));
elseif length(tone_str) == 3
    freq_exp = octave + freq2(strfind('12456', tone_str(2)));
end
f = info.f0 * 2^(freq_exp / 12);
%% note duration
len_str = str(end - 1:end);
mult = str2num(len_str(1)) * 2^strfind('seqhwdf', len_str(2));
T1 = 60 / info.beats_pm;
vec_t16 = [0:1 / info.fs:T1 / 16];
vt = linspace(0, T1 / 16 * mult, mult * length(vec_t16));
%% amplitude modulation
am = sin(pi * vt / vt(end));
%% generate note
v = am .* cos(2 * pi * f * vt);
end