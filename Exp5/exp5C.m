%% IV 1
load('vowels.mat');
sp_A = positiveSpectrum(vowel_a);
N = length(sp_A);
w_vector = linspace(0,pi,N/2);
plot(w_vector,mag2db(sp_A(1:N/2)))
title('Espectro de vocal a');xlabel('Frecuencia Rad/muestra');ylabel('Amplitud dB');

%% IV 2
fs=8000;
N=fs;
Np=80;
X = exciteV(N,Np);
a = lpc(vowel_a,15);
a_sint = filter(1,a,X);

u = lpc(vowel_u,15);
u_sint = filter(1,u,X);

a2 = lpc(vowel_a,2);
a2_sint = filter(1,a2,X);

u2 = lpc(vowel_u,2);
u2_sint = filter(1,u2,X);

w_vector = linspace(0,pi,length(sp_A));

figure
sp_U = positiveSpectrum(vowel_u);
[ulpc,~] = freqz(1,u,8001);
[ulpc2,~] = freqz(1,u2,8001);
hold on
plot(w_vector,mag2db(sp_U))
plot(w_vector,mag2db(abs(ulpc)),'LineWidth',2)
plot(w_vector,mag2db(abs(ulpc2)),'LineWidth',2)
title('Espectro de vocal U');xlabel('Frecuencia Rad/muestra');ylabel('Amplitud dB');
legend("Espectro vocal U","LPC orden 15","LPC orden 2");

figure
sp_A = positiveSpectrum(vowel_a);
[alpc,~] = freqz(1,a,8001);
[alpc2,~] = freqz(1,a2,8001);
hold on
plot(w_vector,mag2db(sp_A))
plot(w_vector,mag2db(abs(alpc)),'LineWidth',2)
plot(w_vector,mag2db(abs(alpc2)),'LineWidth',2)
title('Espectro de vocal A');xlabel('Frecuencia Rad/muestra');ylabel('Amplitud dB');
legend("Espectro vocal A","LPC orden 15","LPC orden 2");

%% zplane
figure
subplot 221
zplane(1,a)
title('zplane filtro vocal a orden 15');
subplot 222
zplane(1,a2)
title('zplane filtro vocal a orden 2');
subplot 223
zplane(1,u)
title('zplane filtro vocal u orden 15');
subplot 224
zplane(1,u2)
title('zplane filtro vocal u orden 2');

%% IV 3 a
load('vowels.mat');
chosen_vowel = vowel_a;
p1=15;
p2=9;
X = exciteV(fs*0.5,fs/100);

lpc1=lpc(chosen_vowel,p1);
lpc2=lpc(chosen_vowel,p2);

vowel_sint_1 = filter(1,lpc1,X);
vowel_sint_2 = filter(1,lpc2,X);
w1 = linspace(-pi,pi,length(chosen_vowel));
w2 = linspace(-pi,pi,length(X));
soundsc(vowel_sint_1,fs)
pause(1)
soundsc(vowel_sint_2,fs)
figure
plot(w1, mag2db(abs(fft(chosen_vowel))))
hold on
plot(w2, mag2db(abs(fft(vowel_sint_1))))
plot(w2, mag2db(abs(fft(vowel_sint_2))))
title('Magnitud del espectro vocal a sintetizada');xlabel('Frecuencia Rad/muestra');ylabel('amplitud dB');
legend('vocal a','Vocal sintetizada filtro orden 15','Vocal sintetizada filtro orden 9')

figure
subplot 121
zplane(1,lpc1);
title('zplane filtro vocal a orden 15');
subplot 122
zplane(1,lpc2);
title('zplane filtro vocal a orden 9');
%% IV 3 u
load('vowels.mat');
chosen_vowel = vowel_u;
p1=15;
p2=11;
X = exciteV(fs*0.5,fs/100);

lpc1=lpc(chosen_vowel,p1);
lpc2=lpc(chosen_vowel,p2);

vowel_sint_1 = filter(1,lpc1,X);
vowel_sint_2 = filter(1,lpc2,X);
w1 = linspace(-pi,pi,length(chosen_vowel));
w2 = linspace(-pi,pi,length(X));
soundsc(vowel_sint_1,fs)
pause(1)
soundsc(vowel_sint_2,fs)
figure
plot(w1, mag2db(abs(fft(chosen_vowel))))
hold on
plot(w2, mag2db(abs(fft(vowel_sint_1))))
plot(w2, mag2db(abs(fft(vowel_sint_2))))
title('Magnitud del espectro vocal u sintetizada');xlabel('Frecuencia Rad/muestra');ylabel('amplitud dB');
legend('vocal u','Vocal sintetizada filtro orden 15','Vocal sintetizada filtro orden 9')

figure
subplot 121
zplane(1,lpc1);
title('zplane filtro vocal u orden 15');
subplot 122
zplane(1,lpc2);
title('zplane filtro vocal u orden 11');
%% IV 4
load('vowels.mat');
chosen_vowel = vowel_a;
p1=15;
X = exciteV(fs*0.5,fs/100);
lpc1=lpc(chosen_vowel,p1);
bqds = tf2sos(1,lpc1);

[bq1,~] = freqz(bqds(2,1:3),bqds(2,2:6),8001);
[bq2,~] = freqz(bqds(3,1:3),bqds(3,2:6),8001);
[bq3,~] = freqz(bqds(4,1:3),bqds(4,2:6),8001);
[bq4,~] = freqz(bqds(5,1:3),bqds(5,2:6),8001);
[bq5,~] = freqz(bqds(6,1:3),bqds(6,2:6),8001);
[bq6,~] = freqz(bqds(7,1:3),bqds(7,2:6),8001);
[bq7,~] = freqz(bqds(8,1:3),bqds(8,2:6),8001);

w = linspace(0,pi,8001);

plot(w, mag2db(positiveSpectrum(chosen_vowel)),'color','y')
hold on
plot(w, mag2db(abs(bq1)),'linewidth',2)%,'color','g')
plot(w, mag2db(abs(bq2)),'linewidth',2)%,'color','g')
plot(w, mag2db(abs(bq3)),'linewidth',2)%,'color','g')
plot(w, mag2db(abs(bq4)),'linewidth',2)%)%,'color','g')
plot(w, mag2db(abs(bq5)),'linewidth',2)%,'color','g')
plot(w, mag2db(abs(bq6)),'linewidth',2)%,'color','g')
plot(w, mag2db(abs(bq7)),'linewidth',2)%,'color','g')
title('Magnitud Filtro Bq vs Vocal a');ylabel('Amplitud dB');xlabel('Frecuencia Rad/muestra');
legend('bq 2','bq 3','bq 4','bq 5','bq 6','bq 7','bq 8');

%% V 1
load('vowels.mat');
lpccoef = lpc(vowel_a,15);
[h1,w1] = freqz(lpccoef,1,8001);
[h2,w2] = freqz(1,lpccoef,8001);
plot(w1,abs(h1))
hold on
plot(w2,abs(h2))

%% V 2
residuo = filter(lpccoef,1,vowel_a);
plot(residuo)

%% V 3
figure
plot(positiveSpectrum(residuo))
figure
plot(positiveSpectrum(vowel_a))

%% V 4
cor = xcorr(residuo);
cor2 = xcorr(vowel_a);
plot(-1000:1000,cor(15000:17000))
plot(-1000:1000,cor2(15000:17000))
%% Funciones

function Y = positiveSpectrum(X)
Spectrum = abs(fft(X));
Y = Spectrum(1:floor(length(X)/2)+1);
end

function X = exciteV (N, Np)
  for i=1:1:N
    if mod(i-1,Np) == 0
      X(i)=1;
    else
      X(i)=0;
    end
  end
 end
