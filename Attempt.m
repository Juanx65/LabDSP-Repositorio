%% ejemplo
t = 0:2:59;
y = sin(t/6); %seno(2*pi*fo*ts*n) 
plot(t,y);
hold on
stem(t,y);
%% otro ejemplo
t2 = -1:1/10:1;
t = -1:1/3:1;
y = sin(2*pi*t);
y2 = sin(2*pi*t2);
subplot 211
plot(t,y);
hold on;
grid on;
stem(t,y);
subplot 212
plot(t2,y2);
hold on;
grid on;
stem(t2,y2);