
%%%%% Parte VI Lab 4 DSP

%%% 3. Comparación fft_stage con fft

num = 10:19;

Fs = 5000;

t2 = zeros(1,10);
t1 = zeros(1,10);

for ctr = 1:10
    N = 2.^num(ctr);
    t = (0:N-1)/Fs;
    
    x = cos(2*pi*100*t); % Señal a analizar
    
    f1 = @() fft(x);
    f2 = @() fft_stage(x);
    
    t1(ctr) = timeit(f1);
    t2(ctr) = timeit(f2);
    
end
    
figure
plot(num, t1)
hold on
plot(num, t2)
xlabel("Muestras en escala logarítmica base 2 [-]"); ylabel("tiempo [s]")
title("Comparacion de costo computacional entre fft y fft\_stage")
legend("fft","fft_stage")

function X = fft_stage(x)
    N = length(x);
    
    if (N == 2)
        X = FFT2(x);
        return
    else    
        x0    = zeros(1,N/2); x1    = zeros(1,N/2);        
    
        for i = 1:N/2
            x0(i) = x(2*i-1); %OBS "par"   1,3,5,... en MATLAB
            x1(i) = x(2*i);   %OBS "impar" 2,4,6,... en MATLAB       
        end
    
        W = exp(-1j*2*pi/N);  Wk = W.^(0:(N/2-1));        
        X0 = fft_stage(x0) ;  X1 = fft_stage(x1) ; 
    
        X_izq = X0 + Wk.*X1;
        X_der = X0 - Wk.*X1;
    
        X = [X_izq X_der];
    end
end
%%%%% Parte VI Lab 4 DSP
function X = FFT2(x)
    X = zeros(1,2);
    
    X(1) = x(1) + x(2);
    X(2) = x(1) - x(2);
end