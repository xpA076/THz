function ret = the_sun_also_rises()
fs = 44100;
dt = 1 / fs;

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

end


