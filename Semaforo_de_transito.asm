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

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

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

;tempo de espera para transição que é de 300 ms
DELAY
	MOVLW	.94 ; passando 94 para work | w = 94
	MOVWF	TEMP ; passando work para temp | temp = work(94)
	MOVLW	.235 ; passando 235 para work | w = 235
	MOVWF	TEMP_2 ; passando work para temp | temp = work(235)
DELAY_2
	DECFSZ	TEMP, f ; verifica se o TEMP é 0 caso não for ele pula duas linhas, ou seja volta para DELAY_2
	GOTO	$+2 ; pulando duas linhas
	DECFSZ	TEMP_2, f ; quando TEMP é 0 vai cair e vai decrementar de TEMP_2 até que ele seja 0 e quando for ele vai retornar
	GOTO	DELAY_2

	GOTO	$+1 ; pula uma linha
	NOP ; gata um tempo de maquina

		
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
	MOVLW	.255		; work vai receber 40 | w = 300ms
	MOVWF 	TEMP     	; TEMP rece o work
	MOVLW	.235		; work vai receber 40 | w = 300ms
	MOVWF 	TEMP_2	; TEMP rece o work
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	 
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	; GP5 foi escolhido para saída e GP4 até o GP0 foi escolhido ...
	; exibir o valores no display de 7 segmentos
	; Eu considerei o GP0 com mais o significativo
	BSF GPIO,GP5 ; setando o valor do GP5 para 1 | GP5 = 1 
	
	;loop do semaforo
	MAIN_SEMAFORO
	
	; Fazendo demonstrar 9,7,6...0 no display de 7 segmentos 
	; Informação para ligar o display de 7 segementos foi pego nesse site:
	; https://www.embarcados.com.br/wp-content/uploads/2017/07/cd4511-589x418.jpeg

	
	; Começando no 9 e esperar (300ms)| setando valor de 9
    BSF GPIO,GP0	; setando o valor para GP0 para 1 | GP0 = 1
    BCF GPIO,GP1    ; setando o valor para GP1 para 0 | GP1 = 0
    BCF GPIO,GP2	; setando o valor para GP2 para 0 | GP2 = 0
    BSF GPIO,GP4	; setando o valor para GP4 para 1 | GP4 = 1
    CALL DELAY ; chamando a função que vai fazer esperar 300ms | (1) ;
    
    ; Transição de 9 para 8(+300ms)| setando valor de 8
    BSF GPIO,GP0	; setando o valor para GP0 para 1 | GP0 = 1
    BCF GPIO,GP1	; setando o valor para GP1 para 0 | GP1 = 1
    BCF GPIO,GP2	; setando o valor para GP2 para 0 | GP1 = 0
    BCF GPIO,GP4	; setando o valor para GP4 para 0 | GP1 = 0
    CALL DELAY   ; chamando a função que vai fazer esperar 300ms | (2) ;
    
    ; Transição de 8 para 7(+300ms)| setando valor de 7
    BCF GPIO,GP0	; setando o valor para GP0 para 0 | GP1 = 0	
    BSF GPIO,GP1	; setando o valor para GP2 para 0 | GP2 = 1
    BSF GPIO,GP2	; setando o valor para GP1 para 0 | GP3 = 1
    BSF GPIO,GP4	; setando o valor para GP4 para 0 | GP4 = 1
    CALL DELAY ; chamando a função que vai fazer esperar 300ms | (3) ;
    
    ; Transição de 7 para 6(+300ms)|setando valor de 6
    BCF GPIO,GP0	
    BSF GPIO,GP1
    BSF GPIO,GP2
    BCF GPIO,GP4
    CALL DELAY  ; chamando a função que vai fazer esperar 300ms | (4) ;
    
    ; Transição de 6 para 5(+300ms)| setando valor de 5
    BCF GPIO,GP0	
    BSF GPIO,GP1
    BCF GPIO,GP2
    BSF GPIO,GP4
    CALL DELAY  ; chamando a função que vai fazer esperar 300ms | (5) ;
     
    ; Transição de 5 para 4(+300ms)| setando valor de 4
    BCF GPIO,GP0	
    BSF GPIO,GP1
    BCF GPIO,GP2
    BCF GPIO,GP4
    CALL DELAY   ; chamando a função que vai fazer esperar 300ms | (6) ;
    
    ; Transição de 4 para 3(+300ms)| setando valor de 3
    BCF GPIO,GP0	
    BCF GPIO,GP1
    BSF GPIO,GP2
    BSF GPIO,GP4
    CALL DELAY   ; chamando a função que vai fazer esperar 300ms | (7) ;
   
    ; Transição de 3 para 2(+300ms)| setando valor de 2
    BCF GPIO,GP0	
    BCF GPIO,GP1
    BSF GPIO,GP2
    BCF GPIO,GP4
    CALL DELAY   ; chamando a função que vai fazer esperar 300ms | (8) ;
    
    ; Transição de 2 para 1(+300ms)| setando valor de 1 
    BCF GPIO,GP0	
    BCF GPIO,GP1
    BCF GPIO,GP2
    BSF GPIO,GP4
    CALL DELAY   ; chamando a função que vai fazer esperar 300ms | (9) ;
    
     ; Transição de 1 para 0(+300ms)| setando valor de 0 
    BCF GPIO,GP0	
    BCF GPIO,GP1
    BCF GPIO,GP2
    BCF GPIO,GP4
    CALL DELAY   ; chamando a função que vai fazer esperar 300ms | (10) ;
    
   ; valor final do delay 10*300 = 3000 ms ; são 10 números e 10 trasições
   ; fechando um sinal(HIGH) e abrindo outro(LOW)  mas isso precisamos verificar
   ; no meu computador o tempo que foi chegado foi de 3.000058 s
   
   MOVLW B'00100000' ; movendo esse mascara para o work | W= mascara
   XORWF GPIO ; sempre vai inverter o valor de GP5, caso GP5 for 1 torna-se 0 e vice versa...
    
 GOTO MAIN_SEMAFORO	
   
	;CORPO DA ROTINA PRINCIPAL
	
	GOTO MAIN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
