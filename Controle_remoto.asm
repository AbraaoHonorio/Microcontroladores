;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS ABRAO ALLYSSON - 11321939                 *
;*                    AGOSTO DE 2018                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        Semáforo de trânsito                     *
;*                                                                 *
;*         DESENVOLVIDO POR ABRAÃO ÁLLYSSON                        *
;*   VERSÃO: 1.0                           DATA: 01/08/18          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_OFF & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES

		;NOVAS VARIÁVEIS 
		TEMP ; variável do primeiro ciclo(DELAY)
		TEMP_2 ; variável do segundo ciclo(DELAY_2)
		TEMP_3 ; variável do terceiro ciclo(DELAY_2)
		TEMP100 ; variável do primeiro ciclo(DELAY100)
		TEMP100_2; variável do primeiro ciclo(DELAY100_2)
		PACOTE ; variavel que vai receber o pacote de comunicação
		CONTADOR_7 ; CONTADOR PARA PEGAR OS PULSOS
		
		
	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

;tempo de espera para transição que é de 900 ms
DELAY
	MOVLW	.58 ; passando 58 para work | w = 58
	MOVWF	TEMP ; passando work para temp | temp = work(58)
	MOVLW	.247 ; passando 235 para work | w = 247
	MOVWF	TEMP_2 ; passando work para temp | temp = work(247)
	MOVLW	.2 ; passando 235 para work | w = 2
	MOVWF	TEMP_3 ; passando work para temp | temp = work(2)
DELAY_2
	DECFSZ	TEMP, f ; verifica se o TEMP é 0 caso não for ele pula duas linhas, ou seja volta para DELAY_2
	GOTO	$+2 ; pulando duas linhas
	DECFSZ	TEMP_2, f ; quando TEMP é 0 vai cair e vai decrementar de TEMP_2 até que ele seja 0 e quando for ele vai retornar
	GOTO 	$+2;
	DECFSZ	TEMP_3, f 
	GOTO	DELAY_2

	GOTO	$+1 ; pula uma linha
	NOP ; gasta um tempo de maquina
	
	RETURN


;tempo de espera para transição que é de 900 ms
DELAY_INICIO
	MOVLW	.209 ; passando 58 para work | w = 58
	MOVWF	TEMP ; passando work para temp | temp = work(58)
	MOVLW	.79 ; passando 235 para work | w = 247
	MOVWF	TEMP_2 ; passando work para temp | temp = work(247)
	MOVLW	.2 ; passando 235 para work | w = 2
	MOVWF	TEMP_3 ; passando work para temp | temp = work(2)
DELAY_INICIO_2
	DECFSZ	TEMP, f ; verifica se o TEMP é 0 caso não for ele pula duas linhas, ou seja volta para DELAY_2
	GOTO	$+2 ; pulando duas linhas
	DECFSZ	TEMP_2, f ; quando TEMP é 0 vai cair e vai decrementar de TEMP_2 até que ele seja 0 e quando for ele vai retornar
	GOTO 	$+2;
	DECFSZ	TEMP_3, f 
	GOTO	DELAY_INICIO_2

	GOTO	$+1 ; pula uma linha
	NOP ; gata um tempo de maquina
	
	RETURN
PEGA_0 
BCF STATUS, C
RRF PACOTE
CALL ESPERA_SUBIR
CALL ESPERA_DESCER
CALL DELAY
GOTO PULA_SINAL ; volta para main

PEGA_1 ; pegando o valor 1
BSF STATUS, C ; setando o valor de status
RRF PACOTE ; rotacionanodo o pacote
CALL ESPERA_SUBIR
CALL ESPERA_DESCER
CALL DELAY
GOTO PULA_SINAL ; volta para main

ESPERA_SUBIR  ; esperando subir
BTFSS GPIO,GP3 ;testa se o GP3 é um
GOTO $-1
RETURN


ESPERA_DESCER ; esperando a descer
BTFSC GPIO,GP3 ;testa se o GP3 é zero
GOTO $-1
RETURN

DELAY_2400
CALL DELAY ; Delay de 900
CALL DELAY ; Delay de 900
CALL DELAY_INICIO ;Delay 600
RETURN


Delay100
			
	MOVLW	30
	MOVFW	TEMP100
	MOVLW	79
	MOVFW	TEMP100_2
Delay100_0
	DECFSZ	TEMP100, f
	GOTO	$+2
	DECFSZ	TEMP100_2, f
	GOTO	Delay100_0

			
	goto	$+1
	nop
	return
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00001000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000011' ; colocando o valor de 1:16
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	CALL 	0X3FF ;	chamando a memoria que esta no bank1
	MOVWF	OSCCAL ; calibrando o microcontrolador
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	MOVLW	.255		; work vai receber 255 
	MOVWF 	TEMP     	; TEMP rece o work
	MOVLW	.235		; work vai receber 235
	MOVWF 	TEMP_2	; TEMP_2 rece o work
	MOVLW	.255		; work vai receber 255
	MOVWF 	TEMP_3	; TEMP_3 rece o work
	MOVLW	.0		; work vai receber 0
	MOVWF 	PACOTE	; PACOTE recebe o work
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	 
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
   ;só vai para loop se tiver descida 
	BTFSC GPIO,GP3 ;SE FOR ZERO PARA O DELAY
	GOTO $-1
	
	;loop do StartBit
	MOVLW .106
	MOVWF TMR0 ; TMR0 = 106
	BCF INTCON, T0IF
	BTFSS INTCON, T0IF ;  aqui eu testo o timer caso for 1 ele pula uma instrução
	GOTO $-1
	BCF INTCON, T0IF ; limpando o estouro do timer 0

	
	; pega os 7 bits seguinte 
	BTFSC GPIO,GP3 ;SE FOR ZERO PARA O DELAY
	GOTO $-1
	CALL DELAY ; esperando o sinal(Delay de 900) Para pode pegar no meio do PACOTE
	
	; entrando para leitura do sinal
	MOVLW	.7 ; passando 7 para work | w = 7
	MOVWF	CONTADOR_7 ; passando work para CONTADOR_7 | CONTADOR_7 = CONTADOR_7(7)
	MAIN_RECEPTOR
	BTFSC GPIO,GP3
	GOTO PEGA_0 ; Ler o PACOTE quando estiver em baixa(0) Até que tenha uma SUBIDA
	GOTO PEGA_1 ; Ler o PACOTE quando estiver em alta(1)  Até que tenha uma DESCIDA
	
	PULA_SINAL
	DECFSZ CONTADOR_7 ; contador para contar 7 vezes
 	GOTO MAIN_RECEPTOR	
   
   ;quando pssar dos 7 bits ele vai acrescentar o oitavo bit
    BCF STATUS, C
    RRF PACOTE
    
    
    ; printando o numero apertado no controle 
    ; verifica se é 9
    MOVLW .9
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_0

    ; verifica se é 8
    MOVLW .8
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_9
   
    
    ; verifica se é 7
    MOVLW .7
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_6
    
    ; verifica se é 6
    MOVLW .6
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_5
    
    ; verifica se é 5
    MOVLW .5
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_4

    ;verifica se é 4
    MOVLW .4
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_3

    ; verifica se é 3
    MOVLW .3
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_2
    
     ; verifica se é 2
    MOVLW .2
    SUBWF PACOTE,W
    BTFSC STATUS, Z
    GOTO DISPLAY_1
    
     ; verifica se foi qualquer outra tecla
    GOTO LIGA_GP5
  	
    LIGA_GP5
   ;  setando valor do GP5
    BSF GPIO,GP5
    CALL Delay100	
    GOTO MAIN
    
  DISPLAY_9
   ;  setando valor de 9
    BSF GPIO,GP1	
    BSF GPIO,GP2   
    BCF GPIO,GP4	
    BSF GPIO,GP5	
    GOTO MAIN
    
    DISPLAY_8
    ; setando valor de 8
    BCF GPIO,GP1	
    BCF GPIO,GP2	
    BCF GPIO,GP4	
    BSF GPIO,GP5	
    GOTO MAIN
    
    DISPLAY_7
    ;  setando valor de 7
    BSF GPIO,GP1	
    BSF GPIO,GP2	
    BSF GPIO,GP4	
    BCF GPIO,GP5	
    GOTO MAIN
    
    DISPLAY_6
    ; setando valor de 6
    BCF GPIO,GP1	
    BSF GPIO,GP2
    BSF GPIO,GP4
    BCF GPIO,GP5
    GOTO MAIN
    
  DISPLAY_5
    ;  setando valor de 5
    BSF GPIO,GP1	
    BCF GPIO,GP2
    BSF GPIO,GP4
    BCF GPIO,GP5
    GOTO MAIN
    
    DISPLAY_4
    ; setando valor de 4
    BCF GPIO,GP1	
    BCF GPIO,GP2
    BSF GPIO,GP4
    BCF GPIO,GP5
    GOTO MAIN 
   
   DISPLAY_3
    ; setando valor de 3
    BSF GPIO,GP1	
    BSF GPIO,GP2
    BCF GPIO,GP4
    BCF GPIO,GP5
    GOTO MAIN
    
    DISPLAY_2
    ; setando valor de 2
    BCF GPIO,GP1	
    BSF GPIO,GP2
    BCF GPIO,GP4
    BCF GPIO,GP5
    GOTO MAIN	
   
    DISPLAY_1
    ; setando valor de 1 
    BSF GPIO,GP1	
    BCF GPIO,GP2
    BCF GPIO,GP4
    BCF GPIO,GP5
    GOTO MAIN
    
   DISPLAY_0
    ;  setando valor de 0 
    BCF GPIO,GP1	
    BCF GPIO,GP2
    BCF GPIO,GP4
    BCF GPIO,GP5
    GOTO MAIN
    
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END