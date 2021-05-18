%% V Parte I
%[data,fs] = audioread('sonidos_voz_16_8.wav');
x=rand(10,1);
%y = interpola(data,7);
y = interpola(x,7);
gd = 21;
tx = 1:1/7:length(x);
plot(tx(1:50),[y(gd:70)*(x(1)/(y(gd)))],'o');
hold on
stem(x);
legend('Señal y luego de interpolar x con P = 7 y filtrar','Señal x aleatoria')
xlabel('Muestras de x')
ylabel('Amplitud')
%% Parte I Aliasing Test

load('aliasing_test_16_16.mat','aliasing_test');
load('aliasing_test_16_16.mat','Fs');
s_interpolada=interpola(aliasing_test,3);
s_sin_filtro=int_sin_filtro(aliasing_test,3);
t1=linspace(-Fs/2,Fs/2,length(aliasing_test));
t2=linspace(-3*Fs/2,3*Fs/2,length(s_interpolada));
subplot 311
plot(t1,abs(fftshift(fft(aliasing_test))))
xlabel('Frecuencia Hz')
ylabel('Amplitud')
title('Señal original')
subplot 312
plot(t2,abs(fftshift(fft(s_sin_filtro))))
xlabel('Frecuencia Hz')
ylabel('Amplitud')
title('Señal interpolada sin filtrar')
subplot 313
plot(t2,abs(fftshift(fft(s_interpolada))))
xlabel('Frecuencia Hz')
ylabel('Amplitud')
title('Señal interpolada filtrada')

%Plots sin modificar fft
subplot 311
plot(abs(fft(aliasing_test)))
ylabel('Amplitud')
title('Señal original')
subplot 312
plot(abs(fft(s_sin_filtro)))
ylabel('Amplitud')
title('Señal interpolada sin filtrar')
subplot 313
plot(abs(fft(s_interpolada)))
ylabel('Amplitud')
title('Señal interpolada filtrada')


%% Parte I Delta Kroeneker
x=[1; zeros(39,1)];
y = interpola(x,7);
gd = 21;
tx = 1:1/7:length(x);
subplot 211
stem(x);
ylabel('Amplitud')
xlabel('Muestras de x')
title('Delta Krónecker')
subplot 212
plot(tx,[y(1:length(tx))*max(x)/max(y)],'o');
ylabel('Amplitud')
xlabel('Eqivalente en el tiempo a las muestras de x')
title('Respuesta a delta Krónecker')

%% Parte II Decimar
load('aliasing_test_16_16.mat','aliasing_test');
load('aliasing_test_16_16.mat','Fs');
y=decima(aliasing_test,4);
t1=linspace(-Fs/2,Fs/2,length(aliasing_test));
t2=linspace(-Fs/8,Fs/8,length(y));
subplot 211
plot(t1,abs(fftshift(fft(aliasing_test))))
title('FFT de la señal aliasing test')
xlabel('Frecuenciz Hz')
subplot 212
plot(t2,abs(fftshift(fft(y))))
title('FFT de la señal aliasing test decimada')
xlabel('Frecuenciz Hz')

%% Parte III Remuestreo
load('aliasing_test_16_16.mat','aliasing_test');
load('aliasing_test_16_16.mat','Fs');
y_intermedia = interpola(aliasing_test,3);
y = decima(y_intermedia,4);
t1=linspace(-Fs/2,Fs/2,length(aliasing_test));
t2=linspace(-3*Fs/8,3*Fs/8,length(y));
subplot 211
plot(t1,abs(fftshift(fft(aliasing_test))))
title('FFT de la señal aliasing test')
xlabel('Frecuenciz Hz')
subplot 212
plot(t2,abs(fftshift(fft(y))))
title('FFT de la señal aliasing test remuestreada a 12kHz')
xlabel('Frecuenciz Hz')
audiowrite('aliasing_test_16_12.wav',y,Fs*3/4);
%% Funciones

function y=interpola(x,P)
    y=zeros(length(x)*P,1);
    for i=1:length(x)
        y((i-1)*P+1)=x(i);
        for j=2:P
            y((i-1)*P+j)=0;
        end
    end
    B=fir1(40,1/(P));
    y=filter(B,1,y);
end

function y=int_sin_filtro(x,P)
    y=zeros(length(x)*P,1);
    for i=1:length(x)
        y((i-1)*P+1)=x(i);
        for j=2:P
            y((i-1)*P+j)=0;
        end
    end
end

function y=decima(x,Q)
    y=zeros(floor(length(x)/Q),1);
    B=fir1(40,1/(Q));
    x=filter(B,1,x);
    for i=1:length(x)
        if mod(i,Q) == 0
            y(i/Q)=x(i);
        end
    end
end