/******************************************************************************
* \file     dsp_lab_utils.c  Version 1.2
*
* \brief    Este archivo contiene funciones de prop�sito general para simplificar
*           tareas para varias experiencias.
*
* \authors  Gonzalo Carrasco
******************************************************************************/

/******************************************************************************
**      HEADER FILES
******************************************************************************/
#include <L138_LCDK_aic3106_init.h>  // Es mandatorio contar con las definiciones del la librer�a L138_LCDK_aic3106_init
#include "dsp_lab_utils.h"      // Encabezado de lab_dsp_utils.c
#include <c6x.h>

/******************************************************************************
**      MODULE PREPROCESSOR CONSTANTS
******************************************************************************/

/******************************************************************************
**      MODULE MACROS
******************************************************************************/

/*---------------------------------------------------------------------------*/
/* TIC-TOC */
/*---------------------------------------------------------------------------*/
#define TICTOC_TSC_NIT     (TSCL = 0;)
#define TIC_TSC(cu,cl) cl = TSCL; cu = TSCH;
#define TOC_TSC(cu,cl) cl = TSCL; cu = TSCH;

/*---------------------------------------------------------------------------*/
/* GPIOS DE LEDS EN LCDK */
/*---------------------------------------------------------------------------*/
// Configuraci�n del Pinmux para usar DSP_BSL en la LCDK
// LED D4 -> GPIO6[13]
// LED D5 -> GPIO6[12]
#define PINMUX_LCDK_LEDS_D4_D5_GPIO_OE_REG      (13)
#define PINMUX_LCDK_LEDS_D4_D5_GPIO_OE_MASK     (0x0000FF00)
#define PINMUX_LCDK_LEDS_D4_D5_GPIO_OE_VAL      (0x00008800)

// LED D6 -> GPIO2[12]
#define PINMUX_LCDK_LEDS_D6_GPIO_OE_REG         (5)
#define PINMUX_LCDK_LEDS_D6_GPIO_OE_MASK        (0x0000F000)
#define PINMUX_LCDK_LEDS_D6_GPIO_OE_VAL         (0x00008000)

// LED D7 -> GPIO0[9]
#define PINMUX_LCDK_LEDS_D7_GPIO_OE_REG         (0)
#define PINMUX_LCDK_LEDS_D7_GPIO_OE_MASK        (0x0F000000)
#define PINMUX_LCDK_LEDS_D7_GPIO_OE_VAL         (0x08000000)

/*---------------------------------------------------------------------------*/
/* GPIOS DE PULSADORES USER_1 Y USER_2 EN LCDK */
/*---------------------------------------------------------------------------*/
// Configuraci�n del Pinmux para usar DSP_BSL en la LCDK
// USER 1, S2 -> GPIO2[4]
// USER 2, S3 -> GPIO2[5]
#define PINMUX_LCDK_USER_1_USER_2_GPIO_IE_REG   (6)
#define PINMUX_LCDK_USER_1_USER_2_GPIO_IE_MASK  (0x0000FF00)
#define PINMUX_LCDK_USER_1_USER_2_GPIO_IE_VAL   (0x00008800)

#define PB_HW_PRESSED                   (0u)    // Por dise�o de la LCDK
#define PB_HW_RELEASED                  (1u)    // Por dise�o de la LCDK

#define PB_SW_PRESSED                   (1u)    // Por convenci�n.
#define PB_SW_RELEASED                  (0u)    // Por convenci�n.

#define PB_DEBOUNCE_MAXCOUNT            (10)

#define PB_STATES_STAT_P1BUFF_BIT       (0u)
#define PB_STATES_STAT_P1_PEDGE_BIT     (1u)
#define PB_STATES_STAT_P2BUFF_BIT       (2u)
#define PB_STATES_STAT_P2_PEDGE_BIT     (3u)
#define PB_STATES_STAT_P12_PEDGE_BIT    (4u)
#define PB_STATES_STAT_AUTO_INCDEC_BIT  (14u)
#define PB_STATES_STAT_WAIT_DELAY_BIT   (15u)

/* Configuraci�n Timer 2 para 'debouncing' de pushbottons
 * Notar que la librer�a 'L138_LCDK_aic3106_init' arranca el nucleo
 * a 300MHz. Los Timers reciven 150MHz.
 */

/*
 * Direcci�n base de registros del Timer2 (Timer0 y 1, definidos en
 * 'evmomapl138.h')
 */
#define TIMER2_REG_BASE                 (0x01F0C000)

/*
 * Macro para usar 'TMR2' como puntero a Estructura de registros de
 * configuraci�n
 */
#define TMR2                            ((timer_regs_t *)TIMER2_REG_BASE)

/*
 * Timer2 prescaler (solo v�lido entre [1..32] )
 */
#define TMR2_DIVISION                   (10)

/*
 * Timer2, periodo de cuenta m�xima (cercano a 995Hz de sampling)
 */
#define TMR2_PRD34                      (15075)

/*
 * Puntero a multiplexon de interrupciones
 */
#define INTC_INTMUX2                    *( unsigned int* )( 0x01800108 )


/******************************************************************************
**      MODULE DATATYPES
******************************************************************************/
/*
 * Internal states for every Input to debounce using dlu_debouncer
 */
typedef struct {
    int integral_selector;
    PB_INT_TYPE debounced;
} deb_stat;

/******************************************************************************
**      MODULE VARIABLE DEFINITIONS
******************************************************************************/

/*---------------------------------------------------------------------------*/
/* TIC-TOC */
/*---------------------------------------------------------------------------*/
extern unsigned long long DLU_timeTicToc = 0;
unsigned long long DLU_timeStampAux = 0;


/*---------------------------------------------------------------------------*/
/* PULSADORES */
/*---------------------------------------------------------------------------*/
extern uint8_t DLU_gPbUser1 = 0;
extern uint8_t DLU_gPbUser2 = 0;
extern int32_t DLU_gPbTrimmer = PB_TRIM_COUNTER_MIN;
extern uint32_t DLU_gPbToggle = 0;

deb_stat pb_user1_deb_stat = {0,0};
deb_stat pb_user2_deb_stat = {0,0};

uint32_t pb_states_stat = 0;
uint32_t pb_trim_counter_delay_count = 0;
uint32_t pb_trim_counter_autoincdec_count = 0;


/*---------------------------------------------------------------------------*/
/* BUFFER PARA GRAFICAR */
/*---------------------------------------------------------------------------*/
/*
 * Variable gatillo sincr�nico para todos los buffers
 */
extern uint32_t gSingleSyncGraph = 0;

/* Buffer1, �ndice y variable gatillo */
extern GraphTypeBuff1_t gGraphBuff1[GRAPH_BUFF_SIZE] = {0};
extern uint32_t gIdxGraphBuff1 = 0;
extern uint32_t gSingleGraphBuff1 = 0;

/* Buffer2, �ndice y variable gatillo */
extern GraphTypeBuff2_t gGraphBuff2[GRAPH_BUFF_SIZE] = {0};
extern uint32_t gIdxGraphBuff2 = 0;
extern uint32_t gSingleGraphBuff2 = 0;

/******************************************************************************
**      PRIVATE FUNCTION DECLARATIONS (PROTOTYPES)
******************************************************************************/

/******************************************************************************
*   \brief  This function debounces the input signal. This function must
*           be called at a regular rate so as to create a sampled version
*           of the input and filtered here. The debounced output only changes
*           when 'integral_select' has accumulated more than DEBOUNCE_MAXCOUNT
*           number of readings of the same state.
*
*           Every signal to be debounce using this function, must have its
*           own structure of inner states with 'deb_sta' structure.
*
*   \param  input : integer representing the binary input to be debounced.
*   \param  *ds : pointer to the structure that stores the states for the
*                 processed signal.
*   \return debounced : binary output already debounced.
******************************************************************************/
static PB_INT_TYPE DLU_debouncer(deb_stat *ds, PB_INT_TYPE input);

/******************************************************************************
*   \brief  Lee el estado del pulsador USER 1
*
*   \param Void.
*
*   \return PB_INT_TYPE     1 : pulsador presionado.
*                       0 : pulsador liberado
******************************************************************************/
static PB_INT_TYPE DLU_getPbUser1NotDebounced(void);

/******************************************************************************
*   \brief  Lee el estado del pulsador USER 2
*
*   \param Void.
*
*   \return PB_INT_TYPE     1 : pulsador presionado.
*                       0 : pulsador liberado
******************************************************************************/
static PB_INT_TYPE DLU_getPbUser2NotDebounced(void);

/******************************************************************************
*   \brief  Funci�n que inicializa el Timer2 del DSP para sus uso en leer
*           pulsadores User1 y User2. Utiliza interrupciones que tambi�n
*           son configuradas aqu�.
*
*   \param Void.
*
*   \return Void.
******************************************************************************/
static void DLU_initPbTimer2(void);

/******************************************************************************
*   \brief  Retorna el estado del pulsador USER 1, con filtro antirebote.
*
*   \param Void.
*
*   \return PB_INT_TYPE     1 : pulsador presionado.
*                       0 : pulsador liberado
******************************************************************************/
static PB_INT_TYPE DLU_getPbUser1Debounced(void);

/******************************************************************************
*   \brief  Retorna el estado del pulsador USER 2, con filtro antirebote.
*
*   \param Void.
*
*   \return PB_INT_TYPE     1 : pulsador presionado.
*                       0 : pulsador liberado
******************************************************************************/
static PB_INT_TYPE DLU_getPbUser2Debounced(void);

/******************************************************************************
*   \brief  Funci�n que interpreta la se�al de dos pulsadores para generar
*           y modificar la varable de estado "pb_toggles".
*           "pb_toggles" cuenta con tres bits:
*           PB_TOGGLES_T1_BIT cambia entre 0 y 1 con presionar pb1
*           PB_TOGGLES_T2_BIT cambia entre 0 y 1 con presionar pb2
*           PB_TOGGLES_T12_BIT  cambia entre 0 y 1 con presionar pb1 y  pb2
*           a la vez.
*
*   \param  pb_toggles :    puntero a variable entera sin signo para registrar
*                           bits de estado.
*           pb1 :   se�al del pulsador 1 (debe est�r filtrada contra rebotes)
*           pb2 :   se�al del pulsador 2 (debe est�r filtrada contra rebotes)
*
*   \return Void
******************************************************************************/
static void DLU_updatePbToggle(uint32_t *pb_toggles, PB_INT_TYPE pb1, PB_INT_TYPE pb2);

/******************************************************************************
*   \brief  Funci�n que interpreta los estados "pb_states_stat" internos de la
*           funci�n DLU_pb_toggle_update() para modificar el valor de cuenta en
*           "pb_trim_counter". Este valor entero se puede incrementar o
*           decrementar entre un rango m�ximo y m�nimo usando dos pulsadores.
*
*           SE DEBE INVOCAR SIEMPRE DESPU�S DE INVOCAR LA FUNCI�N
*           DLU_pb_toggle_update().
*
*           Al presionar pb1, la cuenta en "pb_trim_counter" se decrementa en 1
*           Al presionar pb2, la cuenta en "pb_trim_counter" se inrementa en 1
*
*           AL presionar uno de los pulsador por m�s de
*           PB_TRIM_COUNTER_DELAY_PERIOD
*           llamados de funci�n, se ingresa al modo autoincdec, que permite
*           incrementar o decrementar "pb_trim_counter" cada
*           PB_TRIM_COUNTER_AUTOINC_PERIOD llamados de funci�n.
*
*   \param  pb_trim_counter :       puntero a variable entera con signo para
*                                   registrar la cuenta de ajuste.
*                                   de estado.
*           pb_trim_counter_min :   valor de saturaci�n m�nima de la cuenta
*           pb_trim_counter_max :   valor de saturaci�n m�xima de la cuenta
*
*           "pb_trim_counter_max" debe ser siempre mayor que
*           "pb_trim_counter_min", de caso contrario, "pb_trim_counter" tomar�
*           siempre el valor "pb_trim_counter_min".
*
*   \return Void
******************************************************************************/
static void DLU_updatePbTrimCounter(int32_t *pb_trim_counter,  int32_t pb_trim_counter_delay_period, int32_t pb_trim_counter_autoinc_period, int32_t pb_trim_counter_min, int32_t pb_trim_counter_max);


/******************************************************************************
**      FUNCTION DEFINITIONS
******************************************************************************/

extern int DLU_writeCodecOutputs(float float_out_l, float float_out_r)
{
    int RetVal = 0;             // Sin saturaci�n por defecto
    AIC31_data_type codec_data;
    /*-----------------------------------------------------------------------*/
    /* Detecci�n de saturaci�n en canal izquierdo */
    if (float_out_l > 1.0)
    {
        float_out_l = 1.0;
        RetVal = 1;
    }
    else if (float_out_l < -1.0)
    {
        float_out_l = -1.0;
        RetVal = 1;
    }
    /* Detecci�n de saturaci�n en canal derecho */
    if (float_out_r > 1.0)
    {
        float_out_r = 1.0;
        RetVal = 1;
    }
    else if (float_out_r < -1.0)
    {
        float_out_r = -1.0;
        RetVal = 1;
    }
    /*-----------------------------------------------------------------------*/
    //typecasting - full range 16-bit signed integer
    codec_data.channel[LEFT]  = FLT_2_AIC(float_out_l);
    codec_data.channel[RIGHT] = FLT_2_AIC(float_out_r);
    output_sample(codec_data.uint);
    /*-----------------------------------------------------------------------*/
    return RetVal;
}

/*****************************************************************************/
extern void DLU_readCodecInputs(float *float_in_l, float *float_in_r)
{
    AIC31_data_type codec_data;
    /*-----------------------------------------------------------------------*/
    codec_data.uint = input_sample();
    *float_in_l = AIC_2_FLT( codec_data.channel[LEFT]  );
    *float_in_r = AIC_2_FLT( codec_data.channel[RIGHT] );
}

/*****************************************************************************/
extern void DLU_writeLedD4(PB_INT_TYPE value){
    // LED D4 -> GPIO6[13]
    GPIO_setOutput(GPIO_BANK6, GPIO_PIN13, value);
}

/*****************************************************************************/
extern void DLU_writeLedD5(PB_INT_TYPE value){
    // LED D5 -> GPIO6[12]
    GPIO_setOutput(GPIO_BANK6, GPIO_PIN12, value);
}

/*****************************************************************************/
extern void DLU_writeLedD6(PB_INT_TYPE value){
    // LED D6 -> GPIO2[12]
    GPIO_setOutput(GPIO_BANK2, GPIO_PIN12, value);
}

/*****************************************************************************/
extern void DLU_writeLedD7(PB_INT_TYPE value){
    // LED D7 -> GPIO0[9]
    GPIO_setOutput(GPIO_BANK0, GPIO_PIN9, value);
}

/*****************************************************************************/
extern void DLU_toggleLedD(uint32_t led){
    uint8_t old_state;
    switch(led)
    {
    case LED_D4:
        GPIO_getInput(GPIO_BANK6, GPIO_PIN13, &old_state);
        GPIO_setOutput(GPIO_BANK6, GPIO_PIN13, (uint8_t)(0x1 & (~old_state) ));
        break;
    case LED_D5:
        GPIO_getInput(GPIO_BANK6, GPIO_PIN12, &old_state);
        GPIO_setOutput(GPIO_BANK6, GPIO_PIN12, (uint8_t)(0x1 & (~old_state) ));
        break;
    case LED_D6:
        GPIO_getInput(GPIO_BANK2, GPIO_PIN12, &old_state);
        GPIO_setOutput(GPIO_BANK2, GPIO_PIN12, (uint8_t)(0x1 & (~old_state) ));
        break;
    case LED_D7:
        GPIO_getInput(GPIO_BANK0, GPIO_PIN9, &old_state);
        GPIO_setOutput(GPIO_BANK0, GPIO_PIN9, (uint8_t)(0x1 & (~old_state) ));
        break;
    default:
        break;
    }
}

/*****************************************************************************/
extern void DLU_initLeds(void){
    /*-----------------------------------------------------------------------*/
    // LED D4 -> GPIO6[13]
    // LED D5 -> GPIO6[12]
    EVMOMAPL138_pinmuxConfig(PINMUX_LCDK_LEDS_D4_D5_GPIO_OE_REG, PINMUX_LCDK_LEDS_D4_D5_GPIO_OE_MASK, PINMUX_LCDK_LEDS_D4_D5_GPIO_OE_VAL);
    GPIO_setDir(GPIO_BANK6, GPIO_PIN13, GPIO_OUTPUT);
    GPIO_setDir(GPIO_BANK6, GPIO_PIN12, GPIO_OUTPUT);
    /*-----------------------------------------------------------------------*/
    // LED D6 -> GPIO2[12]
    EVMOMAPL138_pinmuxConfig(PINMUX_LCDK_LEDS_D6_GPIO_OE_REG, PINMUX_LCDK_LEDS_D6_GPIO_OE_MASK, PINMUX_LCDK_LEDS_D6_GPIO_OE_VAL);
    GPIO_setDir(GPIO_BANK2, GPIO_PIN12, GPIO_OUTPUT);
    /*-----------------------------------------------------------------------*/
    // LED D7 -> GPIO0[9] Cuidar que la inicializaci�n dec codec configura este
    // pin con otro fin. Llamar DLU_initLeds() despu�s del
    // L138_initialise_intr()
    EVMOMAPL138_pinmuxConfig(PINMUX_LCDK_LEDS_D7_GPIO_OE_REG, PINMUX_LCDK_LEDS_D7_GPIO_OE_MASK, PINMUX_LCDK_LEDS_D7_GPIO_OE_VAL);
    GPIO_setDir(GPIO_BANK0, GPIO_PIN9, GPIO_OUTPUT);
}

/*****************************************************************************/
static PB_INT_TYPE DLU_getPbUser1NotDebounced(void){
    PB_INT_TYPE value;
    // USER 1, S2 -> GPIO2[4]
    GPIO_getInput(GPIO_BANK2, GPIO_PIN4, &value);
    if (value == PB_HW_PRESSED)
        return(PB_SW_PRESSED);
    else
        return(PB_SW_RELEASED);
}

/*****************************************************************************/
static PB_INT_TYPE DLU_getPbUser2NotDebounced(void){
    PB_INT_TYPE value;
    // USER 2, S3 -> GPIO2[5]
    GPIO_getInput(GPIO_BANK2, GPIO_PIN5, &value);
    if (value == PB_HW_PRESSED)
        return(PB_SW_PRESSED);
    else
        return(PB_SW_RELEASED);
}

/*****************************************************************************/
extern void DLU_initPushButtons(void){
    /*-----------------------------------------------------------------------*/
    // USER 1, S2 -> GPIO2[4]
    // USER 2, S3 -> GPIO2[5]
    EVMOMAPL138_pinmuxConfig(PINMUX_LCDK_USER_1_USER_2_GPIO_IE_REG, PINMUX_LCDK_USER_1_USER_2_GPIO_IE_MASK, PINMUX_LCDK_USER_1_USER_2_GPIO_IE_VAL);
    GPIO_setDir(GPIO_BANK2, GPIO_PIN4, GPIO_INPUT);
    GPIO_setDir(GPIO_BANK2, GPIO_PIN5, GPIO_INPUT);
    /* Habilita timer2 que por interrupciones lee los pulsadores */
    DLU_initPbTimer2();
}

/*****************************************************************************/
static PB_INT_TYPE DLU_debouncer(deb_stat *ds, PB_INT_TYPE input){
    /* Integration with saturation */
    if (input)
        if (++ds->integral_selector > PB_DEBOUNCE_MAXCOUNT){
            ds->integral_selector = PB_DEBOUNCE_MAXCOUNT;
            ds->debounced = PB_SW_PRESSED;
            return ds->debounced;
        }
        else
            return ds->debounced;
    else
        if (--ds->integral_selector < (-PB_DEBOUNCE_MAXCOUNT)){
            ds->integral_selector = -PB_DEBOUNCE_MAXCOUNT;
            ds->debounced = PB_SW_RELEASED;
            return ds->debounced;
        }
        else
            return ds->debounced;
}

/*****************************************************************************/
static PB_INT_TYPE DLU_getPbUser1Debounced(void){
    PB_INT_TYPE ret;
    ret = DLU_debouncer(&pb_user1_deb_stat, DLU_getPbUser1NotDebounced() );
    return(ret);
}

/*****************************************************************************/
static PB_INT_TYPE DLU_getPbUser2Debounced(void){
    PB_INT_TYPE ret;
    ret = DLU_debouncer(&pb_user2_deb_stat, DLU_getPbUser2NotDebounced() );
    return(ret);
}

/*****************************************************************************/
static void DLU_updatePbToggle(uint32_t *pb_toggles, PB_INT_TYPE pb1, PB_INT_TYPE pb2){
    /*-----------------------------------------------------------------------*/
    // Detectando canto de subida en pb1
    if ( ( pb1 == PB_SW_PRESSED ) && ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P1BUFF_BIT) == PB_SW_RELEASED ) )
        pb_states_stat |= (1 << PB_STATES_STAT_P1_PEDGE_BIT );
    else
        pb_states_stat &= ~(1 << PB_STATES_STAT_P1_PEDGE_BIT );
    /*-----------------------------------------------------------------------*/
    // Actualizaci�n del estado Toggle 1
    if ( pb_states_stat & ( 1 << PB_STATES_STAT_P1_PEDGE_BIT ) )
        *pb_toggles ^= ( 1 << PB_TOGGLES_T1_BIT );
    /*-----------------------------------------------------------------------*/
    /*-----------------------------------------------------------------------*/
    // Detectando canto de subida en pb2
    if ( ( pb2 == PB_SW_PRESSED ) && ( ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P2BUFF_BIT) == PB_SW_RELEASED ) ) )
        pb_states_stat |= (1 << PB_STATES_STAT_P2_PEDGE_BIT );
    else
        pb_states_stat &= ~(1 << PB_STATES_STAT_P2_PEDGE_BIT );
    /*-----------------------------------------------------------------------*/
    // Actualizaci�n del estado Toggle 1
    if ( pb_states_stat & ( 1 << PB_STATES_STAT_P2_PEDGE_BIT ) )
        *pb_toggles ^= ( 1 << PB_TOGGLES_T2_BIT );
    /*-----------------------------------------------------------------------*/
    /*-----------------------------------------------------------------------*/
    // Detectando canto de presionar pb1 y pb2
    if (       ( pb1 == PB_SW_PRESSED )
            && ( pb2 == PB_SW_PRESSED )
            && (    ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P1BUFF_BIT) == PB_SW_RELEASED ) ||
                    ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P2BUFF_BIT) == PB_SW_RELEASED )    )  )
        pb_states_stat |= (1 << PB_STATES_STAT_P12_PEDGE_BIT );
    else
        pb_states_stat &= ~(1 << PB_STATES_STAT_P12_PEDGE_BIT );
    /*-----------------------------------------------------------------------*/
    // Actualizaci�n del estado Toggle 12
    if ( pb_states_stat & ( 1 << PB_STATES_STAT_P12_PEDGE_BIT ) )
        *pb_toggles ^= ( 1 << PB_TOGGLES_T12_BIT );
    /*-----------------------------------------------------------------------*/
    /*-----------------------------------------------------------------------*/
    // Limpiando buffers
    pb_states_stat &= ~(1 << PB_STATES_STAT_P1BUFF_BIT );
    pb_states_stat &= ~(1 << PB_STATES_STAT_P2BUFF_BIT );
    // Actualizaci�n de buffers
    pb_states_stat |= ( (uint32_t)pb1 << PB_STATES_STAT_P1BUFF_BIT );
    pb_states_stat |= ( (uint32_t)pb2 << PB_STATES_STAT_P2BUFF_BIT );
}

/*****************************************************************************/
static void DLU_updatePbTrimCounter(int32_t *pb_trim_counter, int32_t pb_trim_counter_delay_period, int32_t pb_trim_counter_autoinc_period, int32_t pb_trim_counter_min, int32_t pb_trim_counter_max){
    // Solo un pulsador prsonado a la vez iniciar� la cuenta del retardo para incrementar
    if ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P1BUFF_BIT) ^ DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P2BUFF_BIT) )
    {
        if ( !DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_AUTO_INCDEC_BIT) )
            pb_trim_counter_delay_count++;

        if (pb_trim_counter_delay_count > pb_trim_counter_delay_period)
            pb_states_stat |= ( 1 << PB_STATES_STAT_AUTO_INCDEC_BIT );
    }
    else
    {
        pb_trim_counter_delay_count = 0;
        pb_states_stat &= ~( 1 << PB_STATES_STAT_AUTO_INCDEC_BIT );
    }
    /*-----------------------------------------------------------------------*/
    // Autoincremento o por pulsos manuales
    if ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_AUTO_INCDEC_BIT) )
    {
        // Modo autoincremento
        pb_trim_counter_autoincdec_count++;
        if ( pb_trim_counter_autoincdec_count > pb_trim_counter_autoinc_period )
        {
            pb_trim_counter_autoincdec_count = 0;
            // Autoincrementa solo cuando ha transcurrido el periodo de autoincremento
            if ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P2BUFF_BIT) )
                (*pb_trim_counter)++;
            if ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P1BUFF_BIT) )
                (*pb_trim_counter)--;
        }
    }
    else
    {
        // Modo pulsos manuales
        if ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P2_PEDGE_BIT) )
            (*pb_trim_counter)++;
        if ( DLU_GET_REG_BIT(pb_states_stat, PB_STATES_STAT_P1_PEDGE_BIT) )
            (*pb_trim_counter)--;
    }
    /*-----------------------------------------------------------------------*/
    // Saturaci�n
    if ( *pb_trim_counter > pb_trim_counter_max )
        *pb_trim_counter = pb_trim_counter_max;
    if ( *pb_trim_counter < pb_trim_counter_min )
        *pb_trim_counter = pb_trim_counter_min;
}

/*****************************************************************************/
extern void DLU_initTicToc(void){
    TSCL = 0;
}

/*****************************************************************************/
extern void DLU_tic(void){
    unsigned int aux;
    aux = TSCL;
    DLU_timeStampAux = ((unsigned long long)TSCH << 32);
    DLU_timeStampAux += (unsigned long long)aux;
}

/*****************************************************************************/
extern void DLU_toc(void){
    unsigned int aux;
    unsigned long long aux_long;

    aux = TSCL;
    aux_long = ((unsigned long long)TSCH << 32);
    aux_long += (unsigned long long)aux;

    DLU_timeTicToc = aux_long - DLU_timeStampAux;
}

/*****************************************************************************/
static void DLU_initPbTimer2(void)
{
    /* Configura Timer2 cuenta libre. */
    /* Timer2 doble no encadenado, se usa la parte Timer2 34 */

    /* Posibles pines de entrada y salida del timer se dejan como libres para
     * GPIO */
   TMR2->GPINT_GPEN = GPENO12 | GPENI12;
   TMR2->GPDATA_GPDIR = GPDIRO12 | GPDIRI12;

   // stop and reset timer.
   TMR2->TGCR = 0x00000000;
   TMR2->TCR = 0x00000000;

   /* Habilitar interrupci�n por periodo en Timer2 12 */
   TMR2->INTCTLSTAT = PRDINTEN34;
   /* Que en modo emulaci�n siga contando el timer */
   SETBIT(TMR2->EMUMGT, SOFT | FREE);

   /* Timer2 como contador doble de 32 bits, no encadenados */
   /* Se libera el Timer2 34 de reset */
   SETBIT(TMR2->TGCR, PRESCALER(TMR2_DIVISION - 1) | TIMMODE_32BIT_UNCHAINED | TIM34RS );

   /* Inicializaci�n en cero */
   TMR2->TIM34 = 0x00000000;
   /* Carga del valor de pediodo de la cuenta */
   TMR2->PRD34 = TMR2_PRD34;

   /* Habilitaci�n de cuenta continua */
   SETBIT(TMR2->TCR, ENAMODE34_CONT);

   /*------------------------------------------------------------------------*/
   /* Limpia bit de interrupci�n */
   CLRBIT(TMR2->INTCTLSTAT, PRDINTSTAT34);

   /* Se asocia evento de interrupci�n por T64P_34n(evento 25: T64P2_TINTALL)
    * con la interrupci�n 8
    */
   INTC_INTMUX2 = 0x00000019;

   /*------------------------------------------------------------------------*/
   /* Configuraci�n global de interrupciones*/
   ISTP = (unsigned int)vectors;

   // clear all pending interrupt flags
   // interrupt clear register ICR is used to clear bits in interrupt flag register IFR
   ICR = 0xFFF0;  // ICR bits 3, 2, 1, and 0 are reserved, read as 0, write has no effect
   IER |= 0x102;  //enable NMI (bit 1) and INT4 (bit 8)

   CSR |= 0x01;  // enable interrupts globally

}

/*****************************************************************************/
interrupt void int8_pb(void)
{
    // Obtenci�n de nivel de pulsadores (con antirebote)
    DLU_gPbUser1 = DLU_getPbUser1Debounced();
    DLU_gPbUser2 = DLU_getPbUser2Debounced();
    // Generaci�n de estados "pb_toggles" y cuenta de ajuste "pb_trim_counter" con los pulsadores
    DLU_updatePbToggle(&DLU_gPbToggle, DLU_gPbUser1, DLU_gPbUser2);
    DLU_updatePbTrimCounter(&DLU_gPbTrimmer,  PB_TRIM_COUNTER_DELAY_PERIOD, PB_TRIM_COUNTER_AUTOINC_PERIOD, PB_TRIM_COUNTER_MIN, PB_TRIM_COUNTER_MAX);
}

/*****************************************************************************/
extern void fillGraphBuff1(GraphTypeBuff1_t variable){
    /* Esritura en buffer de gr�fico */
    if (gSingleGraphBuff1)
    {
        gGraphBuff1[gIdxGraphBuff1] = variable;
        gIdxGraphBuff1++;
        if (gIdxGraphBuff1 >= GRAPH_BUFF_SIZE)
        {
            gSingleGraphBuff1 = 0;
            gIdxGraphBuff1 = 0;
        }
    }
}

/*****************************************************************************/
extern void fillGraphBuff2(GraphTypeBuff2_t variable){
    /* Esritura en buffer de gr�fico */
    if (gSingleGraphBuff2)
    {
        gGraphBuff2[gIdxGraphBuff2] = variable;
        gIdxGraphBuff2++;
        if (gIdxGraphBuff2 >= GRAPH_BUFF_SIZE)
        {
            gSingleGraphBuff2 = 0;
            gIdxGraphBuff2 = 0;
        }
    }
}

/*****************************************************************************/
extern void triggerSyncGraphBuff(void){
    if(gSingleSyncGraph)
    {
        /* Sube todos los gatillos de buffers */
        gSingleGraphBuff1 = 1;
        gSingleGraphBuff2 = 1;
        /* Baja gatillo sincr�nico */
        gSingleSyncGraph = 0;
    }
}

/******************************************************************************
**      END OF SOURCE FILE
******************************************************************************/
