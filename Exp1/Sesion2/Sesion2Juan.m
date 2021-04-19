%% IV
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
%soundsc(S1,Fs/2);
%soundsc(S2,Fs/3);

%1) a medida que se aumenta el downsamplig ( disminuir el numero de
%muestras) la señal resultante pierde calidad(?)

%2) 

spectrogram(aliasing_test, 256, [], [], Fs, 'yaxis');

% debido a q la maxima frecuencia de la señal es de unos 5k Hz, por el
% teorema de nyquist diria q solo se puede bajar la tasa de muestreo a 10k
% sps

%% V 1)
%OBS:  puedes usar [data,ds] = audioread("musica_16_16.waw"); % para abrir
%los archivos de audio

    
[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(1); % 12,8,4,2,1 bits

c = cuantiza(data,N);
c2 = cuantiza(data2,N);
%soundsc(data,fs);
%soundsc(c2,fs);                                
%soundsc(data2,fs2);

%% V 2 a)

[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(2); % 12,8,4,2,1 bits
[dc, e] = cuantiza2(data,N);
[dc2, e2] = cuantiza2(data2,N);

subplot 211
plot(dc); % señal cuantizada ( musica )
hold on;
plot(data); % señal original ( musica ) 
title("Señal musica_16_16");
ylabel("Amplitud");xlabel("Muestras");
subplot 212
plot(dc2);  % sonidos de voz cuantizada 
hold on;
plot(data2); % sonidos de voz original
title("Señal sonidos_voz_16_16");
ylabel("Amplitud");xlabel("Muestras");

%% V 2 b)

[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(2); % 12,8,4,2,1 bits

[dc, e] = cuantiza2(data,N);
[dc2, e2] = cuantiza2(data2,N);

subplot 211
hist(e,20);

subplot 212
hist(e2,20);






%% FUNCIONES

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


