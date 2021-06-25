%% Para observar BINS 8, 9, 10
[senal,fs]=audioread("dtmfSequenceSpaced_16_16.wav");
fft1=fft(senal(1:256));
stem(0:29,abs(fft1(1:30)));
xlabel("bins");
ylabel("Magnitud");
title("Primeras 256 muestras de la señal");

%% Para observar componentes maximos
fft2=fft(senal(31000:31000+256));
stem(abs(fft2(1:200)));

%% Graficos 
subplot 421
bar(out.tout,out.bins(:,1))
xlabel('Tiempo s');ylabel('Amplitud');
title("bin 11");
subplot 422
bar(out.tout,out.bins(:,2))
xlabel('Tiempo s');ylabel('Amplitud');
title("bin 12");
subplot 423
bar(out.tout,out.bins(:,3))
xlabel('Tiempo s');ylabel('Amplitud');
title("bin 14");
subplot 424
bar(out.tout,out.bins(:,4))
xlabel('Tiempo s');ylabel('Amplitud');
title("bin 15");
subplot 425
bar(out.tout,out.bins(:,5))
xlabel('Tiempo s');ylabel('Amplitud');
title("bin 19");
subplot 426
bar(out.tout,out.bins(:,6))
xlabel('Tiempo s');ylabel('Amplitud');
title("bin 21");
subplot 427
bar(out.tout,out.bins(:,7))
xlabel('Tiempo s');ylabel('Amplitud');
title("bin 24");
