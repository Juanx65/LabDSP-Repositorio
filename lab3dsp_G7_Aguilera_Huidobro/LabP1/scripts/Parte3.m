%% DISE ̃NO DE FILTROSFIRUSANDO HERRAMIENTAS DEMATLAB 1) 


N = 70; %orden
fc = 3000; %hz -> x
tm = 16000; % sps -> 2

W =  fc*2/tm; % ?????? 

rect = rectwin(N+1);
bckmn = blackman(N+1);

B1 = fir1(N,W,rect);
B2 = fir1(N,W,bckmn);

%usar comando fdatool y generar filtro con B.
figure 
freqz(B1)
title('Ventana rectangular');

figure
freqz(B2)
title('Ventana Blackman');

%% 2)
N1 = 70;
N2 = 150;

f = [0 0.1 0.15 0.35 0.4 0.65 0.75 1];
m = [1 1 0 0 0.5 0.5 0 0];

B1 = fir2(N1,f,m);
B2 = fir2(N2,f,m);

figure  
freqz(B1)
title('N = 70');
figure
freqz(B2)
title('N = 150');


%% 3)


