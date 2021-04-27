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

segmento = funI2(data,fs);

%% I 3)

[data,fs] = audioread("gtr-jazz_16_48.wav");

figure(1)
stem(data,'b');

segmento2 = funI2(data,fs);

%% II 1)

[data,fs] = audioread("gtr-jazz_16_48.wav");
y = distorsionSimple(data);


%% Funciones
%II 1)
function y = distorsionSimple(xNoNorm)
    Gi = 1;
    Go = 1;
    a = 0.2;
    b = 0.05;
    
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
function segmento  = funI2(data,fs)
    [x, y] = ginput(2);
    
    segmento = data(x(1) : x(2) );
    
    audiowrite('Lab2p1_segmento_vocal.wav',segmento,fs);
    
end