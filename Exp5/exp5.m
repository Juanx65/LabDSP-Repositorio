%% 1.1
fs=8000;
N=fs;
Np=80;
X = exciteV(N,Np);
t = 0:1/fs:1-1/fs;
Y = fft(X);
w = linspace(0,fs/2,N/2);
plot(w,abs(Y(1:N/2)));
figure
plot(w,20*log10(abs(Y(1:N/2)+10^(-30))));

%% 1.2
load('vowels.mat');
[vowels,fs] = audioread("vowel_a_16_8.wav");
filtro_a = lpc(vowel_a,15);
A=0;
w = linspace(0,fs,N);
for i=1:1:16
    A=A+filtro_a(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(A(1:N/2)));

filtro_e = lpc(vowel_e,15);
E=0;
w = linspace(0,fs,N);
for i=1:1:16
    E=E+filtro_e(i).*exp(-1j*2*pi*w*(i-1));
end
hold on
plot(w(1:N/2),abs(E(1:N/2)));

filtro_i = lpc(vowel_i,15);
I=0;
w = linspace(0,fs,N);
for i=1:1:16
    I=I+filtro_a(i).*exp(-1j*2*pi*w*(i-1));
end

plot(w(1:N/2),abs(I(1:N/2)));

filtro_o = lpc(vowel_o,15);
O=0;
w = linspace(0,fs,N);
for i=1:1:16
    O=O+filtro_o(i).*exp(-1j*2*pi*w*(i-1));
end

plot(w(1:N/2),abs(O(1:N/2)));

filtro_u = lpc(vowel_u,15);
U=0;
w = linspace(0,fs,N);
for i=1:1:16
    U=U+filtro_u(i).*exp(-1j*2*pi*w*(i-1));
end

plot(w(1:N/2),abs(U(1:N/2)));
legend("a","e","i","o","u");

%% 1.3
fs=8000;
N=fs;
Np=80;
X = exciteV(N,Np);
a = lpc(vowel_a,15);
a_sint = filter(1,a,X);
e = lpc(vowel_e,15);
e_sint = filter(1,e,X);
i = lpc(vowel_i,15);
i_sint = filter(1,i,X);
o = lpc(vowel_o,15);
o_sint = filter(1,o,X);
u = lpc(vowel_u,15);
u_sint = filter(1,u,X);

%% 1.4

fs=8000;
N=fs;
Np=80;
load('vowels.mat');
[vowels,fs] = audioread("vowel_a_16_8.wav");
filtro_a = mylpc(vowel_a,15);
A=0;
w = linspace(0,fs,N);
for i=1:1:16
    A=A+filtro_a(i).*exp(-1j*2*pi*w*(i-1));
end

plot(w(1:N/2),abs(A(1:N/2)));

filtro_e = mylpc(vowel_e,15);
E=0;
w = linspace(0,fs,N);
for i=1:1:16
    E=E+filtro_e(i).*exp(-1j*2*pi*w*(i-1));
end
hold on
plot(w(1:N/2),abs(E(1:N/2)));

filtro_i = mylpc(vowel_i,15);
I=0;
w = linspace(0,fs,N);
for i=1:1:16
    I=I+filtro_a(i).*exp(-1j*2*pi*w*(i-1));
end

plot(w(1:N/2),abs(I(1:N/2)));

filtro_o = mylpc(vowel_o,15);
O=0;
w = linspace(0,fs,N);
for i=1:1:16
    O=O+filtro_o(i).*exp(-1j*2*pi*w*(i-1));
end

plot(w(1:N/2),abs(O(1:N/2)));

filtro_u = mylpc(vowel_u,15);
U=0;
w = linspace(0,fs,N);
for i=1:1:16
    U=U+filtro_u(i).*exp(-1j*2*pi*w*(i-1));
end

plot(w(1:N/2),abs(U(1:N/2)));
legend("a","e","i","o","u");

%% 1.4 generar archivos de audio
fs=8000;
N=fs;
Np=80;
X = exciteV(N,Np);
a = mylpc(vowel_a,15);
a_sint = filter(1,a,X);
e = mylpc(vowel_e,15);
e_sint = filter(1,e,X);
i = mylpc(vowel_i,15);
i_sint = filter(1,i,X);
o = mylpc(vowel_o,15);
o_sint = filter(1,o,X);
u = mylpc(vowel_u,15);
u_sint = filter(1,u,X);

audiowrite("mylpc_vowel_a.wav",a_sint,fs);
audiowrite("mylpc_vowel_e.wav",e_sint,fs);
audiowrite("mylpc_vowel_i.wav",i_sint,fs);
audiowrite("mylpc_vowel_o.wav",o_sint,fs);
audiowrite("mylpc_vowel_u.wav",u_sint,fs);

%% 2
load('test_training_signals.mat');
plot(training_signal);
[x1,y1]=ginput;
hold on
plot(x1(1):x1(2),training_signal(x1(1):x1(2)),'color','red');
plot(x1(3):x1(4),training_signal(x1(3):x1(4)),'color','red');
plot(x1(5):x1(6),training_signal(x1(5):x1(6)),'color','red');
%[x2,y2]=ginput;
plot(x2(1):x2(2),training_signal(x2(1):x2(2)),'color','green');
plot(x2(3):x2(4),training_signal(x2(3):x2(4)),'color','green');
plot(x2(5):x2(6),training_signal(x2(5):x2(6)),'color','green');
plot(x2(7):length(training_signal),training_signal(x2(7):length(training_signal)),'color','green');

%% 2
silencio1 = training_signal(1:2000);
scatter(rms(silencio1),cruces_cero(silencio1));
hold on
s = training_signal(2001:3100);
scatter(rms(s),cruces_cero(s));
e = training_signal(3101:3750);
scatter(rms(e),cruces_cero(e));
n = training_signal(3751:4600);
scatter(rms(n),cruces_cero(n));
a = training_signal(4601:5350);
scatter(rms(a),cruces_cero(a));
l = training_signal(5351:6000);
scatter(rms(l),cruces_cero(l));
e2 = training_signal(6001:6900);
scatter(rms(e2),cruces_cero(e2));
s2 = training_signal(6901:8200);
scatter(rms(s2),cruces_cero(s2));
silencio2 = training_signal(8201:8500);
scatter(rms(silencio2),cruces_cero(silencio2));
t = training_signal(8501:8700);
scatter(rms(t),cruces_cero(t));
e3 = training_signal(8701:9300);
scatter(rms(e3),cruces_cero(e3));
m = training_signal(9301:10000);
p = training_signal(10001:10400);
o = training_signal(10401:10700);
r = training_signal(10701:11700);
a2 = training_signal(11701:12050);
l2 = training_signal(12051:12550);
e4 = training_signal(12551:13350);
s3 = training_signal(13351:15500);
silencio3 = training_signal(15501:15920);
%% Funciones

function X = exciteV (N, Np)
  for i=1:1:N
    if mod(i-1,Np) == 0
      X(i)=1;
    else
      X(i)=0;
    end
  end
 end

 function a = mylpc(x,p)
 rx = xcorr(x);
 largo_rx = length(rx);
 rx1 = rx(ceil(0.5*largo_rx)+1:ceil(0.5*largo_rx)+p);
 rx2 = rx(ceil(0.5*largo_rx):ceil(0.5*largo_rx)+p-1);
 Rx = toeplitz(rx2);
 a = Rx^(-1)*rx1;
 a = [1; -a];
 end

 function y = cruces_cero(x)
 y=0;
  for i=2:length(x)
    if (x(i)*x(i-1))<0
      y=y+1;
    end
  end
 end
