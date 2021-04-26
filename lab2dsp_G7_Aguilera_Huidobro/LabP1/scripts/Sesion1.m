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




%% Funciones

%I 2)
function segmento  = funI2(data,fs)
    [x, y] = ginput(2);
    
    segmento = data(x(1) : x(2) );
    
    audiowrite('Lab2p1_segmento_vocal.wav',segmento,fs);
    
end