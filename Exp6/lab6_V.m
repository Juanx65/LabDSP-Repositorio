fs = 44100;
max = fs/2;
vector_frecuencias = [0 221/max 1764/max 4410/max 6615/max 8820/max, 1];
vector_correccion = [2.1 2 1.3 1 1 1.2 1.5];
[b, a] = yulewalk(4,vector_frecuencias,vector_correccion);
freqz(b,a,1000,fs);
[sos,g] = tf2sos(b,a);

%% obtener los valores para los parametros como un entero
N0 = int16(32767*sos(1,1));
N1 = int16(0.5*32767*sos(1,2));
N2 = int16(32677*sos(1,3));
D1 = int16(-0.5*32678*sos(1,5));
D2 = int16(-32678*sos(1,6));

N3 = int16(32767*sos(2,1));
N4 = int16(0.5*32767*sos(2,2));
N5 = int16(32677*sos(2,3));
D4 = int16(-0.5*32678*sos(2,5));
D5 = int16(-32678*sos(2,6));

%% luego obtenemos los valores de los coeficientes para los registros

%Es importante notar que MATLAB toma los coeficientes LSB como primer valor
%del vector

N0_coef = typecast(N0,'uint8');
N1_coef = typecast(N1,'uint8');
N2_coef = typecast(N2,'uint8');
D1_coef = typecast(D1,'uint8');
D2_coef = typecast(D2,'uint8');

N3_coef = typecast(N3,'uint8');
N4_coef = typecast(N4,'uint8');
N5_coef = typecast(N5,'uint8');
D4_coef = typecast(D4,'uint8');
D5_coef = typecast(D5,'uint8');
