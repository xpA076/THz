hlm = abs(pianod.hl);
hlm = hlm / max(hlm, [], 'all');
itg_hlm = ceil(hlm * 2^12) - 1;
for i2 = 1:size(hlm, 2)
    for i1 = 1:size(hlm, 1)
        d1 = floor(itg_hlm(i1, i2) / 2^6);
        d2 = mod(itg_hlm(i1, i2), 2^6);
        s_enc = [b64encode(d1), b64encode(d2)];
        fprintf(s_enc);
    end
    fprintf('\n');
end

