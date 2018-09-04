;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA
#DEFINE	SRCLK	GPIO,GP0
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		TEMP
		TEMP_1
		ROTACIONAR
		;NOVAS VARIÁVEIS

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

;FAZENDO OS DELAYS NECESSÁRIOS 
DELAY_17MS
	MOVLW	.70
	MOVWF 	TEMP
	MOVLW 	.14
	MOVWF 	TEMP_1
DELAY0_17MS
	DECFSZ	TEMP, f
	GOTO 	$+2
	DECFSZ 	TEMP_1, f
	GOTO	DELAY0_17MS

	GOTO	$+1
	NOP
	RETURN
	
;
DELAY_50US
	MOVLW	.15
	MOVWF	TEMP
DELAY0_50US
	DECFSZ	TEMP, f
	GOTO	DELAY0_50US
			
	GOTO	$+1

			
	RETURN
;	
DELAY_150US
	MOVLW	.48
	MOVWF	TEMP
DELAY0_150US
	DECFSZ	TEMP, f
	GOTO	DELAY0_150US
			
	GOTO	$+1
	
	RETURN
;
DELAY_6MS
	MOVLW	.174
	MOVWF 	TEMP
	MOVLW 	.5
	MOVWF 	TEMP_1
DELAY0_6MS
	DECFSZ	TEMP, f
	GOTO 	$+2
	DECFSZ 	TEMP_1, f
	GOTO	DELAY0_6MS

	GOTO	$+1
	NOP
	RETURN
;	
DELAY_2MS
	MOVLW	.142
	MOVWF 	TEMP
	MOVLW 	.2
	MOVWF 	TEMP_1
DELAY0_2MS
	DECFSZ	TEMP, f
	GOTO 	$+2
	DECFSZ 	TEMP_1, f
	GOTO	DELAY0_6MS

	GOTO	$+1
	NOP
	RETURN
	
; pulsando o clock
PULSANDO_CLOCK 
	BSF SRCLK 
	BCF SRCLK
	RETURN
	
; envia valores para inicializar a LCD
ENVIA_VALORES

	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB6
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB5
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB4
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	;enviando os valores fake (para poder enviar os 8bits)
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	RETURN
	
; envia todos valores  da linha 1 e 2 de acordo com o PDF fluxograma_Init_LCD.pdf	
ENVIA_VALORES_1_2

	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB6
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB5
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB4
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	;enviando os valores fake (para poder enviar os 8bits)
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	RETURN
	
; envia todos valores  da linha 3 de acordo com o PDF fluxograma_Init_LCD.pdf	
ENVIA_VALORES_3_NF

	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB6
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB5
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB4
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	;enviando os valores fake (para poder enviar os 8bits)
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	RETURN
	
; envia todos o bit 0
ENVIA_VALORES_SO_0

	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB6
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB5
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB4
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	;enviando os valores fake (para poder enviar os 8bits)
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	RETURN
	
;LIGA DISPLAY	
ENVIA_VALORES_5_LIGA_DISPLAY

	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB6
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB5
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB4
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	;enviando os valores fake (para poder enviar os 8bits)
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	RETURN
	
;LIMPA DISPLAY	
ENVIA_VALORES_7_LIMPA_DISPLAY

	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB6
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB5
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB4
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	;enviando os valores fake (para poder enviar os 8bits)
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	RETURN


ENVIA_VALORES_9

	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB6
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ; enviando o valor do DB5
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP4 ; enviando o valor do DB4
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	;enviando os valores fake (para poder enviar os 8bits)
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 
	CALL PULSANDO_CLOCK;
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	RETURN

; envia caracter a caracter
ENVIA_CARACTER
	MOVWF ROTACIONAR
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	;pulso de enable
	BSF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	BSF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
	
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	RLF ROTACIONAR ; rotacionando o valor do Work
	BTFSC STATUS, C ; verificando o valor do C do registrado status é igual 1, se for 0 pula 3 linhas
	GOTO $+4; pula 4 linhas
	BCF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	GOTO $+3; pula 3 linhas
	BSF GPIO, GP4 ; enviando o valor do DB7
	CALL PULSANDO_CLOCK;
	
	;pulso de enable
	BSF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	BSF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	BCF GPIO, GP4 ;  enviando o valor do RS
	CALL PULSANDO_CLOCK;
	
	BSF GPIO, GP5; setando o valor LCD_ENABLE
	BCF GPIO,GP5 ; limpando
		
	RETURN
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	; Esperando 17 ms para poder inicializar o LCD corretamente
	
	;CORPO DA ROTINA PRINCIPAL
	CALL DELAY_17MS  ; Aguarde pelo menos 15ms para garantir o término da operação. Para garantir coloquei 17ms
	;INICIALIZA O LCD -> Envie o comando 0x30 para o display
	CALL ENVIA_VALORES ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=1 DB4=1
	
	CALL DELAY_6MS ; Aguarde pelo menos 4.1ms para garantir o término da operação. Para garantir coloquei 6ms
	CALL ENVIA_VALORES ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=1 DB4=1
	
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	CALL ENVIA_VALORES; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=1 DB4=1
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	
	CALL ENVIA_VALORES_1_2 ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=1 DB4=0; - Linha 1 
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	
	CALL ENVIA_VALORES_1_2 ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=1 DB4=0; - Linha 2 
	
	CALL ENVIA_VALORES_3_NF  ; enviando os valores RS=0 R/W=0 DB7=1 DB6=0 DB5=0 DB4=0; - Linha 3 
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	
	CALL ENVIA_VALORES_SO_0  ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=0 DB4=0; - Linha 4
	
	CALL ENVIA_VALORES_5_LIGA_DISPLAY  ; enviando os valores RS=0 R/W=0 DB7=1 DB6=0 DB5=0 DB4=0; - Linha 5 
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us

	CALL ENVIA_VALORES_SO_0 ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=0 DB4=0; - Linha 6
	CALL DELAY_50US ;Aguarde pelo menos 40µs. Para garantir coloquei 50us

	CALL ENVIA_VALORES_7_LIMPA_DISPLAY ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=0 DB4=1; - Linha 7
	CALL DELAY_2MS  ;Aguarde pelo menos 2ms. 
	
	CALL ENVIA_VALORES_SO_0 ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=0 DB4=0; - Linha 8
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	
	CALL ENVIA_VALORES_9 ; enviando os valores RS=0 R/W=0 DB7=0 DB6=0 DB5=0 DB4=1; - Linha 9
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	
	CALL DELAY_6MS ; Aguarde pelo menos 4.1ms para garantir o término da operação. Para garantir coloquei 6ms
	
	MOVLW 'A'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'B'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'R'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'A'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'A'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'O'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW ' '
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'B'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'I'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'R'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us
	MOVLW 'L'
	CALL  ENVIA_CARACTER
	CALL DELAY_150US ;Aguarde pelo menos 100µs. Para garantir coloquei 150us



	NOP
	GOTO $-1

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END