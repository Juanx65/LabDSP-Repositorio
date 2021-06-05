%% 1
x=[1, zeros([1,1000])];
theta= pi/6;
y=filtro1(x,theta);

stem(y(1:10))
xlabel('Muestra')
ylabel('Amplitud')
title('Respuesta a Impulso con \theta = pi/6')

%% 1 resp frec
y1=filtro1(x,pi/6);
y2=filtro1(x,pi/3);
y3=filtro1(x,pi/2);
f_vector= -pi:2*pi/length(y1):pi-1/length(y1);
plot(f_vector,20*log10(abs(fftshift(fft(y1)))));
hold on
plot(f_vector,20*log10(abs(fftshift(fft(y2)))));
hold on
plot(f_vector,20*log10(abs(fftshift(fft(y3)))));
legend(' \theta = pi/6',' \theta = pi/3',' \theta = pi/2')
xlabel('Frecuencia rad/muestra') %??????? q unidad? 
ylabel('Amplitud dB')
title('Magnitud de respuesta en frecuencia')

%% 2
x=[1, zeros([1,1000])];
theta= pi/6;
y=filtro2(x,0.3,theta);
stem(y(1:10))
xlabel('Muestra')
ylabel('Amplitud')
title('Respuesta a Impulso con \theta = pi/6')

%% 2 resp frec
y1=filtro2(x,pi/3,0.99);
y2=filtro2(x,pi/3,0.9);
y3=filtro2(x,pi/3,0.7);
f_vector= -pi:2*pi/length(y1):pi-1/length(y1);
plot(f_vector,20*log10(abs(fftshift(fft(y1)))));
hold on
plot(f_vector,20*log10(abs(fftshift(fft(y2)))));
hold on
plot(f_vector,20*log10(abs(fftshift(fft(y3)))));
legend('r = 0.99','r = 0.9','r = 0.7')
xlabel('Frecuencia rad/muestra')
ylabel('Amplitud dB')
title('Respuesta a Impulso con  \theta = pi/3 para diferentes r')

%% 3
load('nspeech.mat');
%plot_fft_mag(nspeech,fs)
frec = 1685;
fn = 1685/4000 * pi;
senal_filtrada = FIR_filter(nspeech,fn);
f_vector= -4000:2*4000/length(nspeech):4000-4000/length(nspeech);
f_vector2= -4000:2*4000/length(senal_filtrada):4000-4000/length(senal_filtrada);
subplot 211
plot(f_vector,20*log10(abs(fftshift(fft(nspeech)))))
xlabel('Frecuencia Hz')
ylabel('Amplitud dB')
title('nspeech')
subplot 212
plot(f_vector2,20*log10(abs(fftshift(fft(senal_filtrada)))))
ylim([-60 80])
xlabel('Frecuencia Hz')
ylabel('Amplitud dB')
title('nspeech pasado por filtor FIR')
%% 3 filter de matlab
load('nspeech.mat');
fn = 1685/4000 * pi;
f_vector= -4000:2*4000/length(nspeech):4000-4000/length(nspeech);
senal_filtrada2 = filter([1 -2*cos(fn) 1],[1 0 0], nspeech);
subplot 211
plot(f_vector2,20*log10(abs(fftshift(fft(senal_filtrada)))))
ylim([-60 80])
xlabel('Frecuencia Hz')
ylabel('Amplitud dB')
title('FIR filter')
subplot 212
plot(f_vector,20*log10(abs(fftshift(fft(senal_filtrada2)))))
ylim([-60 80])
xlabel('Frecuencia Hz')
ylabel('Amplitud dB')
title('filter Matlab')
%% 4
load('pcm.mat')
plot_fft_mag(pcm,fs)
wn = 3146/4000 * pi;
aCoeff = [-2*0.99*cos(wn) 0.99^2];
yBuff = [0, 0];
filtered_pcm = zeros([1,length(pcm)]);
for i=1:length(pcm)
    yBuff = IIR_filter(yBuff, aCoeff, pcm(i));
    filtered_pcm(i) = yBuff(1);
end


f_vector= -4000:2*4000/length(pcm):4000-4000/length(pcm);
f_vector2= -4000:2*4000/length(filtered_pcm):4000-4000/length(filtered_pcm);
subplot 211
plot(f_vector,abs(fftshift(fft(pcm))))
grid on
xlabel('Frecuencia Hz')
ylabel('Amplitud')
title('pcm')
subplot 212
plot(f_vector2,abs(fftshift(fft(filtered_pcm))))
grid on
xlabel('Frecuencia Hz')
ylabel('Amplitud')
title('pcm pasado por filtor IIR')

figure 
subplot 211
plot(pcm)
grid on
xlabel('Muestras')
ylabel('Amplitud')
title('pcm')
subplot 212
plot(filtered_pcm)
grid on
xlabel('Muestras')
ylabel('Amplitud')
title('pcm pasado por filtor IIR')
%% Funciones

function y = filtro1(x, theta)
b=[1 -2*cos(theta) 1];
y=zeros([1,length(x)]);
for i=1:length(x)
    y(i)=x(i);
    if i>1
    y(i)= y(i) + b(2)*x(i-1) ;
    end
    if i>2
    y(i)= y(i) + b(3)*x(i-2) ;
    end
end

end

function y = filtro2(x,r,theta)
b=[1 -2*r*cos(theta) r^2];
y=zeros([1,length(x)]);
for i=1:length(x)
    y(i)=(1-r)*x(i);
    if i>1
    y(i)= y(i) - b(2)*y(i-1);
    end
    if i>2
    y(i)= y(i) - b(3)*y(i-2);
    end
end
end

function y = FIR_filter(x,theta)
b = [1 -2*cos(theta) 1]; 
a = [1 0 0];
h = impz(b,a); % respuesta impulso del filtro digital con coeficientes b, a
y = conv(h,x);
end
function y = IIR_filter(yBuff, aCoeff, x)
    y_new = x - aCoeff(1)*yBuff(1) - aCoeff(2)*yBuff(2);
    y = [y_new yBuff(1)];
end