%% I.2
fs = 5000;
t=0:1/fs:0.1-1/fs;
s1 = cos(2*pi*100*t);
s2 = sin(2*pi*100*t);

f1 = fft(s1);
f2 = fft(s2);
w1 = linspace(-fs/2,fs/2,500);
w2 = linspace(0,fs,500);
subplot 221
plot(w1,fftshift(f1))
subplot 222
plot(w1,fftshift(abs(f2)))
subplot 223
plot(w2,f1)
subplot 224
plot(w2,abs(f2))
%% I.3
fs = 5000;
t=0:1/fs:0.1-1/fs;
s1 = cos(2*pi*100*t);
s2 = sin(2*pi*100*t);

f1_256 = fft(s1,256);
f2_256 = fft(s2,256);

f1_500 = fft(s1,500);
f2_500 = fft(s2,500);

f1_2048 = fft(s1,2048);
f2_2048 = fft(s2,2048);

w1_256 = linspace(-pi,pi,256);
w2_256 = linspace(0,2*pi,256);

w1_500 = linspace(-pi,pi,500);
w2_500 = linspace(0,2*pi,500);

w1_2048 = linspace(-pi,pi,2048);
w2_2048 = linspace(0,2*pi,2048);

%% Magnitudes
subplot 321
plot(w1_256,abs(f1_256))

subplot 323
plot(w1_500,abs(f1_500))

subplot 325
plot(w1_2048,abs(f1_2048))

subplot 322
plot(w1_256,abs(f2_256))

subplot 324
plot(w1_500,abs(f2_500))

subplot 326
plot(w1_2048,abs(f2_2048))

%% Partes Reales
subplot 321
plot(w1_256,real(f1_256))

subplot 323
plot(w1_500,real(f1_500))

subplot 325
plot(w1_2048,real(f1_2048))

subplot 322
plot(w1_256,real(f2_256))

subplot 324
plot(w1_500,real(f2_500))

subplot 326
plot(w1_2048,real(f2_2048))

%% Partes Reales
subplot 321
plot(w1_256,imag(f1_256))

subplot 323
plot(w1_500,imag(f1_500))

subplot 325
plot(w1_2048,imag(f1_2048))

subplot 322
plot(w1_256,imag(f2_256))

subplot 324
plot(w1_500,imag(f2_500))

subplot 326
plot(w1_2048,imag(f2_2048))

%% II
fs = 5000;
t=0:1/fs:0.1-1/fs;
senal = 0.5*cos(2*pi*100*t)+1.5*cos(2*pi*500*t)+(sqrt(2)*randn(1,500));
y=fft(senal);
w=linspace(0,fs,500);
plot(w(1:100),abs(y(1:100)));
%% dB
plot(w(1:100),20*log10(abs(y(1:100)))-max(20*log10(abs(y(1:100)))) );
%% duracion 1
fs = 5000;
t=0:1/fs:1-1/fs;
senal = 0.5*cos(2*pi*100*t)+1.5*cos(2*pi*500*t)+(sqrt(2)*randn(1,5000));
y=fft(senal);
w=linspace(0,fs,5000);
%plot(w(1:1000),abs(y(1:1000)));
plot(w(1:1000),20*log10(abs(y(1:1000)))-max(20*log10(abs(y(1:1000)))) );

%% III
load('nspeech.mat');
fft_senal = fft(nspeech);
w_vector = linspace(0,fs,length(fft_senal));
%plot(w_vector,fft_senal)
f=1685.15;
w=2*pi*f/fs;
filtro=1-2*cos(w)*exp(-j*2*pi*(w_vector)/fs)+exp(-2*j*2*pi*(w_vector)/fs);
plot(w_vector,abs(filtro))
fft_filtrada = fft_senal.*filtro;
plot(w_vector,fft_filtrada)
senal_filtrada = ifft(fft_filtrada,"symmetric");

%% IV