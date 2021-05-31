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


%% 3)


