function snd = build_sound(str, info)
spl = strsplit(str, {',', '|'});
snd = [];
[dt, t16, lt16] = get_base_variables(info);
for i = 1:length(spl)
    note_str = spl{i};
    try
        if length(strfind(note_str, '~')) == 0
            [f, m, s] = get_parameters(note_str, info);
            vt = linspace(dt, m * t16, m * lt16);
            note = s * sin(pi * vt / vt(end)) .* cos(2 * pi * f * vt);
        else
            spl2 = strsplit(note_str, '~');
            ms = [];
            note0 = [];
            end_phase = 0;
            for ii = 1:length(spl2)
                note_str_single = spl2{ii};
                [f, m, s] = get_parameters(note_str_single, info);
                vt0 = linspace(dt, m * t16, m * lt16);
                ms = [ms, m];
                note0 = [note0, s * cos(2 * pi * f * vt0 + end_phase)];
%                 plot(note0);hold on;
                end_phase = end_phase + 2 * pi * f * (vt0(end));
            end
            sum_m = sum(ms);
            vt = linspace(0, sum_m * t16, sum_m * lt16);
            note = sin(pi * vt / vt(end)) .* note0;
        end
        
        
%         [vt, note] = gen_note(spl{i}, info);
        snd = [snd, note];
    catch exception
        spl{i}
        i
    end
end

end

function [dt, t16, lt16] = get_base_variables(info)
dt = 1 / info.fs;
t16 = 60 / info.beats_pm / 16;
v_t16 = [0:dt:t16];
lt16 = length(v_t16);
end


function [freq, mult, signal] = get_parameters(str, info)
freq = get_frequency(str, info);
mult = get_duration(str, info);
if str(2) == '0'
    signal = 0;
else
    signal = 1;
end
end


function freq = get_frequency(str, info)
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
freq = info.f0 * 2^(freq_exp / 12);
end

function mult = get_duration(str, info)
len_str = str(end - 1:end);
mult = str2num(len_str(1)) * 2^strfind('seqhwdf', len_str(2));
end

% 
% function [vt, v] = gen_note(str, info)
% if length(str) == 0
%     v = [];
%     return;
% end
% %% tone frequency
% tone_str = str(1:end - 2);
% octave = (strfind('=-0+t', tone_str(1)) - 3) * 12;
% freq1 = [0, 2, 4, 5, 7, 9, 11, 0];
% freq2 = [1, 3, 6, 8, 10];
% if length(tone_str) == 2
%     freq_exp = octave + freq1(strfind('12345670', tone_str(2)));
% elseif length(tone_str) == 3
%     freq_exp = octave + freq2(strfind('12456', tone_str(2)));
% end
% f = info.f0 * 2^(freq_exp / 12);
% %% note duration
% len_str = str(end - 1:end);
% mult = str2num(len_str(1)) * 2^strfind('seqhwdf', len_str(2));
% T1 = 60 / info.beats_pm;
% vec_t16 = [0:1 / info.fs:T1 / 16];
% vt = linspace(0, T1 / 16 * mult, mult * length(vec_t16));
% %% amplitude modulation
% am = sin(pi * vt / vt(end));
% if tone_str(2) == '0'
%     sgn = 0;
% else
%     sgn = 1;
% end
% %% generate note
% v = sgn * am .* cos(2 * pi * f * vt);
% end