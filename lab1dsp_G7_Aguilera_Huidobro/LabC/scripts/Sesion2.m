%% IV
load('aliasing_test_16_16.mat','aliasing_test');
load('aliasing_test_16_16.mat','Fs');


N = length(aliasing_test);
n = 1:N;

S1 = zeros(1,round(N/2));
for c = n
     if mod(c,2) == 0
         S1(c/2) = aliasing_test(c);  
     end
end

S2 = zeros(1,round(N/3));
for c = n
    if mod(c,3) == 0
        S2(c/3) = aliasing_test(c);
    end
end

%soundsc(aliasing_test,Fs);
soundsc(S1,Fs/2);
%soundsc(S2,Fs/3);

%1) a medida que se aumenta el downsamplig ( disminuir el numero de
%muestras) la señal resultante pierde calidad(?)
%2) 

spectrogram(aliasing_test, 256, [], [], Fs, 'yaxis');
title('Espectograma de la señal');

% debido a q la maxima frecuencia de la señal es de unos 5k Hz, por el
% teorema de nyquist diria q solo se puede bajar la tasa de muestreo a 10k
% sps

%% V 1)
%OBS:  puedes usar [data,ds] = audioread("musica_16_16.waw"); % para abrir
%los archivos de audio

    
[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(4); % 12,8,4,2,1 bits

c = cuantiza(data,N);
c2 = cuantiza(data2,N);
soundsc(data,fs);
%soundsc(c,fs);                                
%soundsc(data2,fs2);

%% V 2 a)

[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(2); % 12,8,4,2,1 bits
[dc, e] = cuantiza2(data,N);
[dc2, e2] = cuantiza2(data2,N);

subplot 211
plot(dc,'r'); % señal cuantizada ( musica )
hold on;
plot(data,'b'); % señal original ( musica ) 
legend('Señal Cuantizada', 'Señal Original', 'SouthEast')
title("Señal musica 16 16");
ylabel("Amplitud");xlabel("Muestras");
subplot 212
plot(dc2,'r');  % sonidos de voz cuantizada 
hold on;
plot(data2,'b'); % sonidos de voz original
legend('Señal Cuantizada', 'Señal Original', 'SouthEast')
title("Señal sonidos voz 16 16");
ylabel("Amplitud");xlabel("Muestras");

%% V 2 b)

[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(2); % 12,8,4,2,1 bits

[dc, e] = cuantiza2(data,N);
[dc2, e2] = cuantiza2(data2,N);

subplot 211
hist(e,20);
ylabel('Frecuencia');xlabel('Error');
title('Histograma del error de cuantización de musica 16 16');

subplot 212
hist(e2,20);
ylabel('Frecuencia');xlabel('Error');
title('Histograma del error de cuantización de sonidos voz 16 16');
%% V 2 c)

[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N1 = bitsANiveles(2); % 12,8,4,2,1 bits
N2 = bitsANiveles(12); % 12,8,4,2,1 bits

[dc1, e1] = cuantiza2(data,N1); % 2bits | musica
[dc2, e2] = cuantiza2(data2,N1); %2bits | voz

[dc12, e12] = cuantiza2(data,N2); % 12bits | musica
[dc22, e22] = cuantiza2(data2,N2); %12bits | voz

%[r , l] = xcorr( e1 , 200, 'unbiased' ); % autcorrelacion
%plot(l,r); % autocorrelación del error 

[r1,l1] = xcorr(e1, data, 200, 'unbiased');  % 2 bit | musica
[r1e , l1e] = xcorr( e1 , 200, 'unbiased' ); % autcorrelacion

[r2,l2] = xcorr(e2, data2, 200, 'unbiased');  % 2 bit | voz
[r2e , l2e] = xcorr( e2 , 200, 'unbiased' ); % autcorrelacion

[r3,l3] = xcorr(e12, data, 200, 'unbiased');  % 12 bit | musica
[r3e , l3e] = xcorr( e12 , 200, 'unbiased' ); % autcorrelacion

[r4,l4] = xcorr(e22, data2, 200, 'unbiased');  % 12 bit | voz
[r4e,l4e] = xcorr( e22 , 200, 'unbiased' ); % autcorrelacion

figure(1)
subplot 211
plot(l1,r1,'LineWidth',1.5);
hold on;
plot(l1e,r1e,'LineWidth',1.5);
legend('Correlación', 'Autocorrelación', 'SouthEast')
title("Señal musica 16 16 cuantizada con 2 bit");
ylabel('');xlabel('');
grid on
%
subplot 212
plot(l2,r2,'LineWidth',1.5);
hold on;
plot(l2e,r2e,'LineWidth',1.5);
legend('Correlación', 'Autocorrelación', 'SouthEast')
title("Señal sonidos voz 16 16 cuantizada con 2 bit");
ylabel('');xlabel('');
grid on
%
figure(2)
subplot 211
plot(l3,r3,'LineWidth',1.5);
hold on;
plot(l3e,r3e,'LineWidth',1.5);
legend('Correlación', 'Autocorrelación', 'SouthEast')
title("Señal musica 16 16 cuantizada con 12 bit");
ylabel('');xlabel('');
grid on
%
subplot 212
plot(l4,r4,'LineWidth',1.5);
hold on;
plot(l4e,r4e,'LineWidth',1.5);
legend('Correlación', 'Autocorrelación', 'SouthEast')
title("Señal sonidos voz 16 16 cuantizada con 12 bit");
ylabel('');xlabel('');
grid on

%% V 3)

[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(4); % 12,8,4,2,1 bits

dc1 = cuantiza_dither(data, N); % 2bits | musica
dc2 = cuantiza_dither(data2,N); %2bits | voz

dc01 = cuantiza(data,N);
dc02 = cuantiza(data2,N);


%soundsc(data2,fs);
%soundsc(dc02,fs);
%soundsc(dc2,fs);

%% VI 
[dataVI,fs]=audioread("aliasing_test_16_16.wav", 'native');
N=int16(161);
x=dataVI(1:N);
ww=blackman(N)*2^15;
w=int16(ww);
y=int32(w).*int32(x);
y=int16(y*2^(-15));

%whos('w');
%h=blackman(N);
%whos('h');

%% VI 2
%[dataVI,fs]=audioread("aliasing_test_16_16.wav");
%N=161;
%x=dataVI(1:N);
%w=blackman(N);
%y=w.*x;

plot(y,'.')
hold on
plot(x,'x')
plot(w,'o')
legend('señal enventanada y','señal original x','ventana w');
xlabel('Numero de Muestra');
ylabel('Amplitud de la señal en representación complemento 2');
title('Señales del Sistema')
%whos('w');
%h=blackman(N);
%whos('h');


%% FUNCIONES

%V 3)
function c = cuantiza_dither(x,N)
    delta = (max(x)-min(x))/(N-1);
    %J = imnoise(x,'gaussian',0 , ( 0.25*delta)^2 );
    W = (delta*0.25).*randn(length(x),1); %randn es ruido blanco con distribucion gaussiana, como la varianza de esto es varianza = 1
    % lo multiplicamos por delta*0.25 para q quede como nos piden.
    % rand =>  ruido blanco uniformemente distribuido
    J = x + W;
    deltaJ = (max(J)-min(J))/(N-1);
    S1 =  (J-min(J))/deltaJ;
    c = round(S1);
end

%V 1) 
function N = bitsANiveles(b)
    N = 2^b;
end
function c = cuantiza(x,N)
    delta = (max(x)-min(x))/(N-1);
    S1 =  (x-min(x))/delta;
    c = round(S1);
end

% V 2)
function [y, e] = cuantiza2(x,N)
    delta = (max(x)-min(x))/(N-1);
    S1 =  (x-min(x))/delta;
    S11 = round(S1);
    y = S11.*delta + min(x);
    e = y - x;
end



