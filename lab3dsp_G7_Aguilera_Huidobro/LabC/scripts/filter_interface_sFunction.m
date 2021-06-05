% InstanciaciÃ³n del objeto
def = legacy_code('initialize');
% Nombre de la s-function
def.SFunctionName = 'filtro_notch';
% Protiotipo de la funciÃ³n
% Notar es informaciÃ³n para Matlab, y el solo acepta nombres de entrada u1,
% u2, etc, y salida y1
% Usar el nombre de la funciÃ³n en C que implementÃ³
def.OutputFcnSpec = 'double y1 = retornar_salida(double u1, double u2)';
% Archivo de cabecera
def.HeaderFiles = {'filterInterface.h'};
% Archivo fuente en C
def.SourceFiles = {'filterInterface.c'};
% CompilaciÃ³n para la s-function
legacy_code('sfcn_cmex_generate', def)
legacy_code('compile', def)
