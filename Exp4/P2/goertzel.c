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
#include <goertzel.h>
#include <stdint.h>
#include <stdbool.h>
#include <math.h>

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/


/******************************************************************************
**      MODULE MACROS
******************************************************************************/
#define SAMPLING_FREQ			(16000)

#define GOERTZEL_N				(256)
/*---------------------------------------------------------------------------*/

/*
 * Bins arbitrarios.
 */

#define GOERTZEL1_K_BIN	    	(11)
#define GOERTZEL2_K_BIN	    	(12)
#define GOERTZEL3_K_BIN	    	(14)
#define GOERTZEL4_K_BIN	    	(15)
#define GOERTZEL5_K_BIN	    	(19)
#define GOERTZEL6_K_BIN	    	(21)
#define GOERTZEL7_K_BIN	    	(24)

/*
 * bins para DTMF con N=256 @16 ksps
 */



/*
 * Constante
 */
#ifndef M_PI
#define M_PI					(3.141592653589793)
#endif

/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/

/*
 * Estructura de estado de filtros goertzel
 */
typedef struct goertzelStateTag {
	uint64_t samplesCounter;
  double cosW;
	double sinW;
	double A1;
  double outputs[3];
	double binReal;
	double binImag;
	double binMag;
} goertzelState_t;

/******************************************************************************
**      MODULE VARIABLE DEFINITIONS
******************************************************************************/


/*---------------------------------------------------------------------------*/
/* VARABLES FILTROS GOERTZEL*/
/*---------------------------------------------------------------------------*/
goertzelState_t gGoertzelState1 = {0};
goertzelState_t gGoertzelState2 = {0};
goertzelState_t gGoertzelState3 = {0};
goertzelState_t gGoertzelState4 = {0};
goertzelState_t gGoertzelState5 = {0};
goertzelState_t gGoertzelState6 = {0};
goertzelState_t gGoertzelState7 = {0};


/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/

static void initGoertzel(goertzelState_t *state, uint64_t kFrequency);
static void resetGoertzel(goertzelState_t *state);
static double computeGoertzel(goertzelState_t *state, double filterInput);

/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/


/***************************************************************************//**
*   \brief Funci�n prncipal llamada por la sFunction
*
*   \param  input : una entrada de se�al desde simulink
*
*   \param  output: salidas hacia simulink
*
*   \return Void.
*******************************************************************************/
void goertzelFunction(double input1,
				double *output1,
				double *output2,
				double *output3,
				double *output4,
				double *output5,
				double *output6,
				double *output7
				)
{
  *output1 = computeGoertzel(&gGoertzelState1 , input1);
  *output2 = computeGoertzel(&gGoertzelState2 , input1);
  *output3 = computeGoertzel(&gGoertzelState3 , input1);
  *output4 = computeGoertzel(&gGoertzelState4 , input1);
  *output5 = computeGoertzel(&gGoertzelState5 , input1);
  *output6 = computeGoertzel(&gGoertzelState6 , input1);
  *output7 = computeGoertzel(&gGoertzelState7 , input1);
}

/******************************************************************************
*   \brief  Esta funci�n se ejecuta una vez cuando se corre la simulaci�n
*           de Simulink. Se usa para inicializar variables y estructuras.
*
*   \return  void
******************************************************************************/
extern void initialization(void)
{
  initGoertzel( &gGoertzelState1 , GOERTZEL1_K_BIN );
  initGoertzel( &gGoertzelState2 , GOERTZEL2_K_BIN );
  initGoertzel( &gGoertzelState3 , GOERTZEL3_K_BIN );
  initGoertzel( &gGoertzelState4 , GOERTZEL4_K_BIN );
  initGoertzel( &gGoertzelState5 , GOERTZEL5_K_BIN );
  initGoertzel( &gGoertzelState6 , GOERTZEL6_K_BIN );
  initGoertzel( &gGoertzelState7 , GOERTZEL7_K_BIN );

	return;
}

/******************************************************************************
*   \brief  Esta funci�n inicializa un filtro goertzel
*
*   \param state                : puntero a la estructura del filtro a ejecutar
*   \param kFrequency           : bin de frecuencia a calcular
*
*   \return filterOutput        : se�al de salida del filtro goertzel ejecutado
******************************************************************************/
static void initGoertzel(goertzelState_t *state, uint64_t kFrequency)
{
  double omega = (2*M_PI*kFrequency/GOERTZEL_N);
  state->samplesCounter = 0;
  state->cosW = cos(omega);
  state->sinW = sin(omega);
  state->A1= -2*cos(omega);
  state->outputs[0] = 0.0;
  state->outputs[1] = 0.0;
  state->outputs[2] = 0.0;
  state->binReal=0;
  state->binImag=0;
  state->binMag=0;
	return;
}

/******************************************************************************
*   \brief  Esta funci�n pone en cero los estados de un filtro goertzel
*
*   \param state                : puntero a la estructura del filtro a ejecutar
*
******************************************************************************/
static void resetGoertzel(goertzelState_t *state)
{
	state->samplesCounter = 0;
    state->outputs[0] 		= 0.0;
	state->outputs[1] 		= 0.0;
	state->outputs[2] 		= 0.0;
	// Se quere retener el �ltimo resultado para el bin sin llevarlos a cero

	return;
}

/******************************************************************************
*   \brief  Esta funci�n implementa el filtro goertzel
*
*   \param state               : puntero a la estructura del filtro a ejecutar
*   \param filterInput          : se�al de entrada al filtro biquad a ejecutar
*
*   \return filterOutput        : se�al de salida del filtro goertzel ejecutado
******************************************************************************/
static double computeGoertzel(goertzelState_t *state, double filterInput)
{
state->outputs[2]=state->outputs[1];
state->outputs[1]=state->outputs[0];
state->outputs[0]=filterInput+(2*state->cosW*state->outputs[1])-(state->outputs[2]);
(state->samplesCounter)+=1;

if(state->samplesCounter==GOERTZEL_N+1)
{
  state->binReal=state->cosW*state->outputs[1]-state->outputs[2];
  state->binImag=state->sinW*state->outputs[1];
  state->binMag=sqrt(state->binReal*state->binReal+state->binImag*state->binImag);
  resetGoertzel(state);
}
return state->binMag;
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
