%% IV 1
load('vowels.mat');
sp_A = positiveSpectrum(vowel_a);
w_vector = linspace(0,pi,length(sp_A));
plot(w_vector,sp_A)

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
plot(w_vector,mag2db(abs(ulpc)))
plot(w_vector,mag2db(abs(ulpc2)))

figure
sp_A = positiveSpectrum(vowel_a);
[alpc,~] = freqz(1,a,8001);
[alpc2,~] = freqz(1,a2,8001);
hold on
plot(w_vector,mag2db(sp_A))
plot(w_vector,mag2db(abs(alpc)))
plot(w_vector,mag2db(abs(alpc2)))

%% zplane
figure
zplane(1,a)
figure
zplane(1,a2)
figure
zplane(1,u)
figure
zplane(1,u2)

%% IV 3 
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
figure
zplane(1,lpc1);
figure
zplane(1,lpc2);

%% IV 3 2
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

plot(w, mag2db(positiveSpectrum(chosen_vowel)))
hold on
plot(w, mag2db(abs(bq1)),'linewidth',2,'color','g')
plot(w, mag2db(abs(bq2)),'linewidth',2,'color','g')
plot(w, mag2db(abs(bq3)),'linewidth',2,'color','g')
plot(w, mag2db(abs(bq4)),'linewidth',2,'color','g')
plot(w, mag2db(abs(bq5)),'linewidth',2,'color','g')
plot(w, mag2db(abs(bq6)),'linewidth',2,'color','g')
plot(w, mag2db(abs(bq7)),'linewidth',2,'color','g')

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
