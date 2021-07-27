/******************************************************************************
* \file     Lab1p2_solucion.c
*
* \brief    Experiencia 2 de laboratorio DSP ELO314
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
#include "phaser_func.h"

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

/*---------------------------------------------------------------------------*/
/* ENTRADAS Y SALIDAS DEL AIC CODEC */
/*---------------------------------------------------------------------------*/

/*
 * Varibles de entrada y salida en formato flotante
 */
float gFloatCodecInputR, gFloatCodecInputL;
float gFloatCodecOutputR, gFloatCodecOutputL;

/*
 * Variables de estado de salida saturada
 */
int gOutSaturationStat = 0;

/*---------------------------------------------------------------------------*/
/* EFECTO DE AUDIO ELEFIDO: PHASER */
/*---------------------------------------------------------------------------*/
float gPhaserLfoSpeed = 0.8;
int32_t gPhaserFbEn = 0;

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
        DLU_readCodecInputs(&gFloatCodecInputL, &gFloatCodecInputR);

        /*-------------------------------------------------------------------*/
        /* Inicia medici�n de tiempo de ejecuci�n */
        DLU_tic();

        /*-------------------------------------------------------------------*/
        /* EFECTO DE AUDIO PHASER */
        /*-------------------------------------------------------------------*/
        gPhaserLfoSpeed = ((float)DLU_gPbTrimmer) / (float)PB_TRIM_COUNTER_MAX;
        gPhaserFbEn = DLU_GET_REG_BIT(DLU_gPbToggle, PB_TOGGLES_T12_BIT);

        phaser_fx_stereo(gFloatCodecInputL, gFloatCodecInputR, gPhaserLfoSpeed, gPhaserFbEn, TS);
        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GR�FICO */
        /*-------------------------------------------------------------------*/
        //if ( (DLU_gPbUser1 == 1) && ( gSingleGraphBuff1 == 0) )
        {
            gSingleGraphBuff1 = 1;
            gSingleGraphBuff2 = 1;
        }
        fillGraphBuff1(gFloatCodecInputL);
        fillGraphBuff2(phaser_audio_l_out);

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        gFloatCodecOutputL = phaser_audio_l_out;
        gFloatCodecOutputR = phaser_audio_r_out;

        //gFloatCodecOutputL = gFloatCodecInputL;
        //gFloatCodecOutputR = gFloatCodecInputR;

        gOutSaturationStat = DLU_writeCodecOutputs(gFloatCodecOutputL,gFloatCodecOutputR);
        DLU_writeLedD4((PB_INT_TYPE)gOutSaturationStat);

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

    /*-------------------------------------------------------------------*/
    /* INICIALIZACI�N DE COEFICINTES PARA DELAY MULTITAP */
    /*-------------------------------------------------------------------*/


   /* Loop infinito a espera de interrupci�n del Codec */
    while(1);
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
