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

/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/

extern double notch(double data)
{
    int frec = 440;
    int BW = 100;
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

      return filterBiquad(&filtro_notch, data);
}

/******************************************************************************
*   \brief  Esta función implementa una etapa de filtro biquad
*
*   \param filterNState     : puntero a la estructura del biquad a ejecutar
*   \param filterInput          : señal de entrada al filtro biquad a ejecutar
*
*   \return filterOutput        : señal de salida del filtro biquad ejecutado
******************************************************************************/
static double filterBiquad(bqState_t *filterNState, double filterInput)
{
    // COMPLETAR
    filterNState->bqInput[2]=filterNState->bqInput[1];
    filterNState->bqInput[1]=filterNState->bqInput[0];
    filterNState->bqInput[0]=filterInput;
    filterNState->bqOutput[2]=filterNState->bqOutput[1];
    filterNState->bqOutput[1]=filterNState->bqOutput[0];
    filterNState->bqOutput[0]=((filterNState->bqB0*filterNState->bqInput[0]+filterNState->bqB1*filterNState->bqInput[1]
            +filterNState->bqB2*filterNState->bqInput[2])-(filterNState->bqA1*filterNState->bqOutput[1]
            +filterNState->bqA2*filterNState->bqOutput[2]));
    return filterNState->bqOutput[0];
    /* Se retorna la salida */
}
