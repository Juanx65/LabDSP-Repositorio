/***************************************************************************//**
* \file     Funciones que deben impementar los alumnos
*
* \brief    Plantilla para crear función en C para una sFunction de Matlab
*
* \authors  Gonzalo Carrasco
*******************************************************************************/

/******************************************************************************
**      HEADER FILES
******************************************************************************/
#include <template.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <tmwtypes.h>

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/


/******************************************************************************
**      MODULE MACROS
******************************************************************************/


/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/


/******************************************************************************
**      MODULE VARIABLE DEFINITIONS
******************************************************************************/



/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/


/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/
#define BUFFER_SIZE 20000
/***************************************************************************//**
*   \brief 
*
*   \param  input : 
*
*   \return Void.
*******************************************************************************/

float filter_notch(float input)
{
    bqState_t filtro_notch = {
    1.9308,
    0.96,
    1,
    -1.9702,
    1,
    {0,0,0},
    {0,0,0},
    0.98};
    return filterBiquad(filtro_notch,input)
}

float filterBiquad(bqState_t *filterNState, float filterInput)
{
    filterNState.bqInput[2]=filterNState.bqInput[1];
    filterNState.bqInput[1]=filterNState.bqInput[0];
    filterNState.bqInput[0]=filterInput;
    filterNState.bqOutput[2]=filterNState.bqOutput[1];
    filterNState.bqOutput[1]=filterNState.bqOutput[0];
    filterNState.bqOutput[0]=((filterNstate.bqB0*filterNState.bqInput[0]+filterNstate.bqB1*filterNstate.bqInput[1]
            +filterNstate.bqB2*filterNstate.bqInput[2])*filterNstate.Gain-(filterNstate.bqA1*filterNstate.bqOutput[1]
            +filterNstate.bqA2*filterNstate.bqOutput[2]));
    return filterNState.bqOutput[0];
}



/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
