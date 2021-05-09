%% I 1)

[data,fs] = audioread("besh.wav");
t=(1:length(data))/fs;
e = data(fs*65/1000 : fs*180/1000);
sh = data(fs*220/1000 : fs*300/1000);

cero_e = zeros(fs*65/1000 - 1,1);
cero_sh = zeros(fs*220/1000 - 1,1);

e_data = [cero_e ; e];
sh_data = [cero_sh ; sh];

figure(1)
stem(t,data,'b');
hold on 
stem(t(1:length(e_data)),e_data,'r');
stem(t(1:length(sh_data)),sh_data,'k');
legend('senal_completa','vocal','fricativa');
xlabel('Tiempo ms')
ylabel('Amplitud')
title('Senal con vocal y fricativa destacada')
%% I 2)

segmento = funI2(data,fs,'Lab2p1_segmento_vocal.wav');

%% I 3)

[data,fs] = audioread("gtr-jazz_16_48.wav");

figure(1)
stem(data,'b');

segmento2 = funI2(data,fs,'Lab2p1_arpegio.wav');

%% II 1)

[data,fs] = audioread("gtr-jazz_16_48.wav");
y = distorsionSimple(data,0.2,0.05,1,1);
t=(1:length(data))/fs;
subplot 211
plot(t,data);
title('Senal Original');
xlabel('Tiempo s')
ylabel('Amplitud')
subplot 212
plot(t,y);
title('Senal con Overdrive');
xlabel('Tiempo s')
ylabel('Amplitud')

%% II 1)b
[data,fs] = audioread("sonidos_voz_16_8.wav");
y = distorsionSimple(data,0.2,0.01,1,1);
t=(1:length(data))/fs;
subplot 211
plot(t,data);
title('Senal Original');
xlabel('Tiempo s')
ylabel('Amplitud')
subplot 212
plot(t,y);
title('Senal con Overdrive');
xlabel('Tiempo s')
ylabel('Amplitud')

%% II 1)c
y2 = distorsionSimple(data,0.1,0.05,3,1);
subplot 211
plot(data,y,".")
title('Relación para alpha = 0.2 y Gi = 1')
xlabel('Señal original')
ylabel('Señal overdrive')
xlim([-0.5 0.5])
subplot 212
plot(data,y2,".")
title('Relación para alpha = 0.1 y Gi = 3')
xlim([-0.5 0.5])
xlabel('Señal original')
ylabel('Señal overdrive')

%% II 2
[data,fs] = audioread("sonidos_voz_16_8.wav");
time = (0:length(data)-1/fs)*1/fs;
N = 4;
t = 125;
b = [0.35 0.35 0.35 0.35];
y = delayMultiTap(data,fs,N,t,b);

plot(time,y)
hold on
plot(time,data)
grid on;
legend('Senal con delay','Senal original')
xlabel('Tiempo s')
%% II 2 b
[data,fs] = audioread("sonidos_voz_16_8.wav");
time = (0:length(data)-1/fs)*1/fs;
N = 10;
t = 250;
b = [0.35 0.35^2 0.35^3 0.35^4 0.35^5 0.35^6 0.35^7 0.35^8 0.35^9 0.35^10];
y = delayMultiTap(data,fs,N,t,b);


plot(time,y)
hold on;
plot(time,data)
grid on;
legend('Senal con delay','Senal original')
xlabel('Tiempo s')
%% II 2 c
[data,fs] = audioread("gtr-jazz_16_48.wav");
new_data = resample(data,1,3);
time1 = (0:length(data)-1/fs)*1/fs;
time2 = (0:length(new_data)-3/fs)*3/fs;
N = 10;
t = 250;
b = [0.35 0.35^2 0.35^3 0.35^4 0.35^5 0.35^6 0.35^7 0.35^8 0.35^9 0.35^10];
y1 = delayMultiTap(data,fs,N,t,b);
y2 = delayMultiTap(new_data,fs/3,N,t,b);
subplot 211
plot(time1,y1)
title('Senal original con delay')
xlabel('Tiempo s')
ylabel('Amplitud')
subplot 212
plot(time2,y2)
title('Senal re-sampleada con delay')
xlabel('Tiempo s')
ylabel('Amplitud')
%% Funciones
%II 3)
function y = delayMultiTap(x,fs,N,T,b)

    M = round( (T/1000)*fs );
    y = zeros(length(x),2);
    
    for i = 1:numel(x)
        y(i) = x(i);
        for j = 1:N
            if i > j*M
                y(i) =  y(i) + b(j)* x(i - j*M); % x no puede ser indexado negativamente, partimos de x(N)
            end
            
        end
    end

    if rms(y(:,2)) == 0                 %%Para señales mono
        y=y(:,1);
    end
                       
end

%II 1)
function y = distorsionSimple(x,a,b,Gi,Go)
    
    
    x1 = x.*Gi;
    
    absx = abs(x1);
    y1 = zeros(length(x1),2);
    
    for i = 1:numel(absx)
        if absx(i) >= a
            y1(i) = x1(i)*b + sign(x1(i))*(1-b)*a;
        else
            y1(i) = x1(i);
        end
    end
    
    y = y1.*Go;
    if rms(y(:,2)) == 0                 %%Señales mono
        y=y(:,1);
    end
end

%I 2)
function segmento  = funI2(data,fs,nombre)
    [x, y] = ginput(2);
    
    segmento = data(x(1) : x(2) );
    
    audiowrite(nombre,segmento,fs);
    
end