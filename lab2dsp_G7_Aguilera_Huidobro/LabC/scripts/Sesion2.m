%% V Resample
%%[data,fs] = audioread('sonidos_voz_16_8.wav');

x=rand(10,1);
%%y = interpola(data,7);
t = linspace(0,10,length(y));
y = interpola(x,7);
gd = 21;

stem([upsample(x,7)]);
hold on
plot([y(21:70)*max(x)/max(y); zeros([22,1])],'o');
%% Funciones

function y=interpola(x,P)
    y=zeros(length(x)*P,1);
    for i=1:length(x)
        y((i-1)*P+1)=x(i);
        for j=2:P
            y((i-1)*P+j)=0;
        end
    end
    B=fir1(40,1/(P));
    y=filter(B,1,y);
end