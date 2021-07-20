/******************************************************************************
* \file     dsp_lab_utils.h  Version 1.2
*
* \brief    Este archivo contiene funciones de propósito general para
*           simplificar tareas para varias experiencias.
*
* \authors  Gonzalo Carrasco
******************************************************************************/
#ifndef DSP_LAB_UTILS_H
#define DSP_LAB_UTILS_H
/*****************************************************************************/

/******************************************************************************
**      INCLUDES
******************************************************************************/

/******************************************************************************
**      PREPROCESSOR CONSTANTS
******************************************************************************/

/******************************************************************************
**      CONFIGURATION CONSTANTS
******************************************************************************/

/*---------------------------------------------------------------------------*/
/* GPIOS DE LEDS EN LCDK */
/*---------------------------------------------------------------------------*/
/* Parámetros 'value' para funciones
 * DLU_writeLedD4(),
 * DLU_writeLedD5(),
 * DLU_writeLedD6() y
 * DLU_writeLedD7()
 */
#define LED_ON                                  (1)
#define LED_OFF                                 (0)

/* Parámetros 'led' para función
 * DLU_toggleLedD
 */
#define LED_D4                                  (4)
#define LED_D5                                  (5)
#define LED_D6                                  (6)
#define LED_D7                                  (7)

/*---------------------------------------------------------------------------*/
/* GPIOS DE PULSADORES USER_1 Y USER_2 EN LCDK */
/*---------------------------------------------------------------------------*/
/*
 * Asignación de bits de estado PbToggle
 */
#define PB_TOGGLES_T1_BIT                       (0u)
#define PB_TOGGLES_T2_BIT                       (1u)
#define PB_TOGGLES_T12_BIT                      (2u)

/*---------------------------------------------------------------------------*/
/* CODEC */
/*---------------------------------------------------------------------------*/
/*
 * Ancho de palabra fijo del CODEC para la librería L138_LCDK_aic3106
 */
#define CODEC_WORD_LENGTH   16


/******************************************************************************
**      MACRO DEFINITIONS
******************************************************************************/
/* Constantes más usadas */
#define M_PI          3.141592653589793

/* Macro Typecasting CODEC a flotante */
#define AIC_2_FLT(x)    ( (float)(x)  * ( 1.0 / ( (1 << (CODEC_WORD_LENGTH-1)) - 1.0) ) );
#define FLT_2_AIC(x)    ( (int16_t)(x * ( (1 << (CODEC_WORD_LENGTH-1)) - 1) ) );

/* MAcro para obtener valor de un bit en un registro */
#define DLU_GET_REG_BIT(reg,b_position)     ( ( reg & ( 1 << b_position ) ) >> b_position )

/******************************************************************************
**      PUBLIC DATATYPES
******************************************************************************/
/*
 * Definción del tipo para funciones de PushBottons
 */
typedef uint8_t     PB_INT_TYPE;

/******************************************************************************
**      PUBLIC (GLOBAL) VARIABLES DECLARATIONS
******************************************************************************/

/*---------------------------------------------------------------------------*/
/* BUFFER PARA GRAFICAR */
/*---------------------------------------------------------------------------*/
/*
 * Variable gatillo sincrónico para todos los buffers
 */
extern uint32_t gSingleSyncGraph;

/* Buffer1, índice y variable gatillo */
extern GraphTypeBuff1_t gGraphBuff1[GRAPH_BUFF_SIZE];
extern uint32_t gIdxGraphBuff1;
extern uint32_t gSingleGraphBuff1;

/* Buffer2, índice y variable gatillo */
extern GraphTypeBuff2_t gGraphBuff2[GRAPH_BUFF_SIZE];
extern uint32_t gIdxGraphBuff2;
extern uint32_t gSingleGraphBuff2;

/*---------------------------------------------------------------------------*/
/* PULSADORES */
/*---------------------------------------------------------------------------*/
/*
 * Estado actual del pulsador User1 (rebote filtrado)
 */
extern uint8_t DLU_gPbUser1;

/*
 * Estado actual del pulsador User2 (rebote filtrado)
 */
extern uint8_t DLU_gPbUser2;

/*
 * Variable auxiliar para ajuestes, controlado por pulsaodres User1 y User2
 * User2: incrementa el valor
 * User1: decrementa el valor
 * Cualquiera que se mantenga presionado por más de 1 segundo, causará
 * un incremento o decremento automático rápido.
 * Ver parámetros en 'dlu_global_defs.h'
 */
extern int32_t DLU_gPbTrimmer;

/*
 * Variable de estados que cambian con los pulsadores User1 y User2
 * DLU_gPbToggle[PB_TOGGLES_T1_BIT] : es un bit que cambia con User1
 * DLU_gPbToggle[PB_TOGGLES_T2_BIT] : es un bit que cambia con User2
 * DLU_gPbToggle[PB_TOGGLES_T12_BIT] : es un bit que cambia al presionar
 *   simultáneamente User1 y User2.
 */
extern uint32_t DLU_gPbToggle;

/*---------------------------------------------------------------------------*/
/* TIC-TOC */
/*---------------------------------------------------------------------------*/
/*
 * Variable para medición de tiempos de ejecución.
 */
extern unsigned long long DLU_timeTicToc;

/******************************************************************************
**      PUBLIC FUNCTION PROTOTYPES
******************************************************************************/
#ifdef __cplusplus
extern "C" {
#endif
/*****************************************************************************/

/******************************************************************************
*   \brief  Declaración de puntero a tabla de vectores de interrupción
*           definido en vectors.asm
******************************************************************************/
extern void vectors(void);

/******************************************************************************
*   \brief  Abstracción de la escritura al codec y casteo a entero de ambos
*           canales con datos en tipo flotantes.
*
*   \param  float_out_l : salida izquierda normalizada [-1..1]
*   \param  float_out_r : salida derecha normalizada [-1..1]
*
*   \return Void.
******************************************************************************/
extern int DLU_writeCodecOutputs(float float_out_l, float float_out_r);

/******************************************************************************
*   \brief  Abstracción de la lectura de ambos canales del codec y
*           casteo a flotante.
*
*   \param  *float_in_l : puntero a destino de entrada izquierda normalizada
*   \param  *float_in_r : puntero a destino de entrada derecha normalizada
*
*   \return Void.
******************************************************************************/
extern void DLU_readCodecInputs(float *float_in_l, float *float_in_r);

/******************************************************************************
*   \brief  Establece estado del LED D4
*
*   \param value    : LED_OFF - Apagado
*                   : LED_ON - Encendido
*
*   \return Void.
******************************************************************************/
extern void DLU_writeLedD4(PB_INT_TYPE value);

/******************************************************************************
*   \brief  Establece estado del LED D5
*
*   \param value    : LED_OFF - Apagado
*                   : LED_ON - Encendido
*
*   \return Void.
******************************************************************************/
extern void DLU_writeLedD5(PB_INT_TYPE value);

/******************************************************************************
*   \brief  Establece estado del LED D6
*
*   \param value    : LED_OFF - Apagado
*                   : LED_ON - Encendido
*
*   \return Void.
******************************************************************************/
extern void DLU_writeLedD6(PB_INT_TYPE value);

/******************************************************************************
*   \brief  Establece estado del LED D7
*
*   \param value    : LED_OFF - Apagado
*                   : LED_ON - Encendido
*
*   \return Void.
******************************************************************************/
extern void DLU_writeLedD7(PB_INT_TYPE value);

/******************************************************************************
*   \brief  Cambia el estado actual del LED indicado a su complemento
*
*   \param led      : LED_D4 - Cambia led D4
*                   : LED_D5 - Cambia led D5
*                   : LED_D6 - Cambia led D6
*                   : LED_D7 - Cambia led D7
*
*   \return Void.
******************************************************************************/
extern void DLU_toggleLedD(uint32_t led);

/******************************************************************************
*   \brief  Habilita el uso de los leds, D4, D5, D6 y D7.
*
*           Configura El pinmux y la dirección de los GPIOs correspondientes
*           a los LEDs D4, D5, D6 y D7 como salidas.
*
*   \param Void.
*
*   \return Void.
******************************************************************************/
extern void DLU_initLeds(void);

/******************************************************************************
*   \brief  Habilita el uso de los pulsadores User1 y User2.
*
*           Configura El pinmux y la dirección de los GPIOs correspondientes
*           a los pulsadores S2 (USER 1) y S3 (USER 2) como entradas.
*
*   \param Void.
*
*   \return Void.
******************************************************************************/
extern void DLU_initPushButtons(void);

/******************************************************************************
*   \brief  Habilita el uso de funciones DLU_tic y DLU_toc.
*
*           Función que inicializa el Time Stamp Counter de la CPU
*
*   \param Void.
*
*   \return Void.
******************************************************************************/
extern void DLU_initTicToc(void);

/******************************************************************************
*   \brief Función que registra time-stamp inicial
*
*   \param *tsc_samp :   es el puntero a un entero sin signo de 64
*                       bits donde de registrará el tiempo inicial (con TIC) y
*                       tiempo final (con TOC).
*
*   \return Void.
******************************************************************************/
extern void DLU_tic(void);

/******************************************************************************
*   \brief  Función que captura el time-stamp actual y calcula la diferencia
*           con el valor inicial registrado con TIC, dejando la diferencia en
*           cuentas entre TIC y TOC en la variable apuntada por el parámetro de
*           esta función.
*
*   \param *tsc_samp : es el puntero a un entero sin signo de 64
*                       bits donde se registrará la diferencia en cuentas entre
*                       TIC y TOC. Las cuentas ocurren a la frecuencia del CPU.
*
*   \return Void.
******************************************************************************/
extern void DLU_toc(void);

/******************************************************************************
*   \brief  Función que llena gGraphBuff1 con valores de variable entregada
*           luego de levantar la señal gatillo 'gSingleGraphBuff1'
*
*   \param variable : Valor a ingresar al buffer de gráfico 1
*
*   \return Void.
******************************************************************************/
extern void fillGraphBuff1(GraphTypeBuff1_t variable);

/******************************************************************************
*   \brief  Función que llena gGraphBuff2 con valores de variable entregada
*           luego de levantar la señal gatillo 'gSingleGraphBuff2'
*
*   \param variable : Valor a ingresar al buffer de gráfico 2
*
*   \return Void.
******************************************************************************/
extern void fillGraphBuff2(GraphTypeBuff2_t variable);


/******************************************************************************
*   \brief  Función que levanta gatillos de todos los gráficos con subir el
*           gatillo general 'gSingleSyncGraph'
*
*   \return Void.
******************************************************************************/
extern void triggerSyncGraphBuff(void);

/*****************************************************************************/
#ifdef __cplusplus
}
#endif
#endif
/******************************************************************************
**      END OF HEADER FILE
******************************************************************************/
