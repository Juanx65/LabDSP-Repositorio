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


N = bitsANiveles(1); % 12,8,4,2,1 bits

c = cuantiza(data,N);
c2 = cuantiza(data2,N);
soundsc(c,fs);
%soundsc(c2,fs);
%soundsc(data2,fs);

function N = bitsANiveles(b)
    N = 2*exp(b);
end
function c = cuantiza(x,N)
    delta = (max(x)-min(x))/(N-1);
    S1 =  (x-min(x))/delta;
    c = round(S1);
end

%% V 2)



