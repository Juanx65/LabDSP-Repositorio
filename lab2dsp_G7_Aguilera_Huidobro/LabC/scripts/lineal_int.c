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
#include <templateInt16.h>
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
int16_t funcion(int16_t input)
{
    static int16_t buffer[BUFFER_SIZE];
    // buffer lineal
    for (int i=BUFFER_SIZE-1; i>0 ; i--)
        buffer[i] = buffer[i-1];
    buffer[0] = input;
	int16_t output = buffer[BUFFER_SIZE-1];
	return output;
}



/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
