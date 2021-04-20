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
plot(l1,r1);
hold on;
plot(l1e,r1e);
title("musica 2 bit");
%
figure(2)
plot(l2,r2);
hold on;
plot(l2e,r2e);
title("voz 2 bit");
%
figure(3)
plot(l3,r3);
hold on;
plot(l3e,r3e);
title("musica 12 bit");
%
figure(4)
plot(l4,r4);
hold on;
plot(l4e,r4e);
title("voz 2 bit");

%% V 3)

[data,fs] = audioread("musica_16_16.wav");
[data2,fs2] = audioread("sonidos_voz_16_16.wav");

N = bitsANiveles(2); % 12,8,4,2,1 bits

dc1 = cuantiza_dither(data, N); % 2bits | musica
dc2 = cuantiza_dither(data2,N); %2bits | voz

dc01 = cuantiza(data,N);
dc02 = cuantiza(data2,N);


%soundsc(data2,fs);
%soundsc(dc02,fs);
%soundsc(dc2,fs);

%% VI 


%% FUNCIONES

%V 3)
function c = cuantiza_dither(x,N)
    delta = (max(x)-min(x))/(N-1);
    %J = imnoise(x,'gaussian',0 , ( 0.25*delta)^2 );
    W = (delta*0.25).*rand(length(x),1);
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



