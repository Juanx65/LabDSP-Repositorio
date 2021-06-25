%% Para observar BINS 8, 9, 10
[senal,fs]=audioread("dtmfSequenceSpaced_16_16.wav");
fft1=fft(senal(1:256));
%stem(abs(fft1(1:200)));

%% Para observar componentes maximos
fft2=fft(senal(31000:31000+256));
stem(abs(fft2(1:200)));

