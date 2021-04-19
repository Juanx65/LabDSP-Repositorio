%% I ejemplo:
t = 0:2:59;
y = sin(t/6);
subplot 311
stem(t,y);
grid on;
subplot 312;
plot(t,y);
grid on;
%% I.1)
t = 0:2:59;
y = sin(t/6);
t2 = 0:10:59;
y2 = sin(t2/6);
subplot 311
stem(t,y);
grid on;
subplot 312;
plot(t,y);
grid on;
subplot 313
plot(t2,y2);
hold on;
stem(t2,y2);
grid on;
% en la pregunta se refiere a graficar en comparasión al ejemplo dado o a 
% la misma señal?????
%% I 2)
% stem = muestra los valores discretos de la curva que fueron tomados
% plot = trata de hacer una aproximación de los valores continuos de la curva

%% I 3)
% efectivamente se logro tener 5 veces menos muestras en la señal
% resultante...

%% I 4)
% el intervalo [0 59] representa el tiempo.

%% I 5)
% la señal y2 tiene un periodo de 37 s una frecuencia de 1/37 Hz igual que la señal original
%% I 6)
%stairs() plotea continuamente un valor en el eje y hasta el siguiente
%la siguiente muestra.

stairs(t2,y2);

%% II 

%1) Ts = 1/10
t1 = 0:1/10:100*1/10;
n1 = 0:1:100;
s1 = sin(2*pi*t1);

%2) Ts = 1/3
t2 = 0:1/3:30*1/3;
n2 = 0:1:30;
s2 = sin(2*pi*t2);

%3) Ts = 1/2
t3 = 0:1/2:20*1/2;
n3 = 0:1:20;
s3 = sin(2*pi*t3);

%4) Ts= 10/9
t4 = 0:10/9:9*10/9;
n4 = 0:1:9;
s4 = sin(2*pi*t4);

%) graficos

subplot 411
plot(n1,s1);
hold on;
stem(n1,s1);
grid on;
axis([0 100 -1 1]);

subplot 412
plot(n2,s2);
hold on;
stem(n2,s2);
grid on;
axis([0 30 -1 1]);

subplot 413
plot(n3,s3);
hold on;
stem(n3,s3);
grid on;
axis([0 20 -1 1]);

subplot 414
plot(n4,s4);
hold on;
stem(n4,s4);
grid on;
axis([0 9 -1 1]);

%5)  1 hz, 1hz, 0 hz, 0.1 hz 
%6) y 8) 10, 3, 2, 0.9
%7) no, debido a la fs la señal resultante 
%8)

%% III 1)
t = 0:1/5000:1-1/5000;
s1 = sin(2*pi*50*t + 50);
s2 = sin(2*pi*500*t + 50);
subplot 211
stem(t,s1);
subplot 212
stem(t,s2);
% el largo de amvos vectores es 1x5000 double como se esperaba
%se escofe fs = 5000 Hz para cumplir con el teorema de Nyquiz con ambas
%freciencias fo dadas y tener un margen ( 10 veces más grande que la
%frecuencia más alta).

%soundsc(s1,5000);
%soundsc(s2,5000);
%% III 2)
t = 0:1/5000:5000/1000 - 1/5000;
s1 = sin(2*pi*50*t + 50);
s2 = sin(2*pi*500*t + 50);
s3 = s1 + s2;

%plot(t,s3);
%hold on
%stem(t,s3);
%grid on;

% periodo: 1/50 s
%periodo para 200 y 300 -> 1/100 s
% ambas debido al maximo comun divisor encontrado entre sus frecuencias.
    
s4 = sin(2*pi*200*t + 50);
s5 = sin(2*pi*300*t + 50);
s6 = s4 + s5;

%soundsc(s6,5000);

%soundsc(s4,5000);
%soundsc(s5,5000);
% se siente como la superpocicion de ambas señales efectivamente xd

%% III 3)





