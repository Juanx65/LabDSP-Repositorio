#ifndef DTMF_H
#define DTMF_H

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


/******************************************************************************
**      PUBLIC (GLOBAL) VARIABLES DECLARATIONS
******************************************************************************/


/******************************************************************************
**      PUBLIC FUNCTION PROTOTYPES
******************************************************************************/
#ifdef __cplusplus
extern "C" {
#endif
/*****************************************************************************/
// Declaración de Funciones 
void decodeDtmf(double input1, int32_t *output1);

/*****************************************************************************/
#ifdef __cplusplus
}
#endif
#endif
/******************************************************************************
**      END OF HEADER FILE
******************************************************************************/
