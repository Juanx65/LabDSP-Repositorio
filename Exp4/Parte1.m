%% I.2
fs = 5000;
t=0:1/fs:0.1-1/fs;
s1 = cos(2*pi*100*t);
s2 = sin(2*pi*100*t);

f1 = fft(s1,4096);
f2 = fft(s2,4096);
w1 = linspace(-fs/2,fs/2,4096);
w2 = linspace(0,fs,4096);
subplot 221
plot(w1,fftshift(f1))
title('fft de x_2',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16)
ylim([-50,250]);
subplot 222
plot(w1,fftshift(abs(f2)))
title('fft de x_1',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16)
ylim([-50,250]);
subplot 223
plot(w2,f1)
title('fft de x_2',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16)
ylim([-50,250]);
subplot 224
plot(w2,abs(f2))
title('fft de x_1',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16)
ylim([-50,250]);
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
plot(w1_256,fftshift(abs(f1_256)),'LineWidth',2)
title('Magnitud vs Frecuencia de X_2 con N = 256',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([0,250]);

subplot 323
plot(w1_500,fftshift(abs(f1_500)),'LineWidth',2)
title('Magnitud vs Frecuencia de X_2 con N = 500',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([0,250]);

subplot 325
plot(w1_2048,fftshift(abs(f1_2048)),'LineWidth',2)
title('Magnitud vs Frecuencia de X_2 con N = 2048',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([0,250]);

subplot 322
plot(w1_256,fftshift(abs(f2_256)),'LineWidth',2)
title('Magnitud vs Frecuencia de X_1 con N = 256',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([0,251]);

subplot 324
plot(w1_500,fftshift(abs(f2_500)),'LineWidth',2)
title('Magnitud vs Frecuencia de X_1 con N = 500',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([0,251]);

subplot 326
plot(w1_2048,fftshift(abs(f2_2048)),'LineWidth',2)
title('Magnitud vs Frecuencia de X_1 con N = 2048',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([0,251]);

%% Partes Reales
subplot 321
plot(w1_256,fftshift(real(f1_256)),'LineWidth',2)
title('Real vs Frecuencia de X_2 con N = 256',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-250,255]);

subplot 323
plot(w1_500,fftshift(real(f1_500)),'LineWidth',2)
title('Real vs Frecuencia de X_2 con N = 500',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-250,255]);

subplot 325
plot(w1_2048,fftshift(real(f1_2048)),'LineWidth',2)
title('Real vs Frecuencia de X_2 con N = 2048',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-250,255]);

subplot 322
plot(w1_256,fftshift(real(f2_256)),'LineWidth',2)
title('Real vs Frecuencia de X_1 con N = 256',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-250,255]);

subplot 324
plot(w1_500,fftshift(real(f2_500)),'LineWidth',2)
title('Real vs Frecuencia de X_1 con N = 500',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-250,255]);

subplot 326
plot(w1_2048,fftshift(real(f2_2048)),'LineWidth',2)
title('Real vs Frecuencia de X_1 con N = 2048',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-250,255]);
%% Partes Imag
subplot 321
plot(w1_256,fftshift(imag(f1_256)),'LineWidth',2)
title('Imag vs Frecuencia de X_2 con N = 256',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-255,255]);

subplot 323
plot(w1_500,fftshift(imag(f1_500)),'LineWidth',2)
title('Imag vs Frecuencia de X_2 con N = 500',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-255,255]);

subplot 325
plot(w1_2048,fftshift(imag(f1_2048)),'LineWidth',2)
title('Imag vs Frecuencia de X_2 con N = 2048',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-255,255]);

subplot 322
plot(w1_256,fftshift(imag(f2_256)),'LineWidth',2)
title('Imag vs Frecuencia de X_1 con N = 256',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-255,255]);

subplot 324
plot(w1_500,fftshift(imag(f2_500)),'LineWidth',2)
title('Imag vs Frecuencia de X_1 con N = 500',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-255,255]);

subplot 326
plot(w1_2048,fftshift(imag(f2_2048)),'LineWidth',2)
title('Imag vs Frecuencia de X_1 con N = 2048',"FontSize",16);
xlabel('Frecuencia Rad/Muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
ylim([-255,255]);
%% II
fs = 5000;
t=0:1/fs:0.1-1/fs;
s_1 = 0.5*cos(2*pi*100*t)+1.5*cos(2*pi*500*t);
senal = s_1+(sqrt(2)*randn(1,500));
y=fft(senal);
y2=fft(s_1);
w=linspace(0,fs,500);

plot(w(1:100),abs(y(1:100)),'LineWidth',2);
hold on
plot(w(1:100),abs(y2(1:100)),'LineWidth',2);      
title('Magnitud de Señal Comparación',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16);
legend({'Señal Con ruido','Señal sin ruido'},'Location','northeast')

figure
plot(senal,'LineWidth',2);
title('Señal sumada a ruido en el tiempo',"FontSize",16);
xlabel('Tiempo ms',"FontSize",16);ylabel('Amplitud',"FontSize",16);
%% dB
plot(w(1:100),20*log10(abs(y(1:100)))-max(20*log10(abs(y(1:100)))),'LineWidth',2 );
hold on
plot(w(1:100),20*log10(abs(y2(1:100)))-max(20*log10(abs(y2(1:100)))),'LineWidth',2);
grid on
legend({'Señal Con ruido','Señal sin ruido'},'Location','northeast')
title('Magnitud de Señal en dB Comparación',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud dB',"FontSize",16);
%% duracion 1
fs = 5000;
t=0:1/fs:1-1/fs;
s_1 = 0.5*cos(2*pi*100*t)+1.5*cos(2*pi*500*t);
senal = s_1 +(sqrt(2)*randn(1,5000));
y=fft(senal);
y2 = fft(s_1);
w=linspace(0,fs,5000);
%plot(w(1:1000),abs(y(1:1000)));
plot(w(1:1000),20*log10(abs(y(1:1000)))-max(20*log10(abs(y(1:1000)))),'LineWidth',2 );
hold on
plot(w(1:1000),20*log10(abs(y2(1:1000)))-max(20*log10(abs(y2(1:1000)))),'-.','LineWidth',1.5 );
grid on
title('Magnitud de Señal en dB Comparación con duración de 1 segundo',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud dB',"FontSize",16);
legend({'Señal Con ruido','Señal sin ruido'},'Location','northeast')
%% III
load('nspeech.mat');
fft_senal = fft(nspeech);
w_vector = linspace(0,fs,length(fft_senal));
w_filtro = linspace(0,fs/2,length(fft_senal)/2);

plot(w_filtro,20*log10(fft_senal(1:length(fft_senal)/2)),'LineWidth',1.5 )
title('espectro nspeech',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud dB',"FontSize",16);

f=1685.4; 
w=2*pi*f/fs; %-> omega
filtro=1-2*cos(w)*exp(-j*2*pi*(w_vector)/fs)+exp(-2*j*2*pi*(w_vector)/fs);
figure

plot(w_filtro,20*log10(abs(filtro(1:length(fft_senal)/2))),'LineWidth',1.5);
title('Magnitud del filtro',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Magnitud dB',"FontSize",16);

fft_filtrada = fft_senal.*filtro;
figure

plot(w_filtro,20*log10(abs(fft_filtrada(1:length(fft_filtrada)/2))),'LineWidth',1.5 );
title('Magnitud del Señal filtrada',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud dB',"FontSize",16);

senal_filtrada = ifft(fft_filtrada,"symmetric");
t_vector = linspace(0,length(nspeech)/fs,length(nspeech));

figure
subplot 211
plot(t_vector,senal_filtrada,'LineWidth',1.5 );
title('Señal filtrada',"FontSize",16);
xlabel('Tiempo s',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 212
plot(t_vector,nspeech,'LineWidth',1.5 );
title('Señal con Original',"FontSize",16);
xlabel('Tiempo s',"FontSize",16);ylabel('Amplitud',"FontSize",16);

%% IV
x1 = [1 zeros([1,7])];
x2 = ones([1,8]);
x3 = zeros([1,8]);
x4 = zeros([1,8]);
w_vector = linspace(-pi,pi-2*pi/length(x1),length(x1));
k=0:7;
x3(k+1)=exp(-j*2*pi*k/8);
x4(k+1)=cos(2*pi*k/8);

dft1 = DFTsum(x1);
dft2 = DFTsum(x2);
dft3 = DFTsum(x3);
dft4 = DFTsum(x4);
%hay q hacerlo entre menos pi y pi
% errores
immse(dft1,fft(x1))
immse(dft2,fft(x2))
immse(dft3,fft(x3))
immse(dft4,fft(x4))
%plots
subplot 421
stem(w_vector,fftshift(abs(dft1)),'LineWidth',1.5 )
title('Magnitud de DFTsum( \delta [n] )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 422
stem(w_vector,fftshift(abs(fft(x1))),'LineWidth',1.5 )
title('Magnitud fft( \delta [n] )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 423
stem(w_vector,fftshift(abs(dft2)),'LineWidth',1.5 )
title('Magnitud de DFTsum( 1 ) ',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 424
stem(w_vector,fftshift(abs(fft(x2))),'LineWidth',1.5 )
title('Magnitud fft(1) ',"FontSize",16);
xlabel('Frecuecia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 425
stem(w_vector,fftshift(abs(dft3)),'LineWidth',1.5 )
title('Magnitud de DFTsum( exponencial ) ',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 426
stem(w_vector,fftshift(abs(fft(x3))),'LineWidth',1.5 )
title('Magnitud de fft(exponencial) ',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 427
stem(w_vector,fftshift(abs(dft4)),'LineWidth',1.5 )
title('Magnitud de DFTsum( coseno ) ',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 428
stem(w_vector,fftshift(abs(fft(x4))),'LineWidth',1.5 )
title('Magnitud de fft(coseno) ',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
%% 4.3
fs=5000;
t=0:1/fs:1-1/fs;
nvector=linspace(0,fs,500);
x1=cos(2*pi*100*t);
dft_cos=DFTsum(x1(1:500));
fft_cos=fft(x1(1:500));
stem(nvector,(abs(dft_cos)-abs(fft_cos)).^2,'LineWidth',1.5 )
title('Error entre DFTsum(x1) y fft(x1)',"FontSize",16);
xlabel('Frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16);
error_c=immse(dft_cos,fft_cos)
%% V
fs=5000;
t=0:1/fs:1-1/fs;
x1=cos(2*pi*100*t);
%X1=DFTmatrix(x1);
%% V 1
N = 2;
B=dftmtx(N);
A=genAmatrix(N);
immse(A,B)

%% V2
Matriz8 = genAmatrix(8);
dft8 = dftmtx(8);
error8 = immse(Matriz8,dft8);
Matriz64 = genAmatrix(64);
subplot 221
imagesc(real(Matriz8))
title('Parte Real N=8 ',"FontSize",16);
%xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 222
imagesc(imag(Matriz8))
title('Parte Imaginaria N=8 ',"FontSize",16);
%xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 223
imagesc(real(Matriz64))
title('Parte Real N=65 ',"FontSize",16);
%xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 224
imagesc(imag(Matriz64))
title('Parte Imaginaria N=64',"FontSize",16);
%xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);

%% V3
x1 = [1 zeros([1,7])];
x2 = ones([1,8]);
x3 = zeros([1,8]);
x4 = zeros([1,8]);
k=0:7;
x3(k+1)=exp(-j*2*pi*k/8);
x4(k+1)=cos(2*pi*k/8);
w_vector = linspace(-pi,pi,length(x1));

dft1 = DFTmatrix(x1);
dft2 = DFTmatrix(x2);
dft3 = DFTmatrix(x3);
dft4 = DFTmatrix(x4);

dft1s = DFTsum(x1);
dft2s = DFTsum(x2);
dft3s = DFTsum(x3);
dft4s = DFTsum(x4);

subplot 421
stem(w_vector,fftshift(abs(dft1)),'LineWidth',1.5 )
title('Magnitud de DFTmatrix( \delta [n] )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 422
stem(w_vector,fftshift(abs(fft(x1))),'LineWidth',1.5 )
title('Magnitud de fft( delta[n] )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 423
stem(w_vector,fftshift(abs(dft2)),'LineWidth',1.5 )
title('Magnitud de DFTmatrix( 1 )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 424
stem(w_vector,fftshift(abs(fft(x2))),'LineWidth',1.5 )
title('Magnitud de fft( 1 )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 425
stem(w_vector,fftshift(abs(dft3)),'LineWidth',1.5 )
title('Magnitud de DFTmatrix( exponencial )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 426
stem(w_vector,fftshift(abs(fft(x3))),'LineWidth',1.5 )
title('Magnitud de fft( exponencial )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 427
stem(w_vector,fftshift(abs(dft4)),'LineWidth',1.5 )
title('Magnitud de DFTmatrix( coseno )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 428
stem(w_vector,fftshift(abs(fft(x4))),'LineWidth',1.5 )
title('Magnitud de fft( coseno )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
error1=immse(dft1,fft(x1))
error2=immse(dft2,fft(x2))
error3=immse(dft3,fft(x3))
error4=immse(dft4,fft(x4))
error1s=immse(dft1,dft1s)
error2s=immse(dft2,dft2s)
error3s=immse(dft3,dft3s)
error4s=immse(dft4,dft4s)

fs=5000;
t=0:1/fs:1-1/fs;
x5=cos(2*pi*100*t);
nvector = linspace(-pi,pi,5000);

figure
subplot 211
stem(nvector,fftshift(abs(DFTmatrix(x5))),'LineWidth',1.5 )
title('Magnitud de DFTmatrix( coseno )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 212
stem(nvector,fftshift(abs(fft(x5))),'LineWidth',1.5 )
title('Magnitud de fft( coseno )',"FontSize",16);
xlabel('Frecuencia Rad/muestra',"FontSize",16);ylabel('Amplitud',"FontSize",16);
error5=immse(DFTmatrix(x5),fft(x5))
error5s=immse(DFTmatrix(x5),DFTsum(x5))

%% V.3
fs=5000;
t=0:1/fs:1-1/fs;
x1=cos(2*pi*100*t);
f1 = @()DFTsum(x1);
f2 = @()DFTmatrix(x1);
t1_0 = timeit(f1);
t2_0 = timeit(f2);
%%
fs=5000;
t=0:1/fs:1-1/fs;
t1=zeros([1,50]);
t2=zeros([1,50]);
t3=zeros([1,50]);
x5=cos(2*pi*100*t);
i=1;
for N=100:100:5000
    f1 = @()DFTsum(x5(1:N));
    f2 = @()DFTmatrix(x5(1:N));
    f3 = @()fft(x5(1:N));
    f4 = @()dftmtx(N);
    t1(i) = timeit(f1);
    t2(i) = timeit(f2);
    t3(i) = timeit(f3);
    t4(i) = timeit(f4);
    i=i+1;
end
%%
nvector = linspace(100,5000,50);
subplot 221
stem(nvector,t1,'LineWidth',1.5 )
title('Tiempo DFTsum',"FontSize",16);
xlabel('Muestras',"FontSize",16);ylabel('Tiempo s',"FontSize",16);
subplot 222
stem(nvector,t2,'LineWidth',1.5 )
title('Tiempo DFTmatrix',"FontSize",16);
xlabel('Muestras',"FontSize",16);ylabel('Tiempo s',"FontSize",16);
subplot 223
stem(nvector,t3,'LineWidth',1.5 )
title('Tiempo fft',"FontSize",16);
xlabel('Muestras',"FontSize",16);ylabel('Tiempo s',"FontSize",16);
subplot 224
stem(nvector,t4,'LineWidth',1.5 )
title('Tiempo dftmtx',"FontSize",16);
xlabel('Muestras',"FontSize",16);ylabel('Tiempo s',"FontSize",16);
%%
dftdc(x3)

%% VI
x1 = [1 zeros([1,7])];
x2 = ones([1,8]);
x3 = zeros([1,8]);
x4 = zeros([1,8]);
k=0:7;
x3(k+1)=exp(-j*2*pi*k/8);
x4(k+1)=cos(2*pi*k/8);

dft1 = dftdc(x1);
dft2 = dftdc(x2);
dft3 = dftdc(x3);
dft4 = dftdc(x4);
subplot 421
stem(abs(dft1),'LineWidth',1.5 )
title('Magnitud de dftdc( \delta [n] )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 422
stem(fft(x1),'LineWidth',1.5 )
title('Magnitud de fft( \delta [n] )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 423
stem((abs(dft2)),'LineWidth',1.5 )
title('Magnitud de dftdc( 1 )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 424
stem((abs(fft(x2))),'LineWidth',1.5 )
title('Magnitud de fft( 1 )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 425
stem(abs(dft3),'LineWidth',1.5 )
title('Magnitud de dftdc( exponencial )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 426
stem(abs(fft(x3)),'LineWidth',1.5 )
title('Magnitud de fft( exponencial )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 427
stem(abs(dft4),'LineWidth',1.5 )
title('Magnitud de dftdc( coseno )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 428
stem(abs(fft(x4)),'LineWidth',1.5 )
title('Magnitud de fft( coseno )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);

f1 = @()dftdc(x4);
t_dftdc = timeit(f1);
f2 = @()fft(x4);
t_fft = timeit(f2);

%% VI 2
x1 = [1 zeros([1,7])];
x2 = ones([1,8]);
x3 = zeros([1,8]);
x4 = zeros([1,8]);
k=0:7;
x3(k+1)=exp(-j*2*pi*k/8);
x4(k+1)=cos(2*pi*k/8);

dft1 = FFT8(x1);
dft2 = FFT8(x2);
dft3 = FFT8(x3);
dft4 = FFT8(x4);
subplot 421
stem(abs(dft1),'LineWidth',1.5 )
title('Magnitud de FFT8( \delta [n] )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 422
stem(fft(x1),'LineWidth',1.5 )
title('Magnitud de fft( \delta [n] )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 423
stem((abs(dft2)),'LineWidth',1.5 )
title('Magnitud de FFT8( 1 )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 424
stem((abs(fft(x2))),'LineWidth',1.5 )
title('Magnitud de fft( 1 )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 425
stem(abs(dft3),'LineWidth',1.5 )
title('Magnitud de FFT8( exponencial )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 426
stem(abs(fft(x3)),'LineWidth',1.5 )
title('Magnitud de fft( exponencial )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 427
stem(abs(dft4),'LineWidth',1.5 )
title('Magnitud de FFT8( coseno )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 428
stem(abs(fft(x4)),'LineWidth',1.5 )
title('Magnitud de fft( coseno )',"FontSize",16);
xlabel('Frecuencia bins',"FontSize",16);ylabel('Amplitud',"FontSize",16);

f1 = @()FFT8(x1);
t_fft8 = timeit(f1);
%% VI 3
fs=5000;
t=0:1/fs:3-1/fs;
nvector=linspace(0,fs,256);
x1=cos(2*pi*100*t);
fft_cos=fft(x1(1:256));
dft_cos=fft_stage(x1(1:256));
subplot 211
stem(nvector,(abs(dft_cos)),'LineWidth',1.5 );
title('Magnitud de la señal usando fft_stage',"FontSize",16);
xlabel('frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16);
subplot 212
stem(nvector,(abs(fft_cos)),'LineWidth',1.5 );
title('Magnitud de la señal usando fft de MATLAB',"FontSize",16);
xlabel('frecuencia Hz',"FontSize",16);ylabel('Amplitud',"FontSize",16);
f1 = @()fft_stage(x1(1:256));
t_stage = timeit(f1);
f1 = @()fft(x1(1:256));
t_fft = timeit(f1);
%% Funciones
function X=DFTsum(x) 
N = length(x);
X = zeros([1,N]);
for k=1:length(x)
    for n=1:length(x)
        X(k)=X(k)+x(n)*exp(-j*2*pi*(k-1)*(n-1)/N);
    end
end
end

function X=DFTmatrix(x)
N = length(x);
X = zeros([1,N]);
A = genAmatrix(N);
X = x*A;
end

function A=genAmatrix(N)
A = zeros([N,N]);
for k=1:N
    for n=1:N
    A(k,n)=exp(-2*j*pi*(k-1)*(n-1)/N);
    end
end
end

function X=dftdc(x)
x_par=zeros([1,ceil(length(x))*0.5]);
    for n=1:length(x)
        if mod(n,2)~=0
            x_par((n+1)/2)=x(n);
        end
    end
x_impar=zeros([1,ceil(length(x))*0.5]);
    for n=1:length(x)
        if mod(n,2)==0
            x_impar(n/2)=x(n);
        end
    end
X_par=DFTsum(x_par);
X_impar=DFTsum(x_impar);
k=0:length(X_impar)-1;
Wnk=exp(-j*2*pi*k/length(x));
X=[X_par+Wnk.*X_impar, X_par-Wnk.*X_impar];
end

function X = FFT8(x)
Wn = exp(-1j*2*pi/8);
X = zeros([1,8]);
x0 = [x(1) x(3) x(5) x(7)];
X0 = FFT4(x0);
x1 = [x(2) x(4) x(6) x(8)];
X1 = FFT4(x1);
    for k=1:4
        X(k) = X0(k)+Wn^(k-1)*X1(k);
        X(k+4) = X0(k)-Wn^(k-1)*X1(k);
    end
end

function X = FFT4(x)
Wn = exp(-1j*2*pi/4);
X = zeros([1,4]);
x0 = [x(1) x(3)];
X0 = FFT2(x0);
x1 = [x(2) x(4)];
X1 = FFT2(x1);
    for k=1:2
        X(k) = X0(k)+Wn^(k-1)*X1(k);
        X(k+2) = X0(k)-Wn^(k-1)*X1(k);
    end
end

function X = FFT2(x)
X(1) = x(1)+x(2);
X(2) = x(1)-x(2);
end

function X = fft_stage(x)
if length(x) == 2
    X =FFT2(x);
else
    x_par=zeros([1,ceil(length(x))*0.5]);
    for n=1:length(x)
        if mod(n,2)~=0
            x_par((n+1)/2)=x(n);
        end
    end
    x_impar=zeros([1,ceil(length(x))*0.5]);
    for n=1:length(x)
        if mod(n,2)==0
            x_impar(n/2)=x(n);
        end
    end
    X_par = fft_stage(x_par);
    X_impar = fft_stage(x_impar);
    
    k=0:length(X_impar)-1;
    Wnk=exp(-j*2*pi*k/length(x));
    X=[X_par+Wnk.*X_impar, X_par-Wnk.*X_impar];
end
end