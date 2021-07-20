/******************************************************************************
* \file     Lab1p2_solucion.c
*
* \brief    Experiencia 1 de laboratorio DSP ELO314
*
* \authors  Gonzalo Carrasco
******************************************************************************/

/******************************************************************************
**      HEADER FILES
******************************************************************************/
#include "dlu_global_defs.h"
#include "L138_LCDK_aic3106_init.h"
#include "dsp_lab_utils.h"
#include <math.h>
#include "dlu_codec_config.h"
#include "oscilloscope_meas.h"

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/

/******************************************************************************
**      MODULE MACROS
******************************************************************************/
// Constantes
#define AUDIOBUFFERSIZE          4000               // 320 Delay 20ms @ 16ksps
#define RMSBUFFERSIZE            256                // 256 para 16ms de ventana
#define AVGBUFFERSIZE            6                // Rango pedido

/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/

/******************************************************************************
**      MODULE VARIABLE DEFINITIONS
******************************************************************************/

/*---------------------------------------------------------------------------*/
/* ENTRADAS Y SALIDAS DEL AIC CODEC */
/*---------------------------------------------------------------------------*/
/*
 * Tipo de dato para el CODEC (Union)
 */
AIC31_data_type codec_data;

/*
 * Varibles de entrada y salida en formato entero
 */
short intCodecInputR,intCodecInputL;
short intCodecOutputR,intCodecOutputL;

/*
 * Varibles de entrada y salida en formato flotante
 */
float floatCodecInputR,floatCodecInputL;
float floatCodecOutputR,floatCodecOutputL;

/*
 * Variables de estado de salida saturada
 */
int outSaturationStat = 0;

/*---------------------------------------------------------------------------*/
/* C�MPUTO MOVING AVERAGE */
/*---------------------------------------------------------------------------*/
uint32_t        idxMovingAvgLast = 0;   // Posici�n relativa a la �ltima muestra
uint32_t        idxMovingAvgHead = 0;   // Posici�n absouta de la cabeza
uint32_t        idxMovingAvgCurr = 0;   // Posici�n absoluta de operaci�n actual

int32_t         movingAvgAux = 0;
int16_t         movingAvg = 0;
int16_t         movingAvgBuff[AVGBUFFERSIZE] = {0};

/*---------------------------------------------------------------------------*/
/* GENERACI�N DE SEALES */
/*---------------------------------------------------------------------------*/
int16_t         cosSignal;
int16_t         ampCosine = 16383;

float           thetaCosineSignal = 0.0;
float           freqCosineMin = 100.0;

/* M�scada de bits */
int16_t         maskLsbs = 0xFC00;

/*---------------------------------------------------------------------------*/
/* OSCILLOSCOPE MEASUREMENTS */
/*---------------------------------------------------------------------------*/
/* Indice de lectura */
int32_t idxOscMeas = 0;

/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/

/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/

interrupt void interrupt4(void) // interrupt service routine
{
//#############################################################################
        /*-------------------------------------------------------------------*/
        /* LECTURA DE ENTRADAS DEL CODEC */
        /*-------------------------------------------------------------------*/
        codec_data.uint = input_sample();
        intCodecInputL = codec_data.channel[LEFT];
        intCodecInputR = codec_data.channel[RIGHT];

//        DLU_readCodecInputs(&floatCodecInputL, &floatCodecInputR);

        /*-------------------------------------------------------------------*/
        // USO DE ESTADO DE PULSADOR USER1 PARA ACTIVAR LED
        /*-------------------------------------------------------------------*/
        //DLU_writeLedD4(DLU_gPbUser1);
        // Obtenci�n de valores de estados para cambiar estado de leds
        if ( DLU_GET_REG_BIT(DLU_gPbToggle, PB_TOGGLES_T1_BIT) )
            DLU_writeLedD5(LED_ON);
        else
            DLU_writeLedD5(LED_OFF);

        if ( DLU_GET_REG_BIT(DLU_gPbToggle, PB_TOGGLES_T2_BIT) )
            DLU_writeLedD6(LED_ON);
        else
            DLU_writeLedD6(LED_OFF);

        if ( DLU_GET_REG_BIT(DLU_gPbToggle, PB_TOGGLES_T12_BIT) )
            DLU_writeLedD7(LED_ON);
        else
            DLU_writeLedD7(LED_OFF);

        /*-------------------------------------------------------------------*/
        /* GENERACI�N DE REFERENCIA SINUSOIDAL */
        /*-------------------------------------------------------------------*/
        // �ngulo se incrementa linealmente segun frecuencia angular
        // dada por un valor base m�s el valor del contador de ajuste
        thetaCosineSignal  = thetaCosineSignal + 2.0 * M_PI * ( (float)DLU_gPbTrimmer + freqCosineMin) * TS;
        // Theta entre [0, 2*pi]
        if ( thetaCosineSignal > 2.0 * M_PI ) thetaCosineSignal = thetaCosineSignal - 2.0*M_PI;
        // Calculo de sin(Theta) y cos(Theta)
        cosSignal = (int16_t)( 2 * ampCosine * cosf(thetaCosineSignal) );

        /*-------------------------------------------------------------------*/
        /* MODULACI�N DE AMPLITUD */
        /*-------------------------------------------------------------------*/
        intCodecOutputL = (int16_t)( ( (int32_t)cosSignal * (int32_t)intCodecInputL) >> 16);

        /*-------------------------------------------------------------------*/
        /* Inicia medici�n de tiempo de ejecuci�n */
        DLU_tic();

        /*-------------------------------------------------------------------*/
        /* MOVING AVERAGE  */
        /*-------------------------------------------------------------------*/

        /* Medici�n de tiempo de ejecuci�n */
        DLU_toc();

        /*-------------------------------------------------------------------*/
        /* OSCILLOSCOPE_MEAS  */
        /*-------------------------------------------------------------------*/

//        /* Actualizando �ndice de lectura para medici�n con osciloscopio */
//        idxOscMeas++;
//        if (idxOscMeas >= OSCILLOSCOPE_SIGSIZE)
//            idxOscMeas = 0;

        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GR�FICO */
        /*-------------------------------------------------------------------*/
        triggerSyncGraphBuff();
        fillGraphBuff1(intCodecInputL);
        fillGraphBuff2(cosSignal);

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        intCodecOutputL = intCodecInputL;
        intCodecOutputR = cosSignal;

        codec_data.channel[LEFT] = intCodecOutputL;//(intCodecInputL & maskLsbs); // intCodecInputL audioBufferL[AUDIOBUFFERSIZE-1]
        codec_data.channel[RIGHT] = intCodecOutputR;
        output_sample(codec_data.uint);

//        floatCodecOutputL = floatCodecInputL;
//        floatCodecOutputR = cosSignal;
//
//        outSaturationStat = DLU_writeCodecOutputs(floatCodecOutputL,floatCodecOutputR);
//        DLU_writeLedD4((PB_INT_TYPE)outSaturationStat);

//#############################################################################
    return;
}

void main()
{
    /* Inicializaci�n de Pulsadores User 1 y User 2 */
    DLU_initPushButtons();
    /* Inicializa funci�n de medici�n de tiempos de ejecuci�n */
    DLU_initTicToc();
    /* Inicializacion BSL y AIC31 Codec */
    L138_initialise_intr(CODEC_FS, CODEC_ADC_GAIN, CODEC_DAC_ATTEN, CODEC_INPUT_CFG);
    /* Inicializaci�n de LEDs */
    DLU_initLeds();

   /* Loop infinito a espera de interrupci�n del Codec */
    while(1);
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
