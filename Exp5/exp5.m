%% 1.1
fs=8000;
N=fs;
Np=80;
X = exciteV(N,Np);
t = 0:1/fs:1-1/fs;
Y = fft(X);
w = linspace(0,fs/2,N/2);
plot(w,abs(Y(1:N/2)));
title('Magnitud del Espectro');
xlabel('Frecuencia sps');
ylabel('Amplitud')
figure
plot(w,20*log10(abs(Y(1:N/2)+10^(-30))));
title('Amplitud del Espectro en dB');
xlabel('Frecuencia sps');
ylabel('Amplitud dB')
%plot(w,abs(Y(1:N/2)));
figure
plot(w,mag2db(abs(Y(1:N/2)+10^-30  ))); % 10^-30 porque sino no grafica.
title('Magnitud del espectro');xlabel('Frecuencia sps');ylabel('Amplitud dB');
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
title('Magnitud del filtro');xlabel('Frecuencia sps');ylabel('Amplitud');

%% 1.3
fs=8000;
N=fs;
Np=80;
w = linspace(0,fs,N);

X = exciteV(N,Np);
a = lpc(vowel_a,15);
a_sint = filter(1,a,X);
A_sint = fft(a_sint);
subplot 511
plot(w(1:N/2),20*log10(abs(A_sint(1:N/2))));
title('Magnitud del vocal a');xlabel('Frecuencia sps');ylabel('Amplitud');
e = lpc(vowel_e,15);
e_sint = filter(1,e,X);
E_sint = fft(e_sint);
subplot 512
plot(w(1:N/2),20*log10(abs(E_sint(1:N/2))));
title('Magnitud del vocal e');xlabel('Frecuencia sps');ylabel('Amplitud');
i = lpc(vowel_i,15);
i_sint = filter(1,i,X);
I_sint = fft(i_sint);
subplot 513
plot(w(1:N/2),20*log10(abs(I_sint(1:N/2))));
title('Magnitud del vocal i');xlabel('Frecuencia sps');ylabel('Amplitud');
o = lpc(vowel_o,15);
o_sint = filter(1,o,X);
O_sint = fft(o_sint);
subplot 514
plot(w(1:N/2),20*log10(abs(O_sint(1:N/2))));
title('Magnitud del vocal o');xlabel('Frecuencia sps');ylabel('Amplitud');
u = lpc(vowel_u,15);
u_sint = filter(1,u,X);
plot(a_sint)
U_sint = fft(u_sint);
subplot  515
plot(w(1:N/2),20*log10(abs(U_sint(1:N/2))));
title('Magnitud del vocal u');xlabel('Frecuencia sps');ylabel('Amplitud');

%audiowrite("matlab_vowel_a.wav",a_sint,fs);
%audiowrite("matlab_vowel_e.wav",e_sint,fs);
%audiowrite("matlab_vowel_i.wav",i_sint,fs);
%audiowrite("matlab_vowel_o.wav",o_sint,fs);
%audiowrite("matlab_vowel_u.wav",u_sint,fs);
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
title('Magnitud del filtro');xlabel('Frecuencia sps');ylabel('Amplitud');

%% 1.4 generar archivos de audio
fs=8000;
N=fs;
Np=80;
w = linspace(0,fs,N);
X = exciteV(N,Np);
a = mylpc(vowel_a,15);
a_sint = filter(1,a,X);
A_sint = fft(a_sint);
subplot 511
plot(w(1:N/2),20*log10(abs(A_sint(1:N/2))));
title('Magnitud del vocal a');xlabel('Frecuencia sps');ylabel('Amplitud');
e = mylpc(vowel_e,15);
e_sint = filter(1,e,X);
E_sint = fft(e_sint);
subplot 512
plot(w(1:N/2),20*log10(abs(E_sint(1:N/2))));
title('Magnitud del vocal e');xlabel('Frecuencia sps');ylabel('Amplitud');
i = mylpc(vowel_i,15);
i_sint = filter(1,i,X);
I_sint = fft(i_sint);
subplot 513
plot(w(1:N/2),20*log10(abs(I_sint(1:N/2))));
title('Magnitud del vocal i');xlabel('Frecuencia sps');ylabel('Amplitud');
o = mylpc(vowel_o,15);
o_sint = filter(1,o,X);
O_sint = fft(o_sint);
subplot 514
plot(w(1:N/2),20*log10(abs(O_sint(1:N/2))));
title('Magnitud del vocal o');xlabel('Frecuencia sps');ylabel('Amplitud');
u = mylpc(vowel_u,15);
u_sint = filter(1,u,X);
U_sint = fft(u_sint);
subplot 515
plot(w(1:N/2),20*log10(abs(U_sint(1:N/2))));
title('Magnitud del vocal u');xlabel('Frecuencia sps');ylabel('Amplitud');

%audiowrite("mylpc_vowel_a.wav",a_sint,fs);
%audiowrite("mylpc_vowel_e.wav",e_sint,fs);
%audiowrite("mylpc_vowel_i.wav",i_sint,fs);
%audiowrite("mylpc_vowel_o.wav",o_sint,fs);
%audiowrite("mylpc_vowel_u.wav",u_sint,fs);

%% 2.1
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

%% 2.1.1
load('test_training_signals.mat');
silencio1 = training_signal(1:1500);
scatter(rms(silencio1),cruces_cero(silencio1),'blue');
hold on
s = training_signal(1501:3100);
scatter(rms(s),cruces_cero(s),'green');
e = training_signal(3101:3750);
scatter(rms(e),cruces_cero(e),'red');
n = training_signal(3751:4750);
scatter(rms(n),cruces_cero(n),'red');
a = training_signal(4751:5350);
scatter(rms(a),cruces_cero(a),'red');
l = training_signal(5351:6000);
scatter(rms(l),cruces_cero(l),'red');
e2 = training_signal(6001:6900);
scatter(rms(e2),cruces_cero(e2),'red');
s2 = training_signal(6901:8200);
scatter(rms(s2),cruces_cero(s2),'green');
silencio2 = training_signal(8201:8500);
scatter(rms(silencio2),cruces_cero(silencio2),'blue');
t = training_signal(8501:8700);
scatter(rms(t),cruces_cero(t),'green');
e3 = training_signal(8701:9300);
scatter(rms(e3),cruces_cero(e3),'red');
m = training_signal(9301:10000);
scatter(rms(m),cruces_cero(m),'red');
p = training_signal(10001:10250);
scatter(rms(p),cruces_cero(p),'green');
o = training_signal(10251:10700);
scatter(rms(o),cruces_cero(o),'red');
r = training_signal(10701:11700);
scatter(rms(r),cruces_cero(e3),'red');
a2 = training_signal(11701:12050);
scatter(rms(a2),cruces_cero(a2),'red');
l2 = training_signal(12051:12550);
scatter(rms(l2),cruces_cero(l2),'red');
e4 = training_signal(12551:13350);
scatter(rms(e4),cruces_cero(e4),'red');
s3 = training_signal(13351:15500);
scatter(rms(s3),cruces_cero(s3),'green');
silencio3 = training_signal(15501:15920);
scatter(rms(silencio3),cruces_cero(silencio3),'blue');
xlabel('RMS de la se??al');
ylabel('Cruces de cero por milisegundo')

%% 2.2
load('test_training_signals.mat');
%plot(test_signal);
VUS = zeros([length(test_signal),1]);
for i=1:0.02*fs:length(test_signal)
    frame = test_signal(i:i+min(0.02*fs-1,length(test_signal)-i));
    VUS(i:i+min(0.02*fs-1,length(test_signal)-i)) = find_VUS(frame);
end
plot(test_signal);
hold on
plot(VUS)

%% 3.1
VUS_vector = zeros([1,ceil(length(test_signal)/(0.02*fs))]);
RMS_vector = zeros([1,ceil(length(test_signal)/(0.02*fs))]);
lpc_matrix = zeros([16,ceil(length(test_signal)/(0.02*fs))]);

for i=1:100
    i2 = 0.02*fs*(i-1)+1;
    frame = test_signal(i2:i2+min(0.02*fs-1,length(test_signal)-i2));
    VUS_vector(i)=find_VUS(frame);
    RMS_vector(i)=rms(frame);
    lpc_matrix(:,i) = mylpc(frame,15);
end

%Crear senal sintetizada
senal_sintetizada = zeros([1,length(test_signal)]);
for j=1:100
    j2 = 0.02*fs*(j-1)+1;
    if VUS_vector(j)==0
        senal_sintetizada(j2:j2+min(0.02*fs-1,length(test_signal)-j2-1)) = zeros(1,min(0.02*fs,length(test_signal)-j2));
    else
        if VUS_vector(j)==1
            X = exciteV(min(0.02*fs,length(test_signal)-j2),80);
            rmsfactor = RMS_vector(i)/rms(filter(1,lpc_matrix(:,j),X));
            senal_sintetizada(j2:j2+min(0.02*fs-1,length(test_signal)-j2-1)) = filter(1,lpc_matrix(:,j),X)*rmsfactor;
        else
            X = rand([1,min(0.02*fs,length(test_signal)-j2)]);
            rmsfactor = RMS_vector(i)/rms(filter(1,lpc_matrix(:,j),X));
            senal_sintetizada(j2:j2+min(0.02*fs-1,length(test_signal)-j2-1)) = filter(1,lpc_matrix(:,j),X)*rmsfactor;
        end
    end
end
load('test_training_signals.mat');
N=fs;
w1 = linspace(0,fs,length(test_signal));
w2 = linspace(0,fs,length(senal_sintetizada));
figure
plot(w1,test_signal);
hold on
plot(w2,senal_sintetizada,'LineWidth',1.5);
legend({'se??al original','senal sintetizada'},'Location','southwest');
audiowrite('senal.wav',senal_sintetizada,fs);
audiowrite('senal_original.wav',test_signal,fs);
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
 if  det(Rx) == 0
     a = zeros([1,16]);
 else
    a = Rx^(-1)*rx1;
    a = [1; -a];
 end
 end

 function y = cruces_cero(x)
 largo_senal = length(x)/8000*1000;
 y=0;
  for i=2:length(x)
    if (x(i)*x(i-1))<0
      y=y+1;
    end
  end
  y=y/largo_senal;
 end

 function y = find_VUS(x)
    if(rms(x)<0.013)
        y = 0;
    else
        if(cruces_cero(x)>2.4 && rms(x)<0.06)
            y = -1;
        else
            y = 1;
        end
    end
 end