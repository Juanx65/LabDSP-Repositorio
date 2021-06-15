/***************************************************************************//**
* \file     L4p2_solution.c
*
* \brief    Base para el laboratorio L4p2
*
* \authors  Javier Romero, Gonzalo Carrasco
*******************************************************************************/

/***************************************************************************//**
**      HEADER FILES
*******************************************************************************/
#include "dlu_global_defs.h"
#include "L138_LCDK_aic3106_init.h"
#include "dsp_lab_utils.h"
#include <math.h>
#include "dlu_codec_config.h"
#include "FFT_radix2.h"
#include "complex.h"

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/

/******************************************************************************
**      MODULE MACROS
******************************************************************************/
#define FREQ_ALARM  1968.75
#define AMP_ALARM  2000.0


/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/
typedef struct
{
    int16_t rightChannel;
    int16_t leftChannel;
} dataPairLR;

/******************************************************************************
**      MODULE VARIABLE DEFINITIONS
******************************************************************************/

/*---------------------------------------------------------------------------*/
/* VARIABLES AUXILIARES PARA BUFFERS DE TRANSFERENCIA DMA */
/*---------------------------------------------------------------------------*/
/*
 * Punteros a buffers ping y pong (definidos en 'L138_LCDK_aic3106_init.c')
 */
extern int16_t *pingIN, *pingOUT, *pongIN, *pongOUT;

/*
 * Flag de indicaci�n que un nuevo frame est� listo para procesarse
 */
volatile int processingBufferIsFull = 0;

/*
 * Puntero a buffer con pares de entradas Izquierdo/Derecho desde DMA
 */
int16_t *pInputPairBuffer;

/*
 * Puntero a buffer con pares de salidas Izquierdo/Derecho para DMA
 */
int16_t *pOutputPairBuffer;

/*
 * Contador de frames procesados
 */
int framesCounter = 0;

/*---------------------------------------------------------------------------*/
/* DEFINICI�N DE VARIABLES GLOBALES PARA FFT */
/*---------------------------------------------------------------------------*/

/*
 * Arreglo con muestras de se�al de alarma audible
 */
float    alarm[FFT_NPOINTS]; // alarm signal  buffer

/*
 * Vector de entrada a FFT
 */
//#pragma DATA_SECTION(input, ".EXT_RAM")
//#pragma DATA_SECTION(input, ".SHRAM")
Complex  inputFFT[FFT_NPOINTS];

/*
 * Vector de salida de FFT
 */
//#pragma DATA_SECTION(FFT, ".EXT_RAM")
//#pragma DATA_SECTION(FFT, ".SHRAM")
Complex    FFT[FFT_NPOINTS]; // FFT result    buffer

/*
 * Vector de valor absoluto de FFT
 */
float   absFFT[FFT_NPOINTS]; // FFT magnitude buffer

/*
 * Indicador de alta distorsi�n
 */
int highDistorsionDetected = 0;

/*
 * M�ximo valor de magnitud encontrado
 */
float maxFftValue;

/*
 * �ndice de la m�xima magnitud
 */
unsigned int maxFftIndex;

/*
 * Tabla para reordenar muestras
 */
unsigned int bitReverseTable[FFT_NPOINTS];

/*
 * Par�metro de detecci�n de distorsi�n
 */
float ratio = 1.0;

/*----------------------------------------------------------------------*/
// Se�ales de prueba con 8 muestras
Complex fft8TestConstant[8] =
{{1.0, 0.0},
 {1.0, 0.0},
 {1.0, 0.0},
 {1.0, 0.0},
 {1.0, 0.0},
 {1.0, 0.0},
 {1.0, 0.0},
 {1.0, 0.0}};

Complex fft8TestDeltaKronecker[8] =
{{1.0, 0.0},
 {0.0, 0.0},
 {0.0, 0.0},
 {0.0, 0.0},
 {0.0, 0.0},
 {0.0, 0.0},
 {0.0, 0.0},
 {0.0, 0.0}};

Complex fft8TestCosine[8] =
{{1.0, 0.0},
 {0.707106781186548, 0.0},
 {0.0, 0.0},
 {-0.707106781186547, 0.0},
 {-1.0, 0.0},
 {-0.707106781186547, 0.0},
 {0.0, 0.0},
 {0.707106781186547, 0.0}};

Complex fftTestImExponential[8] =
{{1.0, 0.0},
 {0.707106781186548, -0.707106781186548},
 {0.0, -1.0},
 {-0.707106781186548, -0.707106781186548},
 {-1.0, 0.0},
 {-0.707106781186548, 0.707106781186548},
 {0.0, 1.0},
 {0.707106781186548, 0.707106781186548}};

Complex fft8TestInput[8];
Complex fft8TestOutput[8];
float fft8TestMagnitud[8];

/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/
void maxValueAndIndex(unsigned int size, float *vec, float *max_val, unsigned int *max_idx);
int tooMuchDistortion(unsigned int size, int max_fft_idx,float max_fft_val,float *absFFT,float ratio);
void testingFft8(void);
interrupt void interrupt4(void);
void processFrame(void);

/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/

/***************************************************************************//**
*   \brief  MAIN
*
*   \param  Void.
*
*   \return Void.
*******************************************************************************/
int main(void)
{
    /*----------------------------------------------------------------------*/
    /* Inicializaci� de LEDs */
    DLU_initLeds();
    DLU_writeLedD4(LED_OFF);
    DLU_writeLedD5(LED_OFF);
    DLU_writeLedD6(LED_OFF);
    DLU_writeLedD7(LED_OFF);
    DLU_initTicToc();
    /*----------------------------------------------------------------------*/
    int n;
    /* Inicializaci�n de factores arreglos y par�metros */
    initTweddleFactors();

    for (n=0 ; n< FFT_NPOINTS ; n++)
    {
        /* Vector de alarma */
        alarm[n]    = AMP_ALARM*cos(2*PI*n*FREQ_ALARM/CODEC_FS);
        /* Pate imaginaria de entrada a FFT es siempre cero */
        inputFFT[n].img = 0.0;
    }

    /*----------------------------------------------------------------------*/
    /* Prueba de algoritmo FFT usando 8 puntos */
    testingFft8();

    /*----------------------------------------------------------------------*/
    // Inicializaci�n del Codec de audio
    L138_initialise_edma(CODEC_FS, CODEC_ADC_GAIN, DAC_ATTEN_0DB, CODEC_INPUT_CFG);
    /*----------------------------------------------------------------------*/
    /* Background: procesamiento FFT tras levantar bandera */
    while(1)
    {
        /* Retenci�n hasta que 'processingBufferIsFull' es alto */
        while (!processingBufferIsFull);

        /* Una vez llenado el buffer, se procesa en 'processFrame()' */
        DLU_writeLedD4(LED_ON); // Ciclo de trabajo del LED4 indica uso approx de CPU
        DLU_tic();
        processFrame();
        DLU_toc();  // Tiempo de c�mputo total del frame
        DLU_writeLedD4(LED_OFF);
    }
}

/***************************************************************************//**
*   \brief  Funci�n de procesamiento de un frame (ventana de captura).
*           Debe ser llamada desde el background en el loop infinito del main.
*
*   \param  Void.
*
*   \return Void.
*******************************************************************************/
void processFrame(void)
{
    int idxBuffer;
    framesCounter+=1;
    /*-----------------------------------------------------------------------*/
    /* Llenado del vector complejo de entrada */
    for (idxBuffer = 0; idxBuffer < (FFT_NPOINTS) ; idxBuffer++)
    {
        inputFFT[idxBuffer].real =
                (float)( ((dataPairLR *)pInputPairBuffer)[idxBuffer].leftChannel );

        /* Bypass directo del canal izquierdo de entrada al canal derecho desde
         * salida: 'InputPairBuffer' a 'OutputPairBuffer' */
        ( ((dataPairLR *)pOutputPairBuffer)[idxBuffer].rightChannel ) =
                (float)( ((dataPairLR *)pInputPairBuffer)[idxBuffer].leftChannel );
    }
    /*----------------------------------------------------------------------*/
    /* C�mputo de FFT radix-2 */
    fftRadix2(FFT_NPOINTS, inputFFT, FFT);

    /* C�mputo de magnitudes en frecuencia */
    fftMag(FFT_NPOINTS, FFT, absFFT);

    /* Obtenci�n de frecuencia fundamental, considerando que �sta tiene
     * la mayor magnitud en el vector de frecuencias.
     */
    maxValueAndIndex(FFT_NPOINTS, absFFT, &maxFftValue, &maxFftIndex);

    /*----------------------------------------------------------------------*/
    /* Detecci�n de alta distorsi�n arm�nica */
    highDistorsionDetected = tooMuchDistortion(FFT_NPOINTS, maxFftIndex, maxFftValue, absFFT, ratio);

    /*-------------------------------------------------------------------*/
    /* PARA VISUALIZAR EN GR�FICO */
    /*-------------------------------------------------------------------*/
    triggerSyncGraphBuff();
    fillGraphBuff1(highDistorsionDetected);
    fillGraphBuff2(maxFftIndex);

    /*----------------------------------------------------------------------*/
    // Escritura en el buffer de salida para el DMA
    for (idxBuffer = 0; idxBuffer < (FFT_NPOINTS) ; idxBuffer++)
    {
        /* Canal izquierdo */
        ( ((dataPairLR *)pOutputPairBuffer)[idxBuffer].leftChannel ) = (int16_t)(alarm[idxBuffer]);

        /* El canal derecho ya fue copiado */
    }
    /*----------------------------------------------------------------------*/
    /* Se baja flag */
    processingBufferIsFull = 0;
    return;
}

/***************************************************************************//**
*   \brief  Funci�n a completar para detectar distorsi�n
*
*   \param  Void.
*
*   \return Void.
*******************************************************************************/
int tooMuchDistortion(unsigned int size, int max_fft_idx,float max_fft_val,float *absFFT,float ratio)
{
    // TODO
    return 0;
}

/***************************************************************************//**
*   \brief  Funci�n pra implementar pruebas de una FFT de 8 puntos usando
*           las cuatro se�ales: constant, delta Kronecker, Cosine y Exponential
*
*   \param  Void.
*
*   \return Void.
*******************************************************************************/
void testingFft8(void)
{
    /*----------------------------------------------------------------------*/
    /* Para muestras constantes */
    fftRadix2(8, fft8TestConstant, fft8TestOutput);
    fftMag(8, fft8TestOutput, fft8TestMagnitud);

    /*----------------------------------------------------------------------*/
    /* Para muestras de delta kronecker */
    fftRadix2(8, fft8TestDeltaKronecker, fft8TestOutput);
    fftMag(8, fft8TestOutput, fft8TestMagnitud);

    /*----------------------------------------------------------------------*/
    /* Para muestras de un coseno */
    fftRadix2(8, fft8TestCosine, fft8TestOutput);
    fftMag(8, fft8TestOutput, fft8TestMagnitud);

    /*----------------------------------------------------------------------*/
    /* Para muestras de una exponencial de rotaci�n negativa */
    fftRadix2(8, fftTestImExponential, fft8TestOutput);
    fftMag(8, fft8TestOutput, fft8TestMagnitud);

}

/***************************************************************************//**
*   \brief  Funci�n que obtiene el mayor valor de un vector de flotantes, y
*           escribe dicho valor en 'max_val' y el �ndice en el vector en 'max_idx'.
*
*           Notar que la b�squeda no considera el primer elemento, para su uso en las
*           magnitudes de FFT, y as� no considerar la frecuencia 0.
*
*   \param [in]   size    : largo del vector a calcular.
*   \param [in]   *vec    : puntero a vector de flotantes.
*   \param [out]  *max_val : puntero a flotante que quedar� con valor m�ximo.
*   \param [out]  *max_idx : puntero a entero que quedar� con el �ndice valor m�ximo.
*
*   \return Void.
*******************************************************************************/
void maxValueAndIndex(unsigned int size, float *vec, float *max_val, unsigned int *max_idx){
    unsigned int idx;
    *max_val = 0.0;

    for (idx = 1; idx < (size>>1); idx++)
        if (vec[idx] > *max_val){
            *max_val = vec[idx];
            *max_idx = idx;
        }
}

/***************************************************************************//**
*   \brief  Llenado de buffers con DMA
*
*   \param  Void.
*
*   \return Void.
*******************************************************************************/
interrupt void interrupt4(void) // interrupt service routine
{
    switch(EDMA_3CC_IPR)
    {
        case 1:                     // TCC = 0
            /* currentProcessingBuffer = PING */
            pInputPairBuffer = pingIN;
            pOutputPairBuffer = pingOUT;
            EDMA_3CC_ICR = 0x0001;    // clear EDMA3 IPR bit TCC
            break;
        case 2:                     // TCC = 1
            /* currentProcessingBuffer = PONG */
            pInputPairBuffer = pongIN;
            pOutputPairBuffer = pongOUT;
            EDMA_3CC_ICR = 0x0002;    // clear EDMA3 IPR bit TCC
            break;
        default:                    // may have missed an interrupt
            EDMA_3CC_ICR = 0x0003;    // clear EDMA3 IPR bits 0 and 1
            break;
    }

    /* Se baja flag de interrupci�n */
    EVTCLR0 = 0x00000100;

    /* Se levanta flag de buffer lleno */
    processingBufferIsFull = 1;

    return;
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/

