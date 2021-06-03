%% IV Diseño de filtro IIR 1)
tm = 16000; %sps -> 2
%a) 
fc = 2000; %Hz
Wp = fc*2/tm ;
N = 10;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp,'low');
freqz(B,A);
title('Filtro pasabajos fc = 2k Hz');
%%  b)
fc = 4000; %Hz
Wp = fc*2/tm ;
N = 10;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp,'high');
freqz(B,A);
title('Filtro pasa-altos fc = 4k Hz');

%% c)

f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 10;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp);
freqz(B,A);
title('Filtro pasa-banda f = [2k,4k] Hz');

%% d

f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 10;
Rp = 0.5;
Rs = 20;
[B,A] = ellip(N,Rp,Rs,Wp,'stop');
freqz(B,A);
title('Filtro elimina-banda f = [2k,4k] Hz');

%% 2 a)
f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 4;
R = 2;
[B,A] = cheby1(N,R,Wp);
freqz(B,A);
title('Filtro Cheby1 pasa-banda f = [2k,4k] Hz');
%% b)
f1 = 2000; %Hz
f2 = 4000;
Wp = [f1*2/tm f2*2/tm];
N = 4;
R = 20;
[B,A] = cheby2(N,R,Wp);
freqz(B,A);
title('Filtro Cheby2 pasa-banda f = [2k,4k] Hz');

