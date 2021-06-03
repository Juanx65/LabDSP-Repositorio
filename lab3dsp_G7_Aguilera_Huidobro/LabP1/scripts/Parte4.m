%% IV Diseño de filtro IIR 1)
tm = 16000; %sps -> 2
%a) 
fc = 2000; %Hz
Wp = fc*2/tm ;
N = 12;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp,'low');
freqz(B,A);
title('Filtro pasabajos fc = 2k Hz');
%%  b)
fc = 4000; %Hz
Wp = fc*2/tm ;
N = 12;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp,'high');
freqz(B,A);
title('Filtro pasa-altos fc = 4k Hz');

%% c)

f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 6;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp);
freqz(B,A);
title('Filtro pasa-banda f = [2k,4k] Hz');

%% d

f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 6;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp,'stop');
freqz(B,A);
title('Filtro elimina-banda f = [2k,4k] Hz');

%% 2 a)
f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 2;
R = 2;
[B,A] = cheby1(N,R,Wp);
freqz(B,A);
title('Filtro Cheby1 pasa-banda f = [2k,4k] Hz');
%% b)
f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 2;
R = 20;
[B,A] = cheby2(N,R,Wp);
freqz(B,A);
title('Filtro Cheby2 pasa-banda f = [2k,4k] Hz');

%% 3)  1

f1 = 800; %Hz
f2 = 1600;
Wp = [f1*2/tm f2*2/tm];
N = 2;
[B,A] = butter(N,Wp);
freqz(B,A);
title('Filtro Butterworth pasa-banda f = [800,1600] Hz');

%% 3) 2

[z,p,k] = butter(4,Wp);

zplane(z,p,k);
title('Plano Z Filtro Butterworth orden 8');


