#ifndef TEMPLATE_H
#define TEMPLATE_H

/******************************************************************************
**      INCLUDES
******************************************************************************/
#include <stdint.h>
#include <stdbool.h>

/******************************************************************************
**      PREPROCESSOR CONSTANTS
******************************************************************************/


/******************************************************************************
**      CONFIGURATION CONSTANTS
******************************************************************************/


/******************************************************************************
**      MACRO DEFINITIONS
******************************************************************************/


/******************************************************************************
**      PUBLIC DATATYPES
******************************************************************************/
typedef struct bqState_t {
    double bqA1;
    double bqA2;
    double bqB0;
    double bqB1;
    double bqB2;
    double bqInput[3];
    double bqOutput[3];
} bqState_t;
/******************************************************************************
**      PUBLIC (GLOBAL) VARIABLES DECLARATIONS
******************************************************************************/


/******************************************************************************
**      PUBLIC FUNCTION PROTOTYPES
******************************************************************************/
#ifdef __cplusplus
extern "C" {
#endif
/*************************************************************************************************/
// DeclaraciÃ³n de Funciones 
/*************************************************************************************************/
extern double retornar_salida(double data, double frec);
#ifdef __cplusplus
}
#endif
#endif
/******************************************************************************
**      END OF HEADER FILE
******************************************************************************/


