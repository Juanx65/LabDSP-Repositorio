%% 1
x=[1, zeros([1,1000])];
theta= pi/6;
y=filtro1(x,theta);
stem(y(1:10))

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

%% 2
x=[1, zeros([1,1000])];
theta= pi/6;
y=filtro2(x,0.3,theta);
stem(y(1:10))

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
legend('0.99','0.9','0.7')

%% 3
load('nspeech.mat');
%plot_fft_mag(nspeech,fs)
frec = 1685;
fn = 1685/4000 * pi;
senal_filtrada = filtro1(nspeech,fn);
subplot 211
plot(20*log10(abs(fft(nspeech))))
subplot 212
plot(20*log10(abs(fft(senal_filtrada))))

%% 4
load('pcm.mat')
wn = 3146/4000 * pi;
aCoeff = [-2*0.99*cos(wn) 0.99^2];
yBuff = [0, 0];
filtered_pcm = zeros([1,length(pcm)]);
for i=1:length(pcm)
    yBuff = IIR_filter(yBuff, aCoeff, pcm(i));
    filtered_pcm(i) = yBuff(1);
end
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
delta=[1, zeros([1,2])];
y=zeros(1,length(x));
h=filtro1(delta,theta);
for k=1:length(x)
    for i=1:length(x)
        if i-k > 0
            if i-k < 4
                y(k)=y(k)+x(k)*h(i-k);
            end
        end
    end
end

end
function y = IIR_filter(yBuff, aCoeff, x)
    y_new = x - aCoeff(1)*yBuff(1) - aCoeff(2)*yBuff(2);
    y = [y_new yBuff(1)];
end