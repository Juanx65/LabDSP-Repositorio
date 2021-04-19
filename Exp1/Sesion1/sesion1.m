%% ejemplo
t = 0:2:59;
y = sin(t/6);
subplot 311
stem(t,y)
grid on
subplot 312
plot(t,y)
grid on

%% parte I
t = 0:10:59;
y = sin(t/6);
subplot 411
stem(t,y);
title('Grafico usando comando plot');
grid on
subplot 412
plot(t,y)
title('Grafico usando comando stem');
grid on
subplot 413
plot(t,y,'LineWidth',2)
title('Graficos superpuestos');
hold on
stem(t,y,'LineWidth',1)
grid on
subplot 414
stairs(t,y);
title('Grafico usando comando stairs');

%% Parte II
t1 = 0:0.1:0.1*100;
n1 = 0:1:100;
y1 = sin(2*pi*t1);
subplot 221
stem(n1,y1);
axis([0 100 -1 1]);

t2 = 0:1/3:1/3*30;
n2 = 0:1:30;
y2 = sin(2*pi*t2);
subplot 222
stem(n2,y2);
axis([0 30 -1 1]);

t3 = 0:1/2:1/2*20;
n3 = 0:1:20;
y3 = sin(2*pi*t3);
subplot 223
stem(n3,y3);
axis([0 20 -1 1]);

t4 = 0:10/9:10/9*9;
n4 = 0:1:9;
y4 = sin(2*pi*t4);
subplot 224
stem(n4,y4);
axis([0 9 -1 1]);

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
    ss2 = ss2+sin(2*pi*(2*k-1)*220*t+2*pi*rand(1,1));
end
subplot 121
plot(t(1:800),ss(1:800));
subplot 122
plot(t(1:800),ss2(1:800));

%% 3.4
random = 2*rand(1,5000)-1;
s2_rand = s2+random;
subplot 221
plot(t(1:0.01*5000),s2_rand(1:0.01*5000));
subplot 222
plot(t(1:0.01*5000),s2(1:0.01*5000));

t2=0:1/100000:1;
s2_2 = sin(2*pi*500*t2 + 50);
random_2 = 2*rand(1,100000+1)-1;
s2_rand_2 = s2_2+random_2;
subplot 223
plot(t2(1:0.01*100000),s2_rand_2(1:0.01*100000));
subplot 224
plot(t2(1:0.01*100000),s2_2(1:0.01*100000));

%%
t=0:0.001:0.06;

sx=sin(2*pi*50*t);

plot(t,sx);

hold on

stairs(t,sx);