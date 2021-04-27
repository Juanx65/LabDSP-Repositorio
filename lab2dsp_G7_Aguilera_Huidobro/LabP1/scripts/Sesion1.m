%% I 1)

[data,fs] = audioread("besh.wav");

e = data(fs*65/1000 : fs*180/1000);
sh = data(fs*220/1000 : fs*300/1000);

cero_e = zeros(fs*65/1000 - 1,1);
cero_sh = zeros(fs*220/1000 - 1,1);

e_data = [cero_e ; e];
sh_data = [cero_sh ; sh];

figure(1)
stem(data,'b');
hold on 
stem(e_data,'r');
stem(sh_data,'k');
% I 2)

segmento = funI2(data,fs,'Lab2p1_segmento_vocal.wav');

%% I 3)

[data,fs] = audioread("gtr-jazz_16_48.wav");

figure(1)
stem(data,'b');

segmento2 = funI2(data,fs,'Lab2p1_arpegio.wav');

%% II 1)

[data,fs] = audioread("gtr-jazz_16_48.wav");
y = distorsionSimple(data,0.2,0.05,1,1);
subplot 211
plot(data);
subplot 212
plot(y);

%% II 1)b
[data,fs] = audioread("sonidos_voz_16_8.wav");
y = distorsionSimple(data,0.2,0.05,1,1);
subplot 211
plot(data);
subplot 212
plot(y);

%% II 1)c
y2 = distorsionSimple(data,0.1,0.05,3,1);
subplot 211
plot(normalize(data),y)
xlabel('Señal original')
ylabel('Señal overdrive')
xlim([-0.5 0.5])
subplot 212
plot(normalize(data),y2)
xlim([-0.5 0.5])

%% II 2
[data,fs] = audioread("sonidos_voz_16_8.wav");
N = 4;
t = 125;
b = 0.35;
y = delayMultiTap(data,fs,N,t,b);

subplot 211
plot(y)
grid on;
subplot 212
plot(data)
grid on;

%% Funcionet
%II 3)
function y = delayMultiTap(x,fs,N,T,b)

    M = round( (T/1000)*fs );
    y = zeros(length(x),2);
    
    for i = 1:numel(x)
        y(i) = x(i);
        for j = 1:N
            if i > j*M
                y(i) =  y(i) + b* x(i - j*M); % x no puede ser indexado negativamente, partimos de x(N)
            end
            
        end
    end
                       
end

%II 1)
function y = distorsionSimple(xNoNorm,a,b,Gi,Go)
    
    x = normalize(xNoNorm);
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
end

%I 2)
function segmento  = funI2(data,fs,nombre)
    [x, y] = ginput(2);
    
    segmento = data(x(1) : x(2) );
    
    audiowrite(nombre,segmento,fs);
    
end