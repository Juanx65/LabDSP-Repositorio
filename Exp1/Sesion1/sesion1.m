%% ejemplo
t = 0:2:59;
y = sin(t/6);
subplot 311
stem(t,y)
grid on
subplot 312
plot(t,y)
grid on

%% I.1)
t = 0:2:59; % tiempo de muestreo
y = sin(t/6);
t2 = 0:10:59;
y2 = sin(t2/6);

subplot 311
stem(t,y,'g','LineWidth',1.7);
title('Stem con Ts = 2');
legend('Stem', 'Location', 'SouthEast')
ylabel('Amplitud');xlabel('Tiempo s');
grid on;

subplot 312;
plot(t,y,'m','LineWidth',1.5);
title('Plot con Ts = 2');
legend('Plot', 'Location', 'SouthEast')
ylabel('Amplitud');xlabel('Tiempo s');
grid on;

subplot 313
plot(t2,y2,'b','LineWidth',1.4);
hold on;
stem(t2,y2,'r','LineWidth',2);
title('Plot y Stem con Ts = 10');
legend('Plot','Stem','Location', 'SouthEast')
ylabel('Amplitud');xlabel('Tiempo s');
grid on;
axis([0 60 -1 1]);
%% I 6)
%stairs() plotea continuamente un valor en el eje y hasta el siguiente
%la siguiente muestra.
stairs(t2,y2,'b','LineWidth',1.4);
hold on;
stem(t2,y2,'r','LineWidth',2);
title('Stairs y Stem con Ts = 10');
legend('Stairs','Stem','Location', 'SouthEast')
ylabel('Amplitud');xlabel('Tiempo s');
grid on;
axis([0 60 -1 1]);


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
stem(n1,s1,'r','LineWidth',1.8);
title('S1[n] con Ts = 1/10');
ylabel('Amplitud');xlabel('Muestras');
grid on;
axis([0 100 -1 1]);

subplot 412
stem(n2,s2,'g','LineWidth',1.8);
title('S2[n] con Ts = 1/3');
ylabel('Amplitud');xlabel('Muestras');
grid on;
axis([0 30 -1 1]);

subplot 413
stem(n3,s3,'b','LineWidth',1.8);
title('S3[n] con Ts = 1/2');
ylabel('Amplitud');xlabel('Muestras');
grid on;
axis([0 20 -1 1]);

subplot 414
stem(n4,s4,'m','LineWidth',1.8);
title('S4[n] con Ts = 10/9');
ylabel('Amplitud');xlabel('Muestras');
grid on;
axis([0 9 -1 1]);

%5)  1 hz, 1hz, 0 hz, 0.1 hz 
%6)  10, 3, 2 , 1
%7) no, debido a la fs la señal resultante 
%8)


%% Parte III

t = 0:1/5000:1-1/5000;
s1 = sin(2*pi*50*t + 50);
s2 = sin(2*pi*500*t + 50);
subplot 211
plot(t,s1);
subplot 212
plot(t,s2);
% soundsc(s1,5000);
% soundsc(s2,5000);

%% 3.2

s_suma = s1+s2;
subplot 211
plot(t(1:250),s_suma(1:250));
s3 = sin(2*pi*200*t + 50);
s4 = sin(2*pi*300*t + 50);
suma_2 = s3+s4;
subplot 212
plot(t(1:250),suma_2(1:250))

%% Parte III

t = 0:1/5000:1-1/5000;
s1 = sin(2*pi*50*t + 50);
s2 = sin(2*pi*500*t + 50);
subplot 211
plot(t,s1);
subplot 212
plot(t,s2);
% soundsc(s1,5000);
% soundsc(s2,5000);

%% 3.2

s_suma = s1+s2;
subplot 211
plot(t(1:250),s_suma(1:250));
s3 = sin(2*pi*200*t + 50);
s4 = sin(2*pi*300*t + 50);
suma_2 = s3+s4;
subplot 212
plot(t(1:250),suma_2(1:250))

%% 3.3
t = 0:1/100000:1;
ss = zeros(1,100001);
ss2 = zeros(1,100001);
for k = 1:6
    ss = ss+sin(2*pi*(2*k-1)*220*t)/(2*k-1);
    ss2 = ss2+sin(2*pi*(2*k-1)*220*t+2*pi*rand(1,1))/(2*k-1);
    ss3 = ss3+sin(2*pi*(2*k-1)*220*t+2*pi*rand(1,1))/(2*k-1);
    ss4 = ss4+sin(2*pi*(2*k-1)*220*t+2*pi*rand(1,1))/(2*k-1);
end
plot(t(1:1200),ss(1:1200));
xlabel('Tiempo s');
ylabel("Amplitud");
title('Aproximación de Señal Cuadrada');
subplot 311
plot(t(1:1200),ss2(1:1200));
xlabel('Tiempo s');
ylabel("Amplitud");
title('Aproximación de Señal Cuadrada con fase aleatoria');
subplot 312
plot(t(1:1200),ss3(1:1200));
xlabel('Tiempo s');
ylabel("Amplitud");
title('Aproximación de Señal Cuadrada con fase aleatoria');
subplot 313
plot(t(1:1200),ss4(1:1200));
xlabel('Tiempo s');
ylabel("Amplitud");
title('Aproximación de Señal Cuadrada con fase aleatoria');


%% 3.4
t = 0:1/5000:1-1/5000;
s2 = sin(2*pi*500*t + 50);
random = 2*rand(1,5000)-1;
s2_rand = s2+random;
subplot 221
plot(t(1:0.01*5000)*1000,s2_rand(1:0.01*5000));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Sinusoidal sumada con señal aleatoria para fs=5000 Hz')
subplot 222
plot(t(1:0.01*5000)*1000,s2(1:0.01*5000));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Señal sinusoidal original')

t2=0:1/100000:1;
s2_2 = sin(2*pi*500*t2 + 50);
random_2 = 2*rand(1,100000+1)-1;
s2_rand_2 = s2_2+random_2;
subplot 223
plot(t2(1:0.01*100000)*1000,s2_rand_2(1:0.01*100000));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Sinusoidal sumada con señal aleatoria para fs=100000 Hz')
subplot 224
plot(t2(1:0.01*100000)*1000,s2_2(1:0.01*100000));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Señal sinusoidal original')

%% 3.5 
sx_var_amp = sx.*(rand(1,0.5*fs)*0.5+0.5);
subplot 211
plot(t2(1:0.01*fs)*1000,sx(1:0.01*fs));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Señal original')
subplot 212
plot(t2(1:0.01*fs)*1000,sx_var_amp(1:0.01*fs));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Señal con amplitud aleatoria')

%% 3.6
sx_var_fas = sin(2*pi*500*t2 + pi*(rand(1,fs+1)-0.5));
subplot 211
plot(t2(1:0.01*fs)*1000,sx(1:0.01*fs));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Señal original')
subplot 212
plot(t2(1:0.01*fs)*1000,sx_var_fas(1:0.01*fs));
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Señal con fase sumada a señal aleatoria')

%% 3.7
%soundsc(sx,fs);
%soundsc(sx2,fs);
%soundsc(sx_var_amp,fs);
%soundsc(sx_var_fas,fs)