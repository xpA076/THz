sc = [
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...45
    'd-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h.',...46
    'A-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h.',...47
    'c-1h,g-1h,c1-1h,g-1h,D-1h,d-1h,a-1h,d-1h.',...48
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...49
    'd-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h.',...50
    'A-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h.',...51
    'c-1h,g-1h,c1-1h,d-9h.',...52
    ];
spl_score = strsplit(sc, {',', '.'});

for inote = 1:length(spl_score) - 1
    note1 = spl_score{inote};
    spl_note = split(note1, '&');
    % build single note (with multiple freqs)
    lspn = length(spl_note);
    for i = 1:lspn
        snote = spl_note(i);
        bn = parse_single_note(snote);
        % is continue or not
        if i < lspn
            bn = bn + 1;
        end
        bn1 = floor(bn / 2^12);
        bn2 = floor((bn - bn1 * 2^12) / 2^6);
        bn3 = mod(bn, 2^6);
        s_enc = [b64encode(bn1), b64encode(bn2), b64encode(bn3)];
        fprintf(s_enc);
    end
end
fprintf('\n');
% 18 bit (3 characters)
function bin_num = parse_single_note(snote)
spl = split(snote, '-');
freqi = parse_freq(spl{1});
[dm, typ] = parse_duration(spl{2});
bn = freqi * (2^5) + dm;
bn = bn * (2^6) + typ * 4;
bin_num = bn;
end

function freqi = parse_freq(frs)
%% blank note
if length(strfind(frs, 'N0')) > 0
    freqi = 0;
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
freqi = exp_bias + 37;
end

function [dm, typ] = parse_duration(drs)
dm = str2num(drs(1:end - 1));
db = [0.25, 0.5, 1, 2];
i = strfind('qhnd', drs(end));
typ = i - 1;
end
