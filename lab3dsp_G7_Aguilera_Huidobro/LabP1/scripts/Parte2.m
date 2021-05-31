%% diseño de FIR usando ventanas 1)
w = 2*pi/3;
%N = 21;
%y = ventana1(w,N);
[y1,w1] = DTFT(ventana1(w,21),512);
[y2,w2] = DTFT(ventana1(w,101),512);
[y3,w3] = DTFT(ventana1(w,1001),512);

subplot 211
plot(w1,abs(y1));
title('magnitud para N = 21')
xlabel('frecuencia rad/muestra');
ylabel('Amplitud')
subplot 212
plot(w1,angle(y1));
title('fase para N = 21')
xlabel('frecuencia rad/muestra');
ylabel('fase rad');

figure
subplot 211
plot(w2,abs(y2));
title('Magnitud para N = 101');
xlabel('frecuencia rad/muestra');
ylabel('Amplitud')
subplot 212
plot(w2,angle(y2));
title('fase para N = 101')
xlabel('frecuencia rad/muestra');
ylabel('fase rad');

figure
subplot 211
plot(w3,abs(y3) );
title('Magnitud para N = 1001');
xlabel('frecuencia rad/muestra');
ylabel('Amplitud')
subplot 212
plot(w3,angle(y3));
title('fase para N = 1001')
xlabel('frecuencia rad/muestra');
ylabel('fase rad');
%% 2)
N = 100;
subplot 511
plot(rectwin(N))
title('rectwin')
xlabel('Muestras');ylabel('Amplitud');
subplot 512
plot(hann(N))
title('hann')
xlabel('Muestras');ylabel('Amplitud');
subplot 513
plot(hamming(N))
title('hamming')
xlabel('Muestras');ylabel('Amplitud');
subplot 514
plot(blackman(N))
title('blackman')
xlabel('Muestras');ylabel('Amplitud');
subplot 515
plot(bartlett(N))
title('bartlett')
xlabel('Muestras');ylabel('Amplitud');

[H,W]=freqz(rectwin(N),N);
figure
subplot 211
plot(W,20*log10(abs(H)))
xlim([0 0.5]);
title('Magnitud rectwin');
xlabel('Frecuencia rad/muestra');ylabel('Amplitud dB');
subplot 212
plot(W,angle(H))
xlim([0 0.5]);
title('Fase rectwin');
xlabel('Frecuencia rad/muestra');ylabel('Fase rad');

[H,W]=freqz(hann(N),N);
figure
subplot 211
plot(W,20*log10(abs(H)))
xlim([0 0.5]);
title('Magnitud hann');
xlabel('Frecuencia rad/muestra');ylabel('Amplitud dB');
subplot 212
plot(W,angle(H))
xlim([0 0.5]);
title('Fase hann');
xlabel('Frecuencia rad/muestra');ylabel('Fase rad');

[H,W]=freqz(hamming(N),N);
figure
subplot 211
plot(W,20*log10(abs(H)))
xlim([0 0.5]);
title('Magnitud hamming');
xlabel('Frecuencia rad/muestra');ylabel('Amplitud dB');
subplot 212
plot(W,angle(H))
xlim([0 0.5]);
title('Fase hamming');
xlabel('Frecuencia rad/muestra');ylabel('Fase rad');

[H,W]=freqz(blackman(N),N);
figure
subplot 211
plot(W,20*log10(abs(H)))
xlim([0 0.5]);
title('Magnitud blackman');
xlabel('Frecuencia rad/muestra');ylabel('Amplitud dB');
subplot 212
plot(W,angle(H))
xlim([0 0.5]);
title('Fase blackman');
xlabel('Frecuencia rad/muestra');ylabel('Fase rad');

[H,W]=freqz(bartlett(N),N);
figure
subplot 211
plot(W,20*log10(abs(H)))
xlim([0 0.5]);
title('Magnitud bartlett');
xlabel('Frecuencia rad/muestra');ylabel('Amplitud dB');
subplot 212
plot(W,angle(H))
xlim([0 0.5]);
title('Fase bartlett');
xlabel('Frecuencia rad/muestra');ylabel('Fase rad');
%% funcions
function y = ventana1(w,N)
    x = zeros([1,N]);
    for n = 1:N
        x(n) = w/pi*(n - (N-1)/2) ;
    end
    y = w/pi*sinc(x);
end