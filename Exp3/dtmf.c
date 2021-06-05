/******************************************************************************
* \file     Lab3p2.c
*
* \brief    Experiencia 3 de laboratorio DSP ELO314
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
#include "template.h"

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/

/******************************************************************************
**      MODULE MACROS
******************************************************************************/
#define DTMF_ENV_FRAME_SIZE     (32)  // 1ms
#define DTMF_DET_LEVEL          (0.002)
#define DTMF_CH_SNR_RATE        (2.5)

/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/
/*
 * Estructura de estado de filtros biquad
 */
typedef struct bqStatus_t {
    float bqA1;
    float bqA2;
    float bqB0;
    float bqB1;
    float bqB2;
    float bqInput[3];
    float bqOutput[3];
} bqStatus_t;

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
 * Varibles de entrada y salida en formato flotante
 */
float floatCodecInputR,floatCodecInputL;
float floatCodecOutputR,floatCodecOutputL;

/*
 * Variables de estado de salida saturada
 */
int outSaturationStat = 0;

//#pragma DATA_SECTION(audioBufferR,".EXT_RAM")
//#pragma DATA_SECTION(audioBufferL,".EXT_RAM")

/*---------------------------------------------------------------------------*/
/* VARABLES DETECTOR DTMF */
/*---------------------------------------------------------------------------*/
/* Se�ales de salida para cada filtro */
float dtmfTones[7];

int32_t framePos = 0;
float tonesAmplitud[7]={0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
float tonesAmpAux[7]={0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0};
int32_t dtmfSymbol = 0;

/*---------------------------------------------------------------------------*/
/* VARABLES FILTRO NOTCH */
/*---------------------------------------------------------------------------*/
bqStatus_t tuneBsfState = { // Inicialmente para 500Hz y 100Hz de bw
0.0,                // CALCULAR PAR�METRO
0.0,                // CALCULAR PAR�METRO
0.0,                // CALCULAR PAR�METRO
0.0,                // CALCULAR PAR�METRO
0.0,                // CALCULAR PAR�METRO
{0.0, 0.0, 0.0},
{0.0, 0.0, 0.0}
};

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

      return filterBiquad(filtro_notch, input);
}

float tuneBsfOutput = 0.0;
float notchFreq     = 20.0;


/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/
float filterBiquad(bqStatus_t *filterNState, float filterInput);
void notchUpdate(float tuneFreq);
void envelopeDetector(float *tonesInputs);
void dtmfDetection(float *tonesInputs);

/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/

interrupt void interrupt4(void) // interrupt service routine
{
//#############################################################################
        /*-------------------------------------------------------------------*/
        /* LECTURA DE ENTRADAS DEL CODEC */
        /*-------------------------------------------------------------------*/
        DLU_readCodecInputs(&floatCodecInputL, &floatCodecInputR);

        /*-------------------------------------------------------------------*/
        /* Inicia medici�n de tiempo de ejecuci�n */
        DLU_tic();
        /*-------------------------------------------------------------------*/
        /* FILTRO NOTCH SINTONIZABLE */
        /*-------------------------------------------------------------------*/
        tuneBsfOutput = 0.0;

        /*-------------------------------------------------------------------*/
        /* FILTROS PARA DTMF */
        /*-------------------------------------------------------------------*/
//        dtmfTones[0] = 0.0;
//        dtmfTones[1] = 0.0;
//        dtmfTones[2] = 0.0;
//        dtmfTones[3] = 0.0;
//        dtmfTones[4] = 0.0;
//        dtmfTones[5] = 0.0;
//        dtmfTones[6] = 0.0;
//
//        dtmfDetection(dtmfTones);

        /*-------------------------------------------------------------------*/
        /* PARA VISUALIZAR EN GR�FICO */
        /*-------------------------------------------------------------------*/
        triggerSyncGraphBuff();
        fillGraphBuff1(floatCodecInputL);
        fillGraphBuff2(tuneBsfOutput);

        /*-------------------------------------------------------------------*/
        /* ESCRITURA EN SALIDA DEL CODEC */
        /*-------------------------------------------------------------------*/
        floatCodecOutputL = floatCodecInputL;
        floatCodecOutputR = tuneBsfOutput;

        /* Medici�n de tiempo de ejecuci�n */
        DLU_toc();

        outSaturationStat = DLU_writeCodecOutputs(floatCodecOutputL,floatCodecOutputR);

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
*   \brief  Esta funci�n implementa una etapa de filtro biquad
*
*   \param filterNState     : puntero a la estructura del biquad a ejecutar
*   \param filterInput      : se�al de entrada al filtro biquad a ejecutar
*
*   \return filterOutput    : se�al de salida del filtro biquad ejecutado
******************************************************************************/
float filterBiquad(bqStatus_t *filterNState, float filterInput){
    // COMPLETAR
    filterNState.bqInput[2]=filterNState.bqInput[1];
    filterNState.bqInput[1]=filterNState.bqInput[0];
    filterNState.bqInput[0]=filterInput;
    filterNState.bqOutput[2]=filterNState.bqOutput[1];
    filterNState.bqOutput[1]=filterNState.bqOutput[0];
    filterNState.bqOutput[0]=((filterNstate.bqB0*filterNState.bqInput[0]+filterNstate.bqB1*filterNstate.bqInput[1]
            +filterNstate.bqB2*filterNstate.bqInput[2])-(filterNstate.bqA1*filterNstate.bqOutput[1]
            +filterNstate.bqA2*filterNstate.bqOutput[2]);
    return filterNState.bqOutput[0];
    /* Se retorna la salida */
}

/******************************************************************************
*   \brief Esta funci�n modifica los par�metros del filtro notch para ajustar
*           su frecuencia de sinton�a. El ancho de banda en cambio se mantiene
*           constante y dependiente de la constante TUNE_BSF_D.
*
*   \param tuneFreq :  es la frecuencia de sinton�a deseada en Hz.
*
*   \return Void.
******************************************************************************/
void notchUpdate(float tuneFreq){
    // COMPLETAR
}

/******************************************************************************
*   \brief Esta funci�n permite detectar de forma sencilla la envolvente
*           de los tonos filtrados.
*           Una vez se retorna de la funci�n quedan actualizados los valores
*           de la variable 'tonesAmplitud'.

*   \param *tonesInputs : puntero a arreglo de canales filtrados
*
*   \return Void
******************************************************************************/
void envelopeDetector(float *tonesInputs) {
    int32_t idxTones;

    if( fabs( tonesInputs[0] ) > tonesAmpAux[0])
        tonesAmpAux[0] = fabs( tonesInputs[0] );
    if( fabs( tonesInputs[1] ) > tonesAmpAux[1])
        tonesAmpAux[1] = fabs( tonesInputs[1] );
    if( fabs( tonesInputs[2] ) > tonesAmpAux[2])
        tonesAmpAux[2] = fabs( tonesInputs[2] );
    if( fabs( tonesInputs[3] ) > tonesAmpAux[3])
        tonesAmpAux[3] = fabs( tonesInputs[3] );
    if( fabs( tonesInputs[4] ) > tonesAmpAux[4])
        tonesAmpAux[4] = fabs( tonesInputs[4] );
    if( fabs( tonesInputs[5] ) > tonesAmpAux[5])
        tonesAmpAux[5] = fabs( tonesInputs[5] );
    if( fabs( tonesInputs[6] ) > tonesAmpAux[6])
        tonesAmpAux[6] = fabs( tonesInputs[6] );

    framePos++;
    if ( framePos > DTMF_ENV_FRAME_SIZE )
    {
        framePos = 0;

        for (idxTones = 0; idxTones < 7; idxTones++)
        {
            tonesAmplitud[idxTones] = 0.5 * (tonesAmpAux[idxTones] + tonesAmplitud[idxTones]);
            tonesAmpAux[idxTones] = 0.0;
        }

    }

}

/******************************************************************************
*   \brief Funci�n que actualiza el estado de los leds para indicar s�mbolo
*           detectado en base a reconocer DTFM.
*           Al retornar de esta funci�n, los led se actualizan con el �ltimo
*           s�mbolo detectado.

*   \param *tonesInputs : puntero a arreglo de canales filtrados
*
*   \return Void
******************************************************************************/
void dtmfDetection(float *tonesInputs) {
    float levelAux;
    int32_t dtmf_row = 0;
    int32_t dtmf_col = 0;
    /*-----------------------------------------------------------------------*/
    /* Actualizaci�n de amplitudes */
    envelopeDetector(tonesInputs);

    /* Promedio de canales */
    levelAux = 0.143 * (tonesAmplitud[0] +
            tonesAmplitud[1] +
            tonesAmplitud[2] +
            tonesAmplitud[3] +
            tonesAmplitud[4] +
            tonesAmplitud[5] +
            tonesAmplitud[6] );
    /*-----------------------------------------------------------------------*/
    /* Detecci�n de canal bajo */
    do
    {
        /* �Ser� fila 1? */
        levelAux = tonesAmplitud[0] / (tonesAmplitud[1] + tonesAmplitud[2] +tonesAmplitud[3]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 1;
            break;
        }
        /* �Ser� fila 2? */
        levelAux = tonesAmplitud[1] / (tonesAmplitud[0] + tonesAmplitud[2] +tonesAmplitud[3]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 2;
            break;
        }
        /* �Ser� fila 3? */
        levelAux = tonesAmplitud[2] / (tonesAmplitud[1] + tonesAmplitud[0] +tonesAmplitud[3]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 3;
            break;
        }
        /* �Ser� fila 4? */
        levelAux = tonesAmplitud[3] / (tonesAmplitud[1] + tonesAmplitud[2] +tonesAmplitud[0]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_row = 4;
            break;
        }

    } while(0);

    /*-----------------------------------------------------------------------*/
    /* Detecci�n de canal alto */
    do
    {
        /* �Ser� columna 1? */
        levelAux = tonesAmplitud[4] / (tonesAmplitud[5] + tonesAmplitud[6]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_col = 1;
            break;
        }
        /* �Ser� columna 2? */
        levelAux = tonesAmplitud[5] / (tonesAmplitud[4] + tonesAmplitud[6]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_col = 2;
            break;
        }
        /* �Ser� columna 3? */
        levelAux = tonesAmplitud[6] / (tonesAmplitud[4] + tonesAmplitud[5]);
        if (levelAux > DTMF_CH_SNR_RATE)
        {
            dtmf_col = 3;
            break;
        }

    } while(0);

    /*-----------------------------------------------------------------------*/
    /* Decodificaci�n de n�mero de s�mbolo */
    if ( ( dtmf_row >= 1 ) && (dtmf_col >= 1) )
        dtmfSymbol = dtmf_col + 3*(dtmf_row - 1);
    else
        dtmfSymbol = 0;

    /*-----------------------------------------------------------------------*/
    /* Actualizaci�n de LEDs */
    if ( dtmfSymbol == 1) // S�mbolo: 1
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 2) // S�mbolo: 2
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 3) // S�mbolo: 3
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 4) // S�mbolo: 4
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 5) // S�mbolo: 5
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 6) // S�mbolo: 6
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 7) // S�mbolo: 7
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 8) // S�mbolo: 8
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 9) // S�mbolo: 9
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else if ( dtmfSymbol == 10) // S�mbolo: *
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 11) // S�mbolo: 0
    {
                    DLU_writeLedD4(LED_OFF);
                    DLU_writeLedD5(LED_OFF);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_OFF);
    }
    else if ( dtmfSymbol == 12) // S�mbolo: #
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_OFF);
                    DLU_writeLedD7(LED_ON);
    }
    else
    {
                    DLU_writeLedD4(LED_ON);
                    DLU_writeLedD5(LED_ON);
                    DLU_writeLedD6(LED_ON);
                    DLU_writeLedD7(LED_ON);
    }
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
