%% diseño de FIR usando ventanas 1)
w = 2*pi/3;
%N = 21;
%y = ventana1(w,N);
[y1,w1] = DTFT(ventana1(w,21),512);
[y2,w2] = DTFT(ventana1(w,101),512);
[y3,w3] = DTFT(ventana1(w,1001),512);

subplot 211
plot(w1,abs(y1));
subplot 212
plot(w1,angle(y1));

figure
subplot 211
plot(w2,abs(y2));
subplot 212
plot(w2,angle(y2));

figure
subplot 211
plot(w3,abs(y3) );
subplot 212
plot(w3,angle(y3));

%% funcions
function y = ventana1(w,N)
    x = zeros([1,N]);
    for n = 1:N
        x(n) = w/pi*(n - (N-1)/2) ;
    end
    y = w/pi*sinc(x);
end