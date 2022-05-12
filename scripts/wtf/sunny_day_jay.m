bpm = 68;
fs = 44100;
[t, b] = build_melody();
yt = build_sound(t, bpm, pianod);
yb = build_sound(b, bpm, pianod);
y = zeros(max([length(yt), length(yb)]), 1);
y(1:length(yt)) = y(1:length(yt)) + yt;
y(1:length(yb)) = y(1:length(yb)) + yb;
sound(y / max(y), 44100)

function [t, b] = build_melody()
t1to16 = [
    'N0-1h,g1-1h,d2-1h,g1-1h,N0-1h,d1-1h,d2-1h,g1-1h.',...1
    'N0-1h,d1-1h,d2-1h,g1-1h,d1-1h,d2-1h,d1-1h,a1-1h.',...2
    'N0-1h,g1-1h,d2-1h,g1-1h,N0-1h,d1-1h,d2-1h,g1-1h.',...3
    'N0-1h,d1-1h,d2-1h,g1-1h,d1-1h,g1-1h,a1-1h,d1-1h.',...4
    'N0-1h,g1-1h,d2-1h,g1-1h,N0-1h,d1-1h,d2-1h,g1-1h.',...5
    'N0-1h,d1-1h,d2-1h,g1-1h,d1-1h,d2-1h,d1-1h,a1-1h.',...6
    'N0-1h,g1-1h,d2-1h,g1-1h,N0-1h,d1-1h,d2-1h,g1-1h.',...7
    'N0-1h,d1-1h,d2-1h,g1-1h,d1-1h,g1-1h,a1-1h,d1-1h.',...8
    'N0-1h,d2-1h,d2-1h,g1-1h,g1-1n,a1-1h,b1-3h.',...9
    'd2-1h,d2-1h,g1-1h,g1-1h,a1-1q,b1-1q,a1-1h,g1-1h.',...10
    'N0-1h,d2-1h,d2-1h,g1-1h,g1-1h,a1-1h,b1-3h.',...11
    'b1-1n,b1-1h,c2-1q,b1-1q,a1-1q,c2-1q,b1-1h,g1-1h.',...12
    'N0-1h,e1-1h&b1-1h,e1-1h&b1-1h,e1-1h&b1-1h,e1-1h&c2-1h,b1-1h,e1-1h&a1-1h,g1-1q,a1-1q.',...13
    'd1-1h&b1-1h,d1-1h&b1-1h,d1-1h&b1-1h,d1-1h&b1-1h,a1-1q,b1-1q,d1-1h&a1-1h,d1-1n&g1-1n.',...14
    'e1-1h,f1#-1h,g1-1h,b1-1h,e1-1h&c2-1h,b1-1h,a1-1h,g1-1q,a1-1q.',...15
    'd1-1h&b1-1h,d1-1h&b1-1h,d1-1h&b1-1h,d1-1h&b1-1h,a1-1q,b1-1q,d1-1h&a1-1h,d1-1n&g1-1n.',...16
    ];
b1to16 = [
    'e-1d,c-1d.g-1d,g-1n,f#-1n.e-1d,c-1d.g-1d,g-1n,f#-1n.', ...1-4
    'E-1h,B-1h,g-1h,c-1h,C-1h,G-1h,e-1h,G-1h.',...5
    'G-1h,d-1h,b-1h,d-1h,G-1h,d-1h,F#-1n&f#-1n.',...6
    'E-1h,B-1h,g-1h,c-1h,C-1h,G-1h,e-1h,G-1h.',...7
    'G-1h,d-1h,b-1h,d-1h,G-1h,d-1h,F#-1h&f#-1h,d-1h.',...8
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,g-1h,e-1h.',...9
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,F#-1h&f#-1h,d-1h.',...10
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,g-1h,e-1h.',...11
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,F#-1h&f#-1h,d-1h.',...12
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,g-1h,e-1h.',...13
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,F#-1h&f#-1h,d-1h.',...14
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,g-1h,e-1h.',...15
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,F#-1h&f#-1h,d-1h.',...16
    ];
t17to40 = [
    'b-1n&g1-1n,N0-1q,b-1q,b-1q&g1-1q,f1#-1q,c1-1h&g1-1h,c1-1q,c1-1q&g1-1q,c1-3q&g1-3q,f1#-1q.',...17
    'd1-1n&g1-1n,N0-1q,d1-1q,g1-1q,a1-1q,d1-1q&a1-1q,b1-1h,d1-1q&d2-1q,d1-1q&d2-1q,d1-1h,d1-1q&a1-1q.',...18
    'g1-1n&d2-1n,N0-1q,d1-1h,g1-1q&d2-1q,g1-1q&d2-1q,d1-1h,g1-1q&d2-1q,g1-1q&d2-1q,c2-1q,b1-1q,a1-1q.',...19
    'b1-3h,d1-1h,d1-1h&g1-1h,d1-1h,d1-1h&g1-1h,g1-1q,f1#-1q.',...20
    'e1-1h,f1#-1h,g1-1h,d2-1h,c2-1h,b1-1h,g1-1h,g1-5h.',...21
    'N0-1h,d1-1h,g1-1h,f1#-1h.',...22
    'e1-1h,f1#-1h,g1-1h,d2-1h,c2-1h,b1-1h,g1-1h,a1-3h.',...23
    'd1-1h,g1-1h,d1-1h&f1#-1h&a1-1h,d1-1h&f1#-1h&d2-1h.',...24
    'b1-1h,a1-1h,c2-1h,b1-1n,g1-1h,d2-1h,f2#-1h.',...25
    'g2-1h,f2#-1h,d2-1h,g1-1n,g1-1h,e2-1h,e2-1n.',...26
    'e2-1h,d2-1h,d2-1n,d2-1h,c2-1h,b1-1h.',...27
    'a1-1h,b1-1h,c2-1h,b1-5h.',...28
    'b1-1h,c2#-1h,d2#-1h,b1-1n,c2-1h,d2-1h,f2#-1h.',...29
    'a2-1h,f2#-1h,g2-1h,g2-3h,N0-1h,g2-1h.',...30
    'g2-1h,d2-1h,d2-1h,e2-1h,d2-1h,c2-1h,a1-1h,b1-1h.',...31
    'c2-1h,d2-1h,e2-1h,g1-1h,e2-1n,f2#-1n.',...32
    'b1-1h,a1-1h,c2-1h,b1-1n,g1-1h,d2-1h,f2#-1h.',...33
    'g2-1h,f2#-1h,d2-1h,g1-1n,g1-1h,e2-1h,e2-1n.',...34
    'e2-1h,d2-1h,d2-1n,d2-1h,c2-1h,b1-1h.',...35
    'a1-1h,b1-1h,c2-1h,b1-5h.',...36
    'b1-1h,c2#-1h,d2#-1h,b1-1n,c2-1h,d2-1h,f2#-1h.',...37
    'a2-1h,f2#-1h,g2-1h,g2-3h,N0-1h,g2-1h.',...38
    'g2-1h,d2-1h,d2-1h,e2-1h,d2-1h,c2-1h,e1-1h,f1#-1h.',...39
    'g1-1h,a1-1h,b1-1h,a1-3h,b1-1h,a1-1h.',...40
    ];
b17to40 = [
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,c-1h&g-1h,e-1h.',...17
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,F#-1h&f#-1h,d-1h.',...18
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,c-1h&g-1h,e-1h.',...19
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,F#-1h&f#-1h,d-1h.',...20
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,g-1h,e-1h.',...21
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,F#-1h&f#-1h,d-1h.',...22
    'E-1h,B-1h,g-1h,c-1h,C-1h,c-1h,g-1h,e-1h.',...23
    'D-1h,d-1h,a-1h,d-1h,D-1h,d-1h,a-1h,d-1h.',...24
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...25
    'E-1h,B-1h,g-1h,B-1h,g-1h,B-1h,g-1h,B-1h.',...26
    'C-1h,G-1h,e-1h,G-1h,D-1h,A-1h,f#-1h,A-1h.',...27
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...28
    'B1-1h,B-1h,a-1h,f#-1h,B-1h,f#-1h,d1#-1h,f#-1h.',...29
    'E-1h,B-1h,g-1h,B-1h,D-1h,B-1h,g-1h,B-1h.',...30
    'C-1h,G-1h,e-1h,G-1h,e-1h,G-1h,e-1h,G-1h.',...31
    'D-1h,A-1h,f#-1h,A-1h,f#-1h,A-1h,f#-1h,A-1h.',...32
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...33
    'E-1h,B-1h,g-1h,B-1h,g-1h,B-1h,g-1h,B-1h.',...34
    'C-1h,G-1h,e-1h,G-1h,D-1h,A-1h,f#-1h,A-1h.',...35
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...36
    'B1-1h,B-1h,a-1h,f#-1h,B-1h,f#-1h,d1#-1h,f#-1h.',...37
    'E-1h,B-1h,g-1h,B-1h,D-1h,B-1h,g-1h,B-1h.',...38
    'C-1h,G-1h,e-1h,G-1h,e-1h,G-1h,e-1h,G-1h.',...39
    'D-1h,A-1h,f#-1h,A-1h,f#-1h,A-1h,f#-1h,A-1h.',...40
    ];
t41to44 = [
    'g1-1n,d2-1h,g1-1n,d1-1h,d2-1h,g1-1q,a1-1q.',...41
    'g1-1n,d2-1h,g1-1n,d2-1h,g2-1h,f2#-1h.',...42
    'd2-1n,d2-1h,g1-1n,d1-1h,g1-1h,a1-1h.',...43
    'g1-1n,g1-1h&d2-1h,g1-1n,d1-1h,d1-1h&a1-1h,g1-1q,f1#-1q.',...44
    ];
b41to44 = [
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...41
    'd-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h.',...42
    'A-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h.',...43
    'c-1h,g-1h,c1-1h,g-1h,D-1h,d-1h,a-1h,d-1h.',...44
    ];
t45to52 = [
    'g1-1n,d2-1h,g1-1n,d1-1h,d2-1h,g1-1q,a1-1q.',...45
    'g1-1n,d2-1h,g1-1n,d2-1h,g2-1h,f2#-1h.',...46
    'd2-1n,d2-1h,g1-1n,d1-1h,g1-1h,a1-1h.',...47
    'g1-1n,g1-1h&d2-1h,g1-1n,d1-1h,d1-1h&a1-1h,g1-1q,f1#-1q.',...48
    'g1-1n,d2-1h,g1-1n,d1-1h,d2-1h,g1-1q,a1-1q.',...49
    'g1-1n,d2-1h,g1-1n,d2-1h,g2-1h,f2#-1h.',...50
    'd2-1n,d2-1h,g1-1n,d1-1h,g1-1h,a1-1h.',...51
    'g1-1n,g1-1h&d2-1h,a1-9h.',...52
    ];
b45to52 = [
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...45
    'd-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h.',...46
    'A-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h.',...47
    'c-1h,g-1h,c1-1h,g-1h,D-1h,d-1h,a-1h,d-1h.',...48
    'G-1h,d-1h,b-1h,d-1h,b-1h,d-1h,b-1h,d-1h.',...49
    'd-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h,e1-1h,g-1h.',...50
    'A-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h,c1-1h,e-1h.',...51
    'c-1h,g-1h,c1-1h,d-9h.',...52
    ];
t = [t1to16, t17to40, t41to44, t17to40, t45to52];
b = [b1to16, b17to40, b41to44, b17to40, b45to52];
end
