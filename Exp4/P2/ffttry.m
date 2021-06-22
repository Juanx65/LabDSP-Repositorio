[senal,fs]=audioread("dtmfSequenceSpaced_16_16.wav");
fft1=fft(senal(1:256));
stem(abs(fft1(1:50)));