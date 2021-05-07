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
double funcion(double input)
{
    static double buffer[BUFFER_SIZE];
    // buffer circular
    static int i = 0;
    double output = buffer[i];
    buffer[i] = input;
    i = ((i+1)%BUFFER_SIZE);
	return output;
}



/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
