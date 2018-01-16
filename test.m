n=0:1000;
t=n./100;
f0=1/(t(2)-t(1));
y=sin(t.*(2*pi))+sin(t.*(4*pi))+sin(t.*(6*pi));

for i=(length(n)+1):(length(n)+10000)
    y(i)=0;
end
fft_y=fft(y);
fft_y=fft_y(1:floor(length(y)/2));

f=0:(length(y)/2-1);
f=f.*(f0/length(y));
plot(f,abs(fft_y));