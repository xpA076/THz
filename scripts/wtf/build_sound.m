function s = build_sound(str, info)
spl = strsplit(str, {',', '|', '~'});
s = [];
for i = 1:length(spl)
    try
        [vt, note] = gen_note(spl{i}, info);
        s = [s, note];
    catch exception
        spl{i}
        i
    end
end

end


function [vt, v] = gen_note(str, info)
if length(str) == 0
    v = [];
    return;
end
%% tone frequency
tone_str = str(1:end - 2);
octave = (strfind('=-0+t', tone_str(1)) - 3) * 12;
freq1 = [0, 2, 4, 5, 7, 9, 11, 0];
freq2 = [1, 3, 6, 8, 10];
if length(tone_str) == 2
    freq_exp = octave + freq1(strfind('12345670', tone_str(2)));
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
if tone_str(2) == '0'
    sgn = 0;
else
    sgn = 1;
end
%% generate note
v = sgn * am .* cos(2 * pi * f * vt);
end