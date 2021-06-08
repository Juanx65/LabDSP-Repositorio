fp = 2400;
fsp = 4000;
fs = 16000;
Rp = 0.5; %decibeles
Rs = 40; %decibeles 

[n_butter,wn_butter] = buttord(fp/fs,fsp/fs,Rp,Rs);
[n_cheb,wn_cheb] = cheb1ord(fp/fs,fsp/fs,Rp,Rs);
[n_ellip,wn_ellip] = ellipord(fp/fs,fsp/fs,Rp,Rs);

f = [fp fsp];
a = [1 0];
dev = [(10^(Rp/20)-1)/(10^(Rp/20)+1)  10^(-Rs/20)];

[n_fir,fo_fir,ao_fir,w_fir] = firpmord(f,a,dev,fs);