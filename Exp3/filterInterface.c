/***************************************************************************//**
* \file     Funciones que deben impementar los alumnos
*
* \brief
*
* \authors  Gonzalo Carrasco
*******************************************************************************/

/******************************************************************************
**      HEADER FILES
******************************************************************************/
#include <notch.h>
#include <stdint.h>
#include <stdbool.h>

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/


/******************************************************************************
**      MODULE MACROS
******************************************************************************/


/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/
/*
 * Estructura de estado de filtros biquad
 */


/*---------------------------------------------------------------------------*/
/* VARABLES FILTRO NOTCH */
/*---------------------------------------------------------------------------*/




/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/
static double filterBiquad(bqState_t *filterNState, double filterInput);
void filterInterface(double data, double frec, double *output1);

/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/

extern double retornar_salida(double data, double frec)
{
    double salida;
    filterInterface(data, frec, &salida);
    return salida;
}

void filterInterface(double data, double frec, double *output1)
{
    int BW = 200;
    int fs = 16000;
    
    double theta = 2*3.1415169265358979323846*frec/fs;
    double bw = 2*3.1415169265358979323846*BW/fs;
    double d = (1-sin(bw))/cos(bw);
    double gain = (1+d)/2;
    static bqState_t filtro_notch = {
        0,
        0,
        0,
        0,
        0,
        {0,0,0},
        {0,0,0}
    };
    filtro_notch.bqA1=-(1+d)*cos(theta);
    filtro_notch.bqA2=d;
    filtro_notch.bqB0=gain;
    filtro_notch.bqB1=-2*cos(theta)*gain;
    filtro_notch.bqB2=gain;
    
    *output1 = filterBiquad(&filtro_notch, data);
}

/******************************************************************************
*   \brief  Esta funci??n implementa una etapa de filtro biquad
*
*   \param filterNState     : puntero a la estructura del biquad a ejecutar
*   \param filterInput          : se??al de entrada al filtro biquad a ejecutar
*
*   \return filterOutput        : se??al de salida del filtro biquad ejecutado
******************************************************************************/
static double filterBiquad(bqState_t *filterNState, double filterInput)
{
    filterNState->bqInput[2]=filterNState->bqInput[1];
    filterNState->bqInput[1]=filterNState->bqInput[0];
    filterNState->bqInput[0]=filterInput;
    filterNState->bqOutput[2]=filterNState->bqOutput[1];
    filterNState->bqOutput[1]=filterNState->bqOutput[0];
    filterNState->bqOutput[0]=((filterNState->bqB0*filterNState->bqInput[0]+filterNState->bqB1*filterNState->bqInput[1]
            +filterNState->bqB2*filterNState->bqInput[2])-(filterNState->bqA1*filterNState->bqOutput[1]
            +filterNState->bqA2*filterNState->bqOutput[2]));
    return filterNState->bqOutput[0];
}
