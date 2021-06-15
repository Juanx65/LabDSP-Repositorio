%% I.2
fs = 5000;
t=0:1/fs:0.1-1/fs;
s1 = cos(2*pi*100*t);
s2 = sin(2*pi*100*t);

f1 = fft(s1);
f2 = fft(s2);
w1 = linspace(-fs/2,fs/2,500);
w2 = linspace(0,fs,500);
subplot 221
plot(w1,fftshift(f1))
subplot 222
plot(w1,fftshift(abs(f2)))
subplot 223
plot(w2,f1)
subplot 224
plot(w2,abs(f2))
%% I.3
fs = 5000;
t=0:1/fs:0.1-1/fs;
s1 = cos(2*pi*100*t);
s2 = sin(2*pi*100*t);

f1_256 = fft(s1,256);
f2_256 = fft(s2,256);

f1_500 = fft(s1,500);
f2_500 = fft(s2,500);

f1_2048 = fft(s1,2048);
f2_2048 = fft(s2,2048);

w1_256 = linspace(-pi,pi,256);
w2_256 = linspace(0,2*pi,256);

w1_500 = linspace(-pi,pi,500);
w2_500 = linspace(0,2*pi,500);

w1_2048 = linspace(-pi,pi,2048);
w2_2048 = linspace(0,2*pi,2048);

%% Magnitudes
subplot 321
plot(w1_256,abs(f1_256))

subplot 323
plot(w1_500,abs(f1_500))

subplot 325
plot(w1_2048,abs(f1_2048))

subplot 322
plot(w1_256,abs(f2_256))

subplot 324
plot(w1_500,abs(f2_500))

subplot 326
plot(w1_2048,abs(f2_2048))

%% Partes Reales
subplot 321
plot(w1_256,real(f1_256))

subplot 323
plot(w1_500,real(f1_500))

subplot 325
plot(w1_2048,real(f1_2048))

subplot 322
plot(w1_256,real(f2_256))

subplot 324
plot(w1_500,real(f2_500))

subplot 326
plot(w1_2048,real(f2_2048))

%% Partes Reales
subplot 321
plot(w1_256,imag(f1_256))

subplot 323
plot(w1_500,imag(f1_500))

subplot 325
plot(w1_2048,imag(f1_2048))

subplot 322
plot(w1_256,imag(f2_256))

subplot 324
plot(w1_500,imag(f2_500))

subplot 326
plot(w1_2048,imag(f2_2048))

%% II
fs = 5000;
t=0:1/fs:0.1-1/fs;
senal = 0.5*cos(2*pi*100*t)+1.5*cos(2*pi*500*t)+(sqrt(2)*randn(1,500));
y=fft(senal);
w=linspace(0,fs,500);
plot(w(1:100),abs(y(1:100)));
%% dB
plot(w(1:100),20*log10(abs(y(1:100)))-max(20*log10(abs(y(1:100)))) );
%% duracion 1
fs = 5000;
t=0:1/fs:1-1/fs;
senal = 0.5*cos(2*pi*100*t)+1.5*cos(2*pi*500*t)+(sqrt(2)*randn(1,5000));
y=fft(senal);
w=linspace(0,fs,5000);
%plot(w(1:1000),abs(y(1:1000)));
plot(w(1:1000),20*log10(abs(y(1:1000)))-max(20*log10(abs(y(1:1000)))) );

%% III
load('nspeech.mat');
fft_senal = fft(nspeech);
w_vector = linspace(0,fs,length(fft_senal));
%plot(w_vector,fft_senal)
f=1685.15;
w=2*pi*f/fs;
filtro=1-2*cos(w)*exp(-j*2*pi*(w_vector)/fs)+exp(-2*j*2*pi*(w_vector)/fs);
plot(w_vector,abs(filtro))
fft_filtrada = fft_senal.*filtro;
plot(w_vector,fft_filtrada)
senal_filtrada = ifft(fft_filtrada,"symmetric");

%% IV
x1 = [1 zeros([1,7])];
x2 = ones([1,8]);
x3 = zeros([1,8]);
x4 = zeros([1,8]);
k=0:7;
x3(k+1)=exp(-j*2*pi*k/8);
x4(k+1)=cos(2*pi*k/8);

dft1 = DFTsum(x1);
dft2 = DFTsum(x2);
dft3 = DFTsum(x3);
dft4 = DFTsum(x4);
subplot 421
stem(abs(dft1))
subplot 422
stem(abs(fft(x1)))
subplot 423
stem(abs(dft2))
subplot 424
stem(abs(fft(x2)))
subplot 425
stem(abs(dft3))
subplot 426
stem(abs(fft(x3)))
subplot 427
stem(abs(dft4))
subplot 428
stem(abs(fft(x4)))
%% 4.3
fs=5000;
t=0:1/fs:1-1/fs;
x1=cos(500*t);
%dft_cos=DFTsum(x1);
fft_cos=fft(x1);
plot((abs(dft_cos)-abs(fft_cos)).^2)
error_c=immse(dft_cos,fft_cos);
%% V
fs=5000;
t=0:1/fs:1-1/fs;
x1=cos(500*t);
%X1=DFTmatrix(x1);


%% V2
Matriz8 = genAmatrix(8);
dft8 = dftmtx(8);
error8 = immse(Matriz8,dft8);
Matriz64 = genAmatrix(64);
subplot 221
imagesc(real(Matriz8))
subplot 222
imagesc(imag(Matriz8))
subplot 223
imagesc(real(Matriz64))
subplot 224
imagesc(imag(Matriz64))

%% V3
x1 = [1 zeros([1,7])];
x2 = ones([1,8]);
x3 = zeros([1,8]);
x4 = zeros([1,8]);
k=0:7;
x3(k+1)=exp(-j*2*pi*k/8);
x4(k+1)=cos(2*pi*k/8);

dft1 = DFTmatrix(x1);
dft2 = DFTmatrix(x2);
dft3 = DFTmatrix(x3);
dft4 = DFTmatrix(x4);
subplot 421
stem(abs(dft1))
subplot 422
stem(abs(fft(x1)))
subplot 423
stem(abs(dft2))
subplot 424
stem(abs(fft(x2)))
subplot 425
stem(abs(dft3))
subplot 426
stem(abs(fft(x3)))
subplot 427
stem(abs(dft4))
subplot 428
stem(abs(fft(x4)))
error1=immse(dft1,fft(x1));
error2=immse(dft2,fft(x2));
error3=immse(dft3,fft(x3));
error4=immse(dft4,fft(x4));

%% V.3
fs=5000;
t=0:1/fs:1-1/fs;
x1=cos(500*t);
f1 = @()DFTsum(x1);
f2 = @()DFTmatrix(x1);
t1 = timeit(f1);
t2 = timeit(f2);
%%
fs=5000;
t=0:1/fs:1-1/fs;
t1=zeros([1,50]);
t2=zeros([1,50]);
t3=zeros([1,50]);
x1=cos(500*t);
i=1;
for N=100:100:5000
    f1 = @()DFTsum(x1(1:N));
    f2 = @()DFTmatrix(x1(1:N));
    f3 = @()dftmtx(N);
    t1(i) = timeit(f1);
    t2(i) = timeit(f2);
    t3(i) = timeit(f3);
    i=i+1;
end

%% VI
x1 = [1 zeros([1,7])];
x2 = ones([1,8]);
x3 = zeros([1,8]);
x4 = zeros([1,8]);
k=0:7;
x3(k+1)=exp(-j*2*pi*k/8);
x4(k+1)=cos(2*pi*k/8);

dft1 = dftdc(x1);
dft2 = dftdc(x2);
dft3 = dftdc(x3);
dft4 = dftdc(x4);
subplot 421
stem(abs(dft1))
subplot 422
stem(abs(fft(x1)))
subplot 423
stem(abs(dft2))
subplot 424
stem(abs(fft(x2)))
subplot 425
stem(abs(dft3))
subplot 426
stem(abs(fft(x3)))
subplot 427
stem(abs(dft4))
subplot 428
stem(abs(fft(x4)))

%% Funciones
function X=DFTsum(x) 
N = length(x);
X = zeros([1,N]);
for k=1:length(x)
    for n=1:length(x)
        X(k)=X(k)+x(n)*exp(-j*2*pi*(k-1)*(n-1)/N);
    end
end

end

function X=DFTmatrix(x)
N = length(x);
X = zeros([1,N]);
A = genAmatrix(N);
X = x*A;
end

function A=genAmatrix(N)
A = zeros([N,N]);
for k=1:N
    for n=1:N
    A(k,n)=exp(-2*j*pi*(k-1)*(n-1)/N);
    end
end
end

function X=dftdc(x)
x_par=zeros([1,ceil(length(x))*0.5]);
    for n=1:length(x)
        if mod(n,2)~=0
            x_par((n+1)/2)=x(n);
        end
    end
x_impar=zeros([1,ceil(length(x))*0.5]);
    for n=1:length(x)
        if mod(n,2)==0
            x_impar(n/2)=x(n);
        end
    end
X_par=DFTsum(x_par);
X_impar=DFTsum(x_impar);
k=0:length(X_impar)-1;
Wnk=exp(-j*2*pi*k/length(X_impar));
length(X_par)
length(X_impar)
length(Wnk)
X=[X_par+Wnk.*X_impar, X_par-Wnk.*X_impar];
end
