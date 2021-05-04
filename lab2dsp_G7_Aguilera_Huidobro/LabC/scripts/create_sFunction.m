% InstanciaciÃ³n del objeto
def = legacy_code('initialize');
% Nombre de la s-function
def.SFunctionName = 'template_siso';
% Protiotipo de la funciÃ³n
% Notar es informaciÃ³n para Matlab, y el solo acepta nombres de entrada u1,
% u2, etc, y salida y1
% Usar el nombre de la funciÃ³n en C que implementÃ³
def.OutputFcnSpec = 'double y1 = funcion(double u1)';
% Archivo de cabecera
def.HeaderFiles = {'template.h'};
% Archivo fuente en C
def.SourceFiles = {'lineal.c'};
% CompilaciÃ³n para la s-function
legacy_code('sfcn_cmex_generate', def)
legacy_code('compile', def)