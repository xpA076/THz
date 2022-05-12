function y = build_sound(s, bpm, pianod)
%% parameters
fs = 44100;
dt = 1 / fs;
y = [];
dtb = 60 / bpm;

%% data
spl_score = strsplit(s, {',', '.'});
pt = 0;

%% build y
sound_mix_ratio = [0.8, 0.5, 0.4];
for inote = 1:length(spl_score) - 1
    N_pt = round(pt / dt);
    note1 = spl_score{inote};
    spl_note = split(note1, '&');
    % build single note (with multiple freqs)
    lspn = length(spl_note);
    for i = 1:lspn
        snote = spl_note(i);
        [fr, dr] = parse_single_note(snote);
        % build single freq
        if fr > 0
            yn = generate_piano_note(fr, pianod);
            lyn = length(yn);
            reqlen = N_pt + lyn - length(y);
            % extend y
            if reqlen > 0
                y = [y; zeros(reqlen, 1)];
            end
            y(N_pt + 1:N_pt + lyn) = y(N_pt + 1:N_pt + lyn) + ...
                sound_mix_ratio(lspn) * yn;
        end
    end
    pt = pt + dr * dtb;
end

end

function [freq, duration] = parse_single_note(snote)
spl = split(snote, '-');
freq = parse_freq(spl{1});
duration = parse_duration(spl{2});
end

function freq = parse_freq(frs)
%% blank note
if length(strfind(frs, 'N0')) > 0
    freq = 0;
    return
end

%% half note
exp_add = 0;
if frs(end) == '#'
    exp_add = 1;
    frs = frs(1:end - 1);
elseif frs(end) == 'l'
    exp_add = -1;
    frs = frs(1:end - 1);
end
 
%% find range
exp_bias = -9;
if frs(1) >= 'A' & frs(1) <= 'G'
    if length(frs) == 1
        exp_bias = exp_bias - 24;
    elseif frs(2) == '1'
        exp_bias = exp_bias - 36;
    elseif frs(2) == '2'
        exp_bias = exp_bias - 48;
    end
else
    if length(frs) == 1
        exp_bias = exp_bias - 12;
    elseif frs(2) == '1'
        exp_bias = exp_bias + 0;
    elseif frs(2) == '2'
        exp_bias = exp_bias + 12;
    elseif frs(2) == '3'
        exp_bias = exp_bias + 24;
    elseif frs(2) == '4'
        exp_bias = exp_bias + 36;
    end
end

%% find note
fb = [0, 2, 4, 5, 7, 9, 11];
i = strfind('cdefgab', lower(frs(1)));
exp_bias = exp_bias + fb(i) + exp_add;
freq = 440 * 2^(exp_bias / 12);
end

function duration = parse_duration(drs)
m = str2num(drs(1:end - 1));
db = [0.25, 0.5, 1, 2];
i = strfind('qhnd', drs(end));
duration = m * db(i);
end
