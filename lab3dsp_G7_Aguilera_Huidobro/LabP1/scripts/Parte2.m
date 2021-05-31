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
wvtool(rectwin(N))
subplot 512
wvtool(hann(N))
subplot 513
wvtool(hamming(N))
subplot 514
wvtool(blackman(N))
subplot 515
wvtool(bartlett(N))

%% funcions
function y = ventana1(w,N)
    x = zeros([1,N]);
    for n = 1:N
        x(n) = w/pi*(n - (N-1)/2) ;
    end
    y = w/pi*sinc(x);
end