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
figure
plot(w(1:N/2),abs(E(1:N/2)));

filtro_i = lpc(vowel_i,15);
I=0;
w = linspace(0,fs,N);
for i=1:1:16
    I=I+filtro_a(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(I(1:N/2)));

filtro_o = lpc(vowel_o,15);
O=0;
w = linspace(0,fs,N);
for i=1:1:16
    O=O+filtro_o(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(O(1:N/2)));

filtro_u = lpc(vowel_u,15);
U=0;
w = linspace(0,fs,N);
for i=1:1:16
    U=U+filtro_u(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(U(1:N/2)));

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

load('vowels.mat');
[vowels,fs] = audioread("vowel_a_16_8.wav");
filtro_a = mylpc(vowel_a,15);
A=0;
w = linspace(0,fs,N);
for i=1:1:16
    A=A+filtro_a(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(A(1:N/2)));

filtro_e = mylpc(vowel_e,15);
E=0;
w = linspace(0,fs,N);
for i=1:1:16
    E=E+filtro_e(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(E(1:N/2)));

filtro_i = mylpc(vowel_i,15);
I=0;
w = linspace(0,fs,N);
for i=1:1:16
    I=I+filtro_a(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(I(1:N/2)));

filtro_o = mylpc(vowel_o,15);
O=0;
w = linspace(0,fs,N);
for i=1:1:16
    O=O+filtro_o(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(O(1:N/2)));

filtro_u = mylpc(vowel_u,15);
U=0;
w = linspace(0,fs,N);
for i=1:1:16
    U=U+filtro_u(i).*exp(-1j*2*pi*w*(i-1));
end
figure
plot(w(1:N/2),abs(U(1:N/2)));

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
 Rx = toeplitz(x);
 rx = xcorr(x);
 a = Rx(1:p,1:p)^(-1)*rx(8000:8000+p-1);
 a = [1; -a];
 end
