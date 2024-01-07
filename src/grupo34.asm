;*******************************************************************************************************************
;										 PROJETO IAC 2022/2023
;							BEYOND MARS: PASSAGEM PELA CINTURA DE ASTEROIDES
;
;	Grupo 34
;	Tiago Castro Santos, nº 106794
;	Tomás Maria Carmona da Silva Manso Pires, nº 106895				
;	David Rosa Almeida Venâncio Ferreira, nº 107219				
;
;*******************************************************************************************************************

; ******************************************************************************************************************
; * Constantes
; ******************************************************************************************************************
TEC_LIN					EQU 0C000H		; endereço das linhas do teclado (periférico POUT-2)
TEC_COL					EQU 0E000H		; endereço das colunas do teclado (periférico PIN)
LINHA_INICIAL			EQU 8			; 1ª linha a testar (4ª linha, 1000b)
MASCARA					EQU 0FH			; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
MASCARA_PROB			EQU 03H			; para isolar os 2 bits de menor peso por forma a escolher o tipo de asteroide
DISPLAYS   				EQU 0A000H		; endereço dos displays de 7 segmentos (periférico POUT-1)
TECLA_AUMENTA_CONT		EQU 1			; tecla para aumentar o display
TECLA_DIMINUI_CONT		EQU 2			; tecla para diminuir o display
TECLA_MOVE_ASTEROIDE	EQU 3			; tecla para mover o asteroide na diagonal
TECLA_MOVE_SONDA		EQU 4			; tecla para mover a sonda na vertical
TECLA_PAUSA				EQU	000DH		; tecla para suspender/continuar o jogo
TECLA_COMECAR			EQU 000CH		; tecla para começar o jogo
TECLA_TERMINAR			EQU 000EH		; tecla para terminar o jogo
VIDEO_PRINCIPAL			EQU	0			; video de fundo principal
SOM_SONDA				EQU 1			; som de disparo da sonda
SOM_ASTEROIDE			EQU 2			; som reproduzido quando um asteroide é destruído 
SOM_PAUSA				EQU 3			; número do som de pausa no módulo Media Center
SOM_TERMINAR_JOGO		EQU 4			; número do som de terminar o jogo no módulo Media Center
SOM_ENERGIA				EQU 5			; número do som quando a nave fica sem energia
SOM_INICIO				EQU 6			; número do som quando o jogo começa
SOM_COLISAO				EQU 7			; número do som quando um asteroide colide com a nave
SOM_MINERACAO			EQU 8			; número do som quando o jogador "minera" um asteroide
SOM_EXPLOSAO_AST		EQU 9			; número do som quando o jogador destrói um asteroide não minerável
CENARIO_FIM				EQU 2			; número da imagem quando o jogador pressiona a tecla para terminar 
CENARIO_INICIO			EQU 0			; número da imagem que inicia o jogo
CENARIO_SEM_ENERGIA		EQU 3			; número da imagem quando a nave fica sem energia
CENARIO_COLISAO			EQU 4

A_CORRER				EQU 0			; estado do jogo quando está jogável
PAUSADO					EQU 1			; estado do jogo quando está pausado 
PARADO					EQU 2			; estado do jogo quando está parado

COMANDOS				EQU	6000H				; endereço de base dos comandos do MediaCenter

DEFINE_ECRA				EQU COMANDOS + 04H		; endereço do comando para definir o ecrã a utlizar
DEFINE_LINHA			EQU COMANDOS + 0AH		; endereço do comando para definir a linha
DEFINE_COLUNA			EQU COMANDOS + 0CH		; endereço do comando para definir a coluna
DEFINE_PIXEL			EQU COMANDOS + 12H		; endereço do comando para escrever um pixel
APAGA_AVISO				EQU COMANDOS + 40H		; endereço do comando para apagar o aviso de nenhum cenário selecionado
APAGA_ECRÃ				EQU COMANDOS + 02H		; endereço do comando para apagar todos os pixels já desenhados
SELECIONA_CENARIO_FUNDO	EQU COMANDOS + 42H		; endereço do comando para selecionar uma imagem de fundo
TOCA_SOM				EQU COMANDOS + 5AH		; endereço do comando para tocar um som
CENARIO_FRONTAL 		EQU COMANDOS + 46H		; endereço do comando para selecionar uma imagem frontal
PAUSA_SONS				EQU COMANDOS + 62H		; endereço do comando para pausar a reprodução de todos os sons e vídeos
RESUME_SONS				EQU	COMANDOS + 64H		; endereço do comando para continuar a reprodução de todos os sons e vídeos
APAGA_CENARIO_FRONTAL	EQU COMANDOS + 44H		; endereço do comando para apagar o cenário frontal
REPRODUZ_VIDEO_CICLO	EQU COMANDOS + 5CH		; endereço do comando para reproduzir um som/video em loop
TERMINA_VIDEO			EQU COMANDOS + 68H		; endereço do comando para terminar a reprodução de um som/video

LARGURA_NAVE			EQU 15					; largura da nave
ALTURA_NAVE				EQU 5					; altura da nave
LINHA_NAVE				EQU 27					; linha refrência da nave
COLUNA_NAVE				EQU 25					; coluna referência da nave
ENERGIA_INICIAL_NAVE	EQU 64H					; energia inicial da nave
LINHA_INICIAL_AST		EQU	0					; linha inicial do asteroide
LINHA_INICIAL_SONDA		EQU 26					; linha inicial da sonda
MAX_LINHA				EQU 31					; limite inferior do ecrã

LINHA_PAINEL			EQU 28					; linha referência do painel de luzes
COLUNA_PAINEL			EQU 29					; coluna referência do painel de luzes
LARGURA_PAINEL			EQU 7					; largura do painel de luzes
ALTURA_PAINEL			EQU	2					; altura do painel de luzes
AZUL					EQU 0F07DH				; combinação para azul(opaco e vermelho a 0, verde a 7 e azul a D)
PRETO					EQU 0F222H				; combinação para preto(opaco, vermelho,verde e azul a 2)
CINZENTO				EQU 0F668H				; combinação para cinzento(opaco, vermelho e verde a 6 e azul a 8)
AZUL_C					EQU 0F0FFH				; combinação para azul claro(opaco e vermelho a 0, verde e azul a F)
LARANJA					EQU 0FF90H				; combinação para laranja(opaco e vermelho a F, verde a 9 e azul a 0)
VERDE					EQU 0F0E0H				; combinação para verde(opaco e vermelho a 0, verde a E e azul a 0)
ROXO					EQU 0F60CH				; combinação para roxo(opaco e vermelho a 6, verde a 0 e azul a C)
	
LARGURA_ASTEROIDE		EQU 5 					; largura de qualquer asteroide
ALTURA_ASTEROIDE		EQU 5 	   				; altura de qualquer asteroide
COR_ASTEROIDE_NMINER	EQU	0FF00H				; cor do asteroide não minerável (opaco e vermelho no máximo, verde e azul a 0)
COR_ASTEROIDE_MINER1	EQU 0F069H				; cor de um dos pixeis do asteroide mineravel
COR_ASTEROIDE_MINER2	EQU 0F078H				; cor de um dos pixeis do asteroide mineravel
COR_ASTEROIDE_MINER3	EQU 0FA32H				; cor de um dos pixeis do asteroide mineravel
COR_ASTEROIDE_MINER4	EQU 0FB33H				; cor de um dos pixeis do asteroide mineravel
COR_ASTEROIDE_MINER5	EQU 0F782H				; cor de um dos pixeis do asteroide mineravel
COR_ASTEROIDE_MINER6	EQU 0F088H				; cor de um dos pixeis do asteroide mineravel
COR_ASTEROIDE_MINER7	EQU 0F971H				; cor de um dos pixeis do asteroide mineravel
COR_EXPLOSAO_AST_NMIN	EQU 0F04FH				; cor da explosão de um asteroide não minerável
ENERGIA_MINER			EQU 25					; energia obtida ao minerar um asteroide

ALTURA_SONDA 			EQU 1					; altura da sonda
LARGURA_SONDA 			EQU 1					; largura da sonda
COR_SONDA				EQU 0FEEEH				; cor da sonda (opaco com vermelho, verde e azul a E)
ENERGIA_DISP			EQU 5					; custo em energia de um disparo de uma sonda
MOVIMENTO_MAX_SONDA		EQU 12					; número máximo de movimentos de uma sonda

TAMANHO_PILHA			EQU 100H				; tamanho de cada pilha

; *******************************************************************************************************************
; * Dados 
; *******************************************************************************************************************
	PLACE		2000H

; reserva o espaço para as pilhas de cada processo

	STACK TAMANHO_PILHA					; espaço reservado para a pilha 
SP_inicial_pricipal:					; SP do programa principal inicializado com o endereço 2200H

	STACK TAMANHO_PILHA					; espaço reservado para a pilha do processo "teclado"
SP_inicial_teclado:						; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA					; epaço reservado para a pilha do processo "controlo"
SP_inicial_controlo:					; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA					; espaço reservado para a pilha do processo "enrgia"
SP_inicial_energia:						; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA					; espaço reservado para a pilha do processo "nave"
SP_inicial_nave:						; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA					; espaço reservado para a pilha do processo "asteroide"
SP_inicial_ateroide:					; este é o endereço com que o SP deste processo deve ser inicializado

	STACK TAMANHO_PILHA					; espaço reservado para a pilha do processo "sonda"
SP_inicial_sonda:						; este é o endereço com que o SP deste processo deve ser inicializado

linha_asteroide:	WORD	0			; guarda a linha da posição atual do asteroide
coluna_asteroide:	WORD	0			; guarda a coluna da posição atual do asteroide

linha_sonda: 		WORD 26
coluna_sonda:		WORD 32
energia_nave:		WORD 64H
painel_nave:		WORD 1

DEF_NAVE:										; tabela que define a nave (largura, altura e cor dos pixels)
		WORD	LARGURA_NAVE
		WORD	ALTURA_NAVE
		WORD	0, 0, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, PRETO, 0, 0
		WORD	0, PRETO, AZUL, CINZENTO, 0, 0, 0, 0, 0, 0, 0, CINZENTO, AZUL, PRETO, 0
		WORD	PRETO, AZUL, AZUL, CINZENTO, 0, 0, 0, 0, 0, 0, 0, CINZENTO, AZUL, AZUL, PRETO
		WORD	PRETO, AZUL, AZUL, AZUL, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, CINZENTO, AZUL, AZUL, AZUL, PRETO
		WORD	PRETO, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, AZUL, PRETO


DEF_AST_NAOMINERAVEL:							; tabela que define um asteróide não minerável (largura, altura e cor dos pixels)
		WORD 	LARGURA_ASTEROIDE
		WORD 	ALTURA_ASTEROIDE
		WORD	COR_ASTEROIDE_NMINER, 0, COR_ASTEROIDE_NMINER, 0, COR_ASTEROIDE_NMINER
		WORD 	0, COR_ASTEROIDE_NMINER, COR_ASTEROIDE_NMINER, COR_ASTEROIDE_NMINER, 0
		WORD 	COR_ASTEROIDE_NMINER, COR_ASTEROIDE_NMINER, 0, COR_ASTEROIDE_NMINER, COR_ASTEROIDE_NMINER
		WORD 	0, COR_ASTEROIDE_NMINER, COR_ASTEROIDE_NMINER, COR_ASTEROIDE_NMINER, 0 
		WORD 	COR_ASTEROIDE_NMINER, 0, COR_ASTEROIDE_NMINER, 0, COR_ASTEROIDE_NMINER

DEF_AST_MINERAVEL:							; tabela que define um asteróide minerável (largura, altura e cor dos pixels)
		WORD 	LARGURA_ASTEROIDE
		WORD 	ALTURA_ASTEROIDE
		WORD	0, COR_ASTEROIDE_MINER1, COR_ASTEROIDE_MINER2, COR_ASTEROIDE_MINER3 , 0
		WORD	COR_ASTEROIDE_MINER3, COR_ASTEROIDE_MINER4, COR_ASTEROIDE_MINER5, COR_ASTEROIDE_MINER6, COR_ASTEROIDE_MINER5
		WORD	COR_ASTEROIDE_MINER6, COR_ASTEROIDE_MINER3, COR_ASTEROIDE_MINER7, COR_ASTEROIDE_MINER4, COR_ASTEROIDE_MINER7
		WORD	COR_ASTEROIDE_MINER2, COR_ASTEROIDE_MINER6, COR_ASTEROIDE_MINER2, COR_ASTEROIDE_MINER1, COR_ASTEROIDE_MINER3
		WORD	0, COR_ASTEROIDE_MINER3, COR_ASTEROIDE_MINER2, COR_ASTEROIDE_MINER7, 0

DEF_COLISAO_AST_NMIN:						; tabela que define a explosão de um asteroide não minerável (largura, altura e cor dos pixels)
		WORD	LARGURA_ASTEROIDE
		WORD	ALTURA_ASTEROIDE
		WORD	0, COR_EXPLOSAO_AST_NMIN, 0, COR_EXPLOSAO_AST_NMIN, 0
		WORD	COR_EXPLOSAO_AST_NMIN, 0, COR_EXPLOSAO_AST_NMIN, 0, COR_EXPLOSAO_AST_NMIN
		WORD	0, COR_EXPLOSAO_AST_NMIN, 0, COR_EXPLOSAO_AST_NMIN, 0
		WORD	COR_EXPLOSAO_AST_NMIN, 0, COR_EXPLOSAO_AST_NMIN, 0, COR_EXPLOSAO_AST_NMIN
		WORD	0, COR_EXPLOSAO_AST_NMIN, 0, COR_EXPLOSAO_AST_NMIN, 0 

DEF_COLISAO_AST_MIN1:						; tabela que define a explosão de um asteroide minerável (largura, altura e cor dos pixels)
		WORD	LARGURA_ASTEROIDE
		WORD	ALTURA_ASTEROIDE
		WORD	0, 0, 0 ,0 ,0
		WORD	0, 0, COR_ASTEROIDE_MINER5, 0, 0
		WORD	0, COR_ASTEROIDE_MINER3, COR_ASTEROIDE_MINER7, COR_ASTEROIDE_MINER4, 0
		WORD	0, 0, COR_ASTEROIDE_MINER2, 0, 0
		WORD	0, 0, 0, 0, 0

DEF_COLISAO_AST_MIN2:
		WORD	LARGURA_ASTEROIDE
		WORD	ALTURA_ASTEROIDE
		WORD	0, 0, 0, 0, 0
		WORD	0, 0, 0, 0, 0
		WORD	0, 0, COR_ASTEROIDE_MINER7, 0, 0
		WORD	0, 0, 0, 0, 0	
		WORD	0, 0, 0, 0, 0

DEF_SONDA:									; tabela que define uma sonda (largura, altura e cor dos pixels)
		WORD LARGURA_SONDA
		WORD ALTURA_SONDA
		WORD COR_SONDA

DEF_LUZES_PAINEL:
		WORD	DEF_LUZES_PAINEL1, DEF_LUZES_PAINEL2, DEF_LUZES_PAINEL3, DEF_LUZES_PAINEL4, DEF_LUZES_PAINEL5, DEF_LUZES_PAINEL6
		WORD	DEF_LUZES_PAINEL7 

; tabelas que definem os difrentes painés de luzes da nave
DEF_LUZES_PAINEL1:
		WORD	LARGURA_PAINEL
		WORD	ALTURA_PAINEL
		WORD	AZUL_C, LARANJA, VERDE, ROXO, AZUL_C, LARANJA, VERDE
		WORD	VERDE, AZUL_C, LARANJA, VERDE, ROXO, AZUL_C, LARANJA

DEF_LUZES_PAINEL2:		
		WORD	LARGURA_PAINEL
		WORD	ALTURA_PAINEL
		WORD	VERDE, AZUL_C, LARANJA, VERDE, ROXO, AZUL_C, LARANJA
		WORD	LARANJA, VERDE, AZUL_C, LARANJA, VERDE, ROXO, AZUL_C

DEF_LUZES_PAINEL3:
		WORD	LARGURA_PAINEL
		WORD	ALTURA_PAINEL
		WORD	LARANJA, VERDE, AZUL_C, LARANJA, VERDE, ROXO, AZUL_C
		WORD	AZUL_C, LARANJA, VERDE, AZUL_C, LARANJA, VERDE, ROXO
		
DEF_LUZES_PAINEL4:
		WORD	LARGURA_PAINEL
		WORD	ALTURA_PAINEL
		WORD	AZUL_C, LARANJA, VERDE, AZUL_C, LARANJA, VERDE, ROXO
		WORD	ROXO, AZUL_C, LARANJA, VERDE, AZUL_C, LARANJA, VERDE

DEF_LUZES_PAINEL5:		
		WORD	LARGURA_PAINEL
		WORD	ALTURA_PAINEL
		WORD	ROXO, AZUL_C, LARANJA, VERDE, AZUL_C, LARANJA, VERDE
		WORD	VERDE, ROXO, AZUL_C, LARANJA, VERDE, AZUL_C, LARANJA
		
DEF_LUZES_PAINEL6:		
		WORD	LARGURA_PAINEL
		WORD	ALTURA_PAINEL
		WORD	VERDE, ROXO, AZUL_C, LARANJA, VERDE, AZUL_C, LARANJA
		WORD	LARANJA, VERDE, ROXO, AZUL_C, LARANJA, VERDE, AZUL_C
		
DEF_LUZES_PAINEL7:
		WORD	LARGURA_PAINEL
		WORD	ALTURA_PAINEL
		WORD	LARANJA, VERDE, ROXO, AZUL_C, LARANJA, VERDE, AZUL_C
		WORD	AZUL_C, LARANJA, VERDE, ROXO, AZUL_C, LARANJA, VERDE

coluna_direcao:									; tabela que contém os pares coluna/direção possiveis para um asteroide
		WORD 0, 30, 30, 30, 59
		WORD 1, -1, 0, 1, -1

movimento_sonda:								; tabela que contém os pares coluna/direção possiveis para uma sonda
		WORD 26, 32, 37
		WORD -1, 0, 1

tab:						; tabela das rotinas de interrupção
	WORD rot_int_0			; rotina de atendimento da interrupção 0
	WORD rot_int_1			; rotina de atendimento da interrupção 1
	WORD rot_int_2			; rotina de atendimento da interrupção 2
	WORD rot_int_3			; rotina de antendimento da interrupção 3

testa_colisao:				; variável para comunicar ao processo "sonda" se a sonda colidiu com um asteroide ou não
		WORD 0				

estado_jogo:				; variável que guarda o estado do jogo 
		WORD PARADO			; (0 quando o jogo está a correr e 1 quando está pausado e 2 quando está parado)	

energia_asteroide:			; variavel que guarda se houve um aumento de energia devido à mineração de um asteroide
		WORD 0

evento_energia:				; LOCK para a rotina de interrupção comunicar ao processo energia que a interrupção ocorreu
		LOCK 0

evento_nave:				; LOCK para a rotina de interrupção comunicar ao processo nave que a interrupção ocorreu
		LOCK 0

evento_asteroide:			; LOCK para a rotina de interrupção comunicar ao processo asteroide que a interrupção ocorreu
		LOCK 0

evento_sonda:				; LOCK para a rotina de interrupção comunicar ao processo sonda que a interrupção ocorreu
		LOCK 0

tecla_carregada:			; LOCK para o teclado comunicar aos restantes processos que tecla detetou
		LOCK 0									

corre_jogo:					; variável utilizada para pausar os processos quando o player carrega no botão de pausa
		LOCK 0

jogo_parado:				; variável que comunica o inicio do jogo aos diferentes processos					
		LOCK 0

; ******************************************************************************************
; * Código
; ******************************************************************************************
PLACE	 0000H                     			; o código começa em 0000H

inicio:
	MOV	SP, SP_inicial_pricipal		  		; inicializa o SP do programa principal

	MOV BTE, tab							; inicializa BTE

	MOV		[APAGA_AVISO], R1				; apaga o aviso de nenhum cenário selecionado
	MOV		[APAGA_ECRÃ], R1				; apaga todos os pixels já desenhados
	MOV		R1, CENARIO_INICIO				; cenário de fundo número 0
	MOV		[SELECIONA_CENARIO_FUNDO], R1	; seleciona o cenário de fundo
	MOV		R1, SOM_INICIO
	MOV 	[TOCA_SOM], R1					; toca o som de inicio do jogo
	MOV		R6, LINHA_INICIAL				; linha inicial a testar no teclado
	CALL	teclado							; cria o processo teclado
	CALL	controlo						; cria processo controlo
	
	EI0			; permite interrupções 0
	EI1			; permite interrupções 1
	EI2			; permite interrupções 2
	EI3			; permite interrupções 3
	EI			; permite interrupções (geral)

espera_comecar:
	MOV		R11, [jogo_parado]		; espera que o jogador carregue na tecla de inicio
	CALL	nave					; cria o processo nave
	CALL 	asteroide				; cria o processo asteroide
	CALL	sonda					; cria o processo sonda
	CALL	energia					; cria o processo energia
	MOV		R1, LINHA_NAVE			; linha inicial da nave
	MOV 	R2, COLUNA_NAVE			; coluna inicial da nave
	MOV 	R4, DEF_NAVE			; tabela que define a nave
	MOV 	R9, 1					; ecrã do Media Center usado para desenhar a nave
	CALL 	desenha_objeto			; desenha a nave
	
fim:	
	JMP espera_comecar

; **********************************************************************
; Processo
;
; TECLADO - Processo que deteta quando se carrega numa tecla do teclado 
;			e escreve o valor da tecla num LOCK.
;
; **********************************************************************
	
PROCESS	SP_inicial_teclado				; inicialização do SP do processo

teclado:								; atualiza a linha a ser testada
	SHR		R6, 1						; passa R6 para a linha seguinte
	CMP		R6, 0						; verifica se R6 é 0
	JNZ		espera_tecla				; se R6 for diferente de 0, continua o ciclo
	MOV		R6, LINHA_INICIAL			; retorna R6 ao valor inicial

espera_tecla:
	WAIT 
	CALL 	lê_teclado					; leitura às teclas
	CMP		R0, 0
	JZ		teclado						; espera, enquanto não houver uma tecla premida
	CALL 	converte_tecla				; converte a coluna e a linha obtidas na respetiva tecla
	MOV		[tecla_carregada], R0		; informa os processos bloqueados nesta variável que uma tecla foi pressionada
										; (o valor escrito na variável é o valor da tecla carregada depois de convertido)

espera_nao_tecla:						; neste ciclo espera-se até não haver nenhuma tecla premida
	YIELD
	CALL	lê_teclado					; leitura às teclas
	CMP		R0, 0		
	JNZ		espera_nao_tecla			; espera, enquanto houver tecla uma tecla carregada

	JMP		teclado

; ******************************************************************************
; CONVERTE_TECLA - Recebe uma coluna e uma linha e coverte-as na respetiva tecla
; Argumentos:  R6 - linha do teclado
; 			   R0 - coluna do teclado
;
; Retorna: R0 - tecla final
; ******************************************************************************
converte_tecla:
	PUSH	R6
	PUSH	R7
	MOV   	R7, 0				; contador do numero de SHR efetuados
converte_linha:					; converte a linha para um número entre 0 e 3
	SHR		R6, 1
	CMP		R6, 0
	JZ		copia_valores_linha
	ADD		R7, 1
	JMP		converte_linha

copia_valores_linha:
	MOV		R6, R7				; copia o valor da linha convertido para R1
	MOV		R7, 0				; dá reset ao contador

converte_coluna:				; converte a coluna para um número entre 0 e 3		
	SHR		R0, 1
	CMP		R0, 0
	JZ		copia_valores_coluna
	ADD		R7, 1
	JMP		converte_coluna

copia_valores_coluna:
	MOV		R0, R7				; copia o valor convertido da coluna para R0
	MOV		R7, 0				; dá reset ao contador

	SHL		R6, 2				; multiplica o valor da linha por 4
	ADD		R0, R6				; obtem a tecla pressionada (linha * 4 + coluna)
	POP		R7
	POP		R6
	RET

; *************************************************************************************
; LÊ_TECLADO - Faz uma leitura às teclas de uma linha do teclado e retorna o valor lido
; Argumentos:	R6 - linha a testar (em formato 1, 2, 4 ou 8)
;
; Retorna: 		R0 - valor lido das colunas do teclado (0, 1, 2, 4, ou 8)	
; *************************************************************************************
lê_teclado:
	PUSH	R2
	PUSH	R3
	PUSH	R5
	MOV		R2, TEC_LIN		; endereço do periférico das linhas
	MOV		R3, TEC_COL		; endereço do periférico das colunas
	MOV		R5, MASCARA		; para isolar os 4 bits de menor peso, ao ler as colunas do teclado
	MOVB	[R2], R6		; escrever no periférico de saída (linhas)
	MOVB	R0, [R3]		; ler do periférico de entrada (colunas)
	AND		R0, R5			; elimina bits para além dos bits 0-3
	POP		R5
	POP		R3
	POP		R2
	RET

; **************************************************************************************
; Processo
;
; Controlo - Processo que controla o estado do jogo. 
;
; **************************************************************************************

PROCESS	SP_inicial_controlo				; inicialização do SP do processo

controlo:
	MOV R0,	TECLA_PAUSA				; tecla de pausa
	MOV R1, TECLA_COMECAR			; tecla para dar inicio ao jogo
	MOV R2, TECLA_TERMINAR			; tecla para terminar o jogo
	MOV R5, PAUSADO					; registo usado para colocar o estado do jogo em "pausa"
	MOV R6, A_CORRER				; registo usado para colocar o estado do jogo em "a correr"
	MOV R7, PARADO					; registo usado para colocar o estado do jogo em "terminado"
	MOV R9, ENERGIA_INICIAL_NAVE	; energia da nave no inicio do jogo
	MOV R10, 100H

pausa_jogo:			 
	MOV	R4, [tecla_carregada]		; obtém a última tecla carregada
	MOV R3, [estado_jogo]			; lê o estado do jogo
	CMP	R4, R0						; verifica se foi a tecla de pausa que foi pressionada
	JNZ comecar						; verifica se a tecla de pausa foi pressionada
	CMP R3, 0						; verifica se o jogo estava "a correr" quando a tecla de pausa foi pressionada
	JNZ continua_jogo				; caso não esteja significa que o player quer retomar o jogo
	MOV [estado_jogo], R5 			; altera o estado do jogo para "pausado"
	MOV [PAUSA_SONS], R5			; pausa todos os sons e vídeos que estão a ser reproduzidos
	MOV	[CENARIO_FRONTAL], R5		; seleciona o cenário de fundo quando o jogo está em pausa
	MOV	R8, SOM_PAUSA
	MOV [TOCA_SOM], R8				; toca o som de pausa
	JMP controlo

continua_jogo:
	MOV [estado_jogo], R6				; altera o estado do jogo para "a correr"
	MOV	[corre_jogo], R6				; liberta os processos presos no LOCK
	MOV [APAGA_CENARIO_FRONTAL], R5		; apaga o cenário de pausa
	MOV [RESUME_SONS], R5				; continua a reprodução de todos os sons e videos pausados						
	JMP controlo

comecar:
	CMP R4, R1							; verifica se foi a tecla de começar o jogo que foi pressionada
	JNZ terminar
	MOV [jogo_parado], R5				; desbloquia o ciclo principal do jogo
	MOV	[APAGA_CENARIO_FRONTAL], R7		; retira o cenário frontal inicial ou final
	MOV [energia_nave], R9				; inicializa a energia da nave
	MOV [DISPLAYS], R10					; inicializa a energia da nave a "100%" no display
	MOV	R8, VIDEO_PRINCIPAL				
	MOV [REPRODUZ_VIDEO_CICLO], R8		; reproduz o video/trilha sonora principal do jogo
	MOV [estado_jogo], R6				; altera o estado do jogo para "a correr"
	JMP controlo

terminar:
	CMP R4, R2						; verifica se foi a tecla para terminar o jogo que foi pressionada
	JNZ pausa_jogo					; reinicia o processo caso nenhuma tecla de controlo tenha sido pressionada
	MOV	[estado_jogo], R7			; altera o estado de jogo para "parado"
	MOV [corre_jogo], R7			; desbloqueia pausas para ter em conta situações em que o player pausa e de seguida termina o jogo 
	MOV [tecla_carregada], R7		; desbloqueia o processo sonda (serve para casos em que nenhuma sonda foi disparada e o processo está à
									; espera de uma tecla carregada para poder verficar o estado do jogo)
	MOV	R8, CENARIO_FIM				; obtém o cenário de fim
	MOV	[CENARIO_FRONTAL], R8		; coloca o cenário de término do jogo
	MOV	[TERMINA_VIDEO], R8			; para a reprodução do video/soundtrack principais do jogo
	MOV	R8, SOM_TERMINAR_JOGO		; obtém o efeito sonoro de término do jogo
	MOV	[TOCA_SOM], R8				; reproduz o efeito sonoro de terminar o jogo
	MOV [APAGA_ECRÃ], R8			; apaga todos os pixeis desenhados no ecrã
	JMP controlo

; ****************************************************************************
; Processo
;	
;	ENERGIA - Processo que controla o gasto periódico de energia da nave
;
;
; ****************************************************************************

PROCESS	SP_inicial_energia		; inicialização do SP do processo

energia:
	MOV R1, ENERGIA_INICIAL_NAVE
espera_interrupcao:
	MOV R0, [evento_energia]	; lê o LOCK que bloqueia o processo até a interrupção o desbloquear
	MOV R3, [energia_asteroide]	; verifica se a enrgia foi atualizada devido à mineração de um asteroide
	CMP R3, 1					; se sim mantém a energia atual (enrgia previamente aumentada)
	JZ	verifica_pausa
	MOV R2, [energia_nave]		; verifica a energia atual da nave
	CMP R2, R1					; se esta for menor que a "suposta" nova energia vinda do ciclo
								; significa que uma sonda foi disparada e, por isso mantém-se o menor valor 
	JLT	verifica_pausa
	MOV [energia_nave], R1		; caso contrário atualiza a energia da nave

verifica_pausa:
	MOV R3, 0
	MOV [energia_asteroide], R3	; reseta a variável que comunica se houve aumento de energia devido a mineração
	MOV R2, [estado_jogo]		; obtém o estado atual do jogo
	CMP R2, 1					; verifica se o jogo está em "pausa"
	JZ 	bloqueia_processo		; se o jogo estiver em pausa fica preso num LOCK até o jogo ser retomado
	CMP R2, 2					; verifica se o jogo está "parado"
	JZ termina_processo			; caso o jogo esteja parado, o processo retorna

loop:
	MOV R1, [energia_nave]		; obtém a energia atual da nave
	CMP R1, 0					; verifica se a energia não é menor ou igual a 0
	JLE	game_over				; em caso afirmativo muda o estado de jogo para parado e termina os processos
	CALL converte_dec			; converte a energia atual da nave para um número em decimal
	MOV [DISPLAYS], R4			; mostra a energia da nave no display
	SUB R1, 3					; retira 3% a essa energia
	JMP espera_interrupcao

bloqueia_processo:
	MOV R2, [corre_jogo]		; fica "preso" no LOCK até o jogo ser retomado
	MOV R2, [estado_jogo]		; obtém o estado de jogo atual
	CMP R2, 2					; verifica se o jogo não foi terminado
	JZ	termina_processo
	JMP	espera_interrupcao

game_over:
	MOV	R4, 0				
	MOV [DISPLAYS], R4			; coloca a enrgia do display a 0
	MOV R3, PARADO
	MOV [estado_jogo], R3		; muda o estado de jogo para "parado"
	MOV [APAGA_ECRÃ], R3		; apaga todos os pixéis do ecrã
	MOV	[TERMINA_VIDEO], R3		; para a reprodução do video/soundtrack principais do jogo
	MOV R3, CENARIO_SEM_ENERGIA	; obtém o cenário de "game over" para quando a energia acaba
 	MOV [CENARIO_FRONTAL], R3	; coloca o cenário de "game over" para quando a energia acaba
	MOV	R3, SOM_ENERGIA			; obtém o efeito sonoro de quando a energia acaba
	MOV [TOCA_SOM], R3			; toca o som de "game over" por falta de energia
	MOV [tecla_carregada], R3	; desbloqueia o processo sonda (serve para casos em que nenhuma sonda foi disparada e o processo está à
								; espera de uma tecla carregada para poder verficar o estado do jogo)

termina_processo:
	RET							; retorna o porcesso quando o jogo entra em modo "parado"

;*******************************************************************************************
; CONVERTE_DEC - Rotina que converte um número hexadecimal para decimal
;
;	Argumentos : R1 - número a converter
;	Retorna : R4 - núemro convertido
;********************************************************************************************
converte_dec:
	PUSH R0
	PUSH R1
	PUSH R2
	PUSH R3
	MOV R3, 10				
	MOV R2, 1000		; fator de conversão
	
ciclo:
	MOD R1, R2			; valor a converter nesta iteração
	DIV R2, R3			; obtém o fator a usar na iteração seguinte
	CMP R2, 0			; se o fator for 0 sai do ciclo
	JZ fim_conversao
	MOV R0, R1			
	DIV R0, R2			; obtém um digito no valor decimal (0 a 9)
	SHL R4, 4			; desloca o resultado para "arranjar" espaço para o novo digito
	OR	R4, R0			; combina o resultado atual com o novo digito
	JMP ciclo			; repete o ciclo

fim_conversao:
	POP R3
	POP R2
	POP R1
	POP R0
	RET

; **********************************************************************************
; Processo
;	
;	NAVE - Processo que desenha o painel de instrumentos da nave e controla as luzes
;			do painel de instrumentos
;
; ***********************************************************************************
PROCESS SP_inicial_nave			; inicialização do SP do processo
	
nave:
	MOV R1, LINHA_PAINEL		; linha de referência do painel de luzes
	MOV R2, COLUNA_PAINEL		; coluna de referência do painel de luzes
	MOV R5, DEF_LUZES_PAINEL
	MOV R0, 0					; indice da primeira tabela do painel de luzes
	MOV R11, 7					; número de paineis diferentes

ciclo_luzes:
	MOV R4, [R5 + R0]			; obtém a tabela que define o painel de luzes a ser usado nesta iteração
	CALL desenha_objeto			; desenha o painel de luzes
	MOV R10, [evento_nave]		; espera que ocorra a interrupção que temporiza este processo

testa_pausa_jogo:
	MOV	R10, [estado_jogo]		; obtém o estado do jogo
	CMP	R10, 1					; verifica se o jogo está "pausado"
	JZ	pausa_luzes				; se sim salta para uma variável LOCK que "para" o processo
	CMP R10, 2					; verifica se o jogo está "parado"
	JZ  termina_processo_luzes	; se sim termina o processo
	CALL apaga_objeto			; apaga o painel de luzes atual
	SUB R11, 1					; menos um painel para desenhar
	CMP R11, 0					; verifica se ainda não chegou ao último painel
	JZ	nave					; se sim volta ao inicio (volta para o primeiro painel)
	ADD R0, 2					; caso contrário passa à próxima tabela (que define o próximo painel)
	JMP ciclo_luzes				; faz mais uma iteração do ciclo

pausa_luzes:					
	MOV R10, [corre_jogo]		; "prende" o processo até o jogo ser retomado
	MOV R10, [estado_jogo]		; obtém o estado do jogo
	CMP R10, 2					; verifica se o jogo não foi terminado
	JZ 	termina_processo		; se sim termina o processo 
	JMP ciclo_luzes				; volta ao ciclo principla

termina_processo_luzes:			; termina o processo
	RET

;******************************************************************************************
;	Processo
;	
;	ASTEROIDE - Processo responsável por coordenar o movimento do asteroide, o seu tipo e 
;				verificar se o asteroide colide com a nave ou com uma sonda
;
;******************************************************************************************

PROCESS	SP_inicial_ateroide			; inicialização do SP do processo

asteroide:
	CALL obtem_combinacoes
	CMP	R5, 0						; verifica se é um asteroide mineravel
	JZ asteroide_mineravel
	MOV R4, DEF_AST_NAOMINERAVEL	; obtém a tabela que define o formato do asteroide não mineravel
	JMP inicializa_asteroide

asteroide_mineravel:
	MOV R4, DEF_AST_MINERAVEL		; obtém a tabela que define o formato do asteroide mineralvel

inicializa_asteroide:
	MOV R1, LINHA_INICIAL_AST		; obtém a linha inicial do asteroide
	MOV R8, coluna_direcao			; obtém a tabela com os pares coluna/direção possiveis
	SHL R3, 1						; multiplica o indice obtido por 2 para aceder à tabela das combinações
	ADD R8, R3						; indice do par coluna/direção pretendido
	MOV R2, [R8]					; obtem a coluna inicial do asteroide
	MOV R7, [R8 + 10] 				; obtem a direção do movimento do asteroide
	MOV R9, 0						; desenha o asteroide num ecrã diferente do da nave

ciclo_asteroide:
	CALL desenha_objeto				; desenha a primeira instância do asteroide
	MOV	R0, [evento_asteroide]		; espera pela interrupção para iniciar o "movimento" do asteroide

testa_pausa:
	MOV	R10, [estado_jogo]		; verifica o estado do jogo
	CMP	R10, 1					
	JZ	pausa					; se o jogo estiver em pausa salta para um LOCK que bloqueia até o jogo ser retomado
	CMP R10, 2
	JZ  termina					; se o jogo estiver parado termina o processo
	CALL apaga_objeto			; apaga o boneco na sua posição corrente
	CALL testa_limites			; verifica se o asteroide chegou ao fim do ecrã
	CMP R11, 1
	JZ	asteroide				; se atingiu o limite inferior do ecrã, cria uma nova instância do asteroide			
	CALL testa_colisao_nave		; testa se o asteroide colide com a nave
	CMP R10, 1					
	JZ	game_over_nave			; se o asteroide colidiu, termina o jogo, toca o efeito sonoro de colisão e coloca o cenário de game over
	CALL testa_colisao_sonda	; testa se o asteroide colidiu com alguma sonda
	CMP R10, 1
	JZ	explode_asteroide		; se sim, salta para um ciclo para cria o efeito da explosão
	ADD	R2, R7					; para desenhar o asteroide na coluna seguinte (direita, esquerda ou a mesma coluna)
	MOV [coluna_asteroide], R2	; guarda a coluna atualizada do asteroide
	ADD R1, 1					; para desenhar o asteroide na linha seguinte
	MOV [linha_asteroide], R1	; atualiza a linha do asteroide
	JMP	ciclo_asteroide			; continua a mover o asteroide

explode_asteroide:
	CMP R5, 0						; verifica se o asteroide destruido é do tipo minerável
	JNZ asteroide_nmineravel	
	MOV R8, SOM_MINERACAO			; obtém o som de mineração de um asteroide
	MOV [TOCA_SOM], R8				; toca o som
	CALL aumenta_energia			; aumenta em 25% a energia da nave
	MOV R8, 1					
	MOV [energia_asteroide], R8		; sinaliza que houve um aumento devido à destruição de um asteroide
	MOV R4, DEF_COLISAO_AST_MIN1	; desenha a explosão de um asteroide minerável
	CALL desenha_explosao
	MOV R4, DEF_COLISAO_AST_MIN2
	CALL desenha_explosao
	JMP asteroide					; volta a criar uma nova instância asteroide

asteroide_nmineravel:
	MOV R8, SOM_EXPLOSAO_AST		; obtém o som de explosão de um asteroide não minerável
	MOV [TOCA_SOM], R8				; toca o som
	MOV R4, DEF_COLISAO_AST_NMIN	; tabela que define a explosão do asteroide
	CALL desenha_explosao			; desenha a explosão do asteroide
	JMP asteroide					; volta a criar uma nova instância asteroide

pausa:
	MOV R10, [corre_jogo]		; fica "preso" no LOCK até o jogo ser retomado
	MOV R10, [estado_jogo]		; obtém o estado de jogo atual
	CMP R10, 2					; verifica se o jogo não foi terminado
	JZ 	termina					; em caso afirmativo, termina o processo
	JMP ciclo_asteroide			; volta ao ciclo do movimento do asteroide

game_over_nave:
	MOV R3, CENARIO_COLISAO		; obtém o cenário de colisão com a nave
	MOV [CENARIO_FRONTAL], R3	; coloca o cenário de "game over" para quando um asteroide colide com a nave
	MOV	R3, SOM_COLISAO			; obtém o efeito sonoro de "game over" por colisão de um asteroide com a nave
	MOV [TOCA_SOM], R3			; toca o som de "game over" por colisão com a nave
	MOV R3, PARADO
	MOV [estado_jogo], R3		; muda o estado de jogo para parado
	MOV [APAGA_ECRÃ], R3		; apaga todos os pixéis do ecrã
	MOV	[TERMINA_VIDEO], R3		; para a reprodução do video/soundtrack principais do jogo
	MOV [tecla_carregada], R3	; desbloqueia o processo sonda (serve para casos em que nenhuma sonda foi disparada e o processo está à
								; espera de uma tecla carregada para poder verficar o estado do jogo)

termina:						; termina o processo
	RET							

; **********************************************************************************************
; TESTA_LIMITES - Testa se o asteroide chegou ao limite inferior do ecrã
;
; 				Argumentos:	R1 - linha em que o asteroide está
;
; 				Retorna: 	R11 - registo com a indicação se chegou ou não ao limite
;							(1 no caso afirmativo e 0 no caso negativo)
; ***********************************************************************************************
testa_limites:
	PUSH R5

	MOV	R5, MAX_LINHA			; obtém o limite inferior do ecrã
	CMP	R1, R5					; verifica se a linha de referência do asteroide atingiu o limite
	JLT	continua_movimento		
	MOV R11, 1					; em caso afirmativo retorna R11 = 1
	JMP sai_testa_limites

continua_movimento:
	MOV R11, 0					; caso contrário devolve R11 = 0

sai_testa_limites:	
	POP	R5
	RET

;***************************************************************************************
;  OBTEM_COMBINACOES - Obtem as combinações coluna-direção para os asteroides
;
;	Retorna: R3 - indice da tabela com os pares coluna/direção possiveis
;			 R5 - tipo do asteroide
;***************************************************************************************
obtem_combinacoes:
	PUSH R0
	PUSH R6	
	
	MOV R6, MASCARA_PROB	; máscara usada para isolar os 2 bits de menor peso
	MOV	R0, TEC_COL			; endereço do dispositivo PIN
	MOVB R3, [R0]			; obtém 8 bits onde os bit 4 a 7 são aleatórios
	SHR R3, 4				; coloca os 4 bits aleatórios no bits 0 a 3 do registo
	MOV R5, R3
	AND R5, R6				; isola os dois bits de menor peso
	MOV R6, 5
	MOD R3, R6				; obtém um número entre 0 e 4 que corresponde aos indices da tabela
							; com os pares coluna/direção

	POP R6
	POP R0
	RET

;******************************************************************************************************
; TESTA_COLISAO_NAVE - Testa se um asteroide colidiu com a nave
; Argumentos : R1 - linha em que o asteroide está
;			   R2 - coluna em que o asteroide está
; Retorna	:  R10 - registo que indica se houve ou não colisão (1 em caso afirmativo, 0 caso contrário)
;*******************************************************************************************************

testa_colisao_nave:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R7
	PUSH R8
	PUSH R9

	MOV R6, LINHA_NAVE			; linha da nave 
	MOV R8, COLUNA_NAVE			; coluna inicial da nave
	MOV R9, LARGURA_NAVE		; largura da nave
	MOV R5, LARGURA_ASTEROIDE	; obtém a largura do asteroide (neste caso a largura = altura)
	CMP R7, 1					; verifica se o asteroide se está a mover para a direita
	JNZ movimento_esq
	ADD R1, R5					; obtém a linha a seguir à linha atual do canto inferior direito
	ADD R2, R5					; obtém a coluna a seguir à linha atual do canto inferior direito
	JMP verifica_colisao

movimento_esq:
	CMP R7, -1					; verifica se o asteroide se move para a esquerda
	JNZ movimento_para_baixo
	ADD R1, LARGURA_ASTEROIDE 	; obtem a linha do canto inferior esquerdo (a coluna deste canto é igual
								; à coluna de referência do asteroide )
	JMP verifica_colisao

movimento_para_baixo:
	ADD R1, LARGURA_ASTEROIDE	; linha seguinte à última linha do asteroide
	ADD R2, 2					; coluna do pixel do meio do asteroide

verifica_colisao:
	CMP R1, R6					; verifica se o asteroide se encontra na mesma linha que a 1º linha da nave
	JLT nao_colide
	CMP R2, R8					; verifica se o asteroide se encontra numa coluna a seguir à 1ª coluna da nave
	JLT nao_colide
	ADD	R8, R9					; obtém a última coluna da nave
	CMP R2, R8					; verifica se o asteroide se encontra numa coluna antes da última coluna da nave
	JGT	nao_colide
	MOV R10, 1					; coloca em R11 a indicação que o asteroide colidiu
	JMP termina_rotina			; termina a rotina

nao_colide:
	MOV R10, 0

termina_rotina:
	POP		R9 
	POP		R8
	POP		R7	
	POP		R6
	POP		R5
	POP		R4
	POP		R3
	POP		R2
	POP 	R1
	RET

;*******************************************************************************************************
; TESTA_COLISAO_SONDA - Testa se um asteroide colidiu com uma sonda
; Argumentos : R1 - linha em que o asteroide está
;			   R2 - coluna em que o asteroide está
; Retorna	:  R10 - registo que indica se houve ou não colisão (1 em caso afirmativo, 0 caso contrário)
;********************************************************************************************************

testa_colisao_sonda:
	PUSH R1
	PUSH R2
	PUSH R4
	PUSH R5
	PUSH R6
	PUSH R8

	MOV R6, [linha_sonda]		; obtém a linha da sonda atual
	MOV R8, [coluna_sonda]		; obtém a coluna da sonda atual
	MOV R5, LARGURA_ASTEROIDE	; obtéma a largura do asteroide (que neste caso é igual à altura)

	CMP R6, R1					; se a linha da sonda estiver à equerda da linha de referência atual do asteroide 
	JLT	nao_colide_sonda		; (canto superior esquerdo) então não colidem
	ADD R1, R5					; obtém a linha do extremo direito do asteroide
	CMP R6, R1					; se a linha da sonda estiver a baixo da linha do canto inferior direito do asteroide
	JGT nao_colide_sonda		; não há colisão
	CMP R8, R2					; se a coluna da sonda estiver à esquerda da coluna do canto superior esquerdo
	JLT nao_colide_sonda		; não há colisão
	ADD R2, R5					; obtém a coluna do canto inferior direito do asteroide
	CMP R8, R2					; se a coluna da sonda está à direita da coluna do canto inferior direito do asteroide
	JGT nao_colide_sonda		; não há colisão
	MOV R10, 1					; se chegar aqui quer dizer que existe colisão
	MOV [testa_colisao], R10	; informa o processo sonda de que houve uma colisão
	JMP termina_verificacao		; termina a verificação

nao_colide_sonda:
	MOV R10, 0					
	MOV [testa_colisao], R10	; informa o processo sonda de que não houve colisão

termina_verificacao:
	POP		R8
	POP		R6
	POP		R5
	POP		R4
	POP		R2
	POP 	R1
	RET

;************************************************************************************
; AUMENTA_ENERGIA - Aumenta 25% de energia da nave devido à mineração de um asteroide
;
;************************************************************************************
aumenta_energia:
	PUSH R1
	PUSH R2
	PUSH R4
	MOV R2, ENERGIA_MINER	; obtém a energia recebida da mineração de um asteroide
	MOV R1, [energia_nave]	; obtém a energia atual da nave 
	ADD R1, R2				; aumenta a energia da nave
	MOV [energia_nave], R1	; atualiza a energia da nave
	CALL converte_dec		; converte o valor da energia para o seu equivalente decimal
	MOV [DISPLAYS], R4		; mostra no display a energia atualizada
	POP R4
	POP R2
	POP R1
	RET


;******************************************************************************************
; DESENHA_EXPLOSAO - Desenha a explosão de um asteroide
; 
; Argumentos : R4 - tabela que define a explosão
;
;******************************************************************************************
desenha_explosao:
	PUSH R1
	PUSH R2
	PUSH R3
	PUSH R4
	
	MOV R1, [linha_asteroide]
	MOV R2, [coluna_asteroide]
	CALL desenha_objeto
	MOV R3, [evento_asteroide]
	CALL apaga_objeto
	POP R4
	POP R3
	POP R2
	POP R1
	RET

;******************************************************************************************
;	Processo
;	
;	SONDA - Processo responsável por coordenar o movimento da sonda, bem como a sua direção
;
;*******************************************************************************************

PROCESS	SP_inicial_sonda		; inicialização do SP do processo

sonda:
	MOV R1, 0
	MOV [linha_sonda], R1
	MOV R4, DEF_SONDA			; obtém a tabela que define a sonda
	MOV R7, MOVIMENTO_MAX_SONDA; número de movimentos máximo de uma sonda
	MOV R0, [tecla_carregada]	; fica preso no LOCK até o player clicar numa tecla
	MOV	R10, [estado_jogo]		; verifica o estado do jogo
	CMP R10, 2
	JZ  termina_processo_sonda	; se o jogo estiver parado termina o processo
	CMP R0, 2				
	JLE inicializa_sonda		
	JMP sonda					; se a tecla carregada não for (0, 1 ou 2) volta ao inicio do processo

inicializa_sonda:
	MOV	R10, SOM_SONDA			; obtém o número do efeito sonoro do disparo da sonda
	MOV	[TOCA_SOM], R10			; toca o efeito sonoro do disparo da sonda
	CALL retira_energia			; retira 5% de energia da nave quando dispara uma sonda
	MOV R1, LINHA_INICIAL_SONDA ; obtém a linha inicial da sonda
	MOV [linha_sonda], R1		; inicializa a linha da sonda
	MOV R8, movimento_sonda		; obtém a tabela que define a coluna inicial e a direção do movimento da sonda
	SHL R0, 1					; R0 é o indice da tabela com a coluna inicial e direção do movimento, 
								; logo multiplicamos por 2 de modo a poder endereçar essa tabela
	ADD R8, R0					; obtemos o indice com a coluna inicial da sonda
	MOV	R2, [R8]				; coluna inicial da sonda
	MOV [coluna_sonda], R2		; atualiza a coluna da sonda
	MOV R11, [R8 + 6]			; obtém a direção do movimento da sonda (somamos 6 porque cada WORD ocupa 2 bytes
								; e as primeiras 3 WORDS correspondem a colunas iniciais)

ciclo_sonda:
	CALL desenha_objeto			; desenha a sonda na coluna e linha especificadas
	MOV R10, [evento_sonda]		; espera a interrupção que cordena o processo

testa_pausa_sonda:
	MOV	R10, [estado_jogo]		; verifica o estado do jogo
	CMP	R10, 1					
	JZ	pausa_sonda				; se o jogo estiver em pausa salta para um LOCK que bloqueia até o jogo ser retomado
	CMP R10, 2
	JZ  termina_processo_sonda	; se o jogo estiver parado termina o processo
	CALL apaga_objeto
	MOV R10, [testa_colisao]	; lê se existiu uma colisão
	CMP R10, 1
	JZ	sonda					; em caso afirmativo reinicia o processo
	SUB R1, 1					; move a sonda para a próxima linha
	MOV [linha_sonda], R1		; atualiza a linha da sonda
	ADD R2, R11					; move a sonda para a próxima coluna
	MOV [coluna_sonda], R2		; atualiza a coluna da sonda
	SUB R7, 1					; menos um movimento possível da sonda
	CMP R7, 0					; se a sonda já tiver efetuado os 12 movimentos possíveis
	JZ	sonda					; desaparece e o processo volta a ficar à espera que o player carregue numa tecla
	JMP	ciclo_sonda				; caso contrário volta ao inicio do ciclo

pausa_sonda:
	MOV R10, [corre_jogo]		; fica "preso" no LOCK até o jogo ser retomado
	MOV R10, [estado_jogo]		; obtém o estado de jogo atual
	CMP R10, 2					; verifica se o jogo não foi terminado
	JZ 	termina_processo_sonda
	JMP ciclo_sonda				; volta ao ciclo do movimento da sonda

termina_processo_sonda:			; termina o processo
	RET		

;************************************************************************************************
; RETIRA_ENERGIA - Retira 5 % de energia da nave devido ao disparo de uma sonda
;
;************************************************************************************************
retira_energia:
	PUSH R1
	PUSH R2
	PUSH R4
	MOV R2, ENERGIA_DISP
	MOV R1, [energia_nave]
	SUB R1, R2
	MOV [energia_nave], R1
	CALL converte_dec
	MOV [DISPLAYS], R4
	POP R4
	POP R2
	POP R1
	RET

; *************************************************************************************
; DESENHA_OBJETO - Desenha um objeto com uma altura A e largura L
; Argumentos:	R1 - linha de referência do objeto
;				R2 - coluna de referência do objeto
;				R4 - endereço da tabela que define o objeto
;				R9 - ecrã a utilizar
;
;**************************************************************************************
desenha_objeto:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH 	R6
	PUSH	R7
	PUSH	R8
	MOV		[DEFINE_ECRA], R9			; escolhe o ecrã do Media Center a ser utilizado 
	MOV		R7, R2						; variavel que guarda a coluna de refrência do objeto
	MOV		R8, [R4]					; obtém a largura do objeto
	MOV		R6, [R4+2]					; obtém a altura do objeto
	MOV		R5, R8						; copia para o número de colunas a desenhar para R5 que vai servir de contador
	ADD		R4, 4						; endereço da cor do 1º pixel

desenha_pixels_coluna:					; desenha os pixels do boneco a partir da tabela
	MOV		R3, [R4]					; obtém a cor do próximo pixel do boneco
	CALL	escreve_pixel				; escreve cada pixel do boneco
	ADD		R4, 2						; endereço da cor do próximo pixel (2 porque cada cor de pixel é uma word)
	ADD		R2, 1						; próxima coluna
	SUB		R5, 1						; menos uma coluna para tratar
	JZ		próxima_linha				; terminou todas as colunas da linha, passa para a próxima linha
	JMP		desenha_pixels_coluna		; continua até percorrer toda a largura do objeto

próxima_linha:
	ADD		R1, 1						; próxima linha
	SUB		R6, 1						; menos uma linha para desenhar
	MOV		R2, R7						; reseta a coluna de inicio
	MOV		R5, R8						; reseta o número de linhas
	JNZ		desenha_pixels_coluna		; continua a desenhar o objeto caso ainda existam linhas por desenhar

	POP		R8
	POP		R7	
	POP		R6
	POP		R5
	POP		R4
	POP		R3
	POP		R2
	POP 	R1
	RET

; **********************************************************************
; APAGA_OBJETO - Apaga um objeto na linha e coluna indicadas
;				com a forma definida na tabela indicada.
; Argumentos:	R1 - linha
;				R2 - coluna
;				R4 - tabela que define o boneco
;				R9 - ecrã a utilizar
;
; **********************************************************************

apaga_objeto:
	PUSH	R1
	PUSH	R2
	PUSH	R3
	PUSH	R4
	PUSH	R5
	PUSH 	R6
	PUSH	R7
	PUSH	R8
	MOV		[DEFINE_ECRA], R9			; escolhe o ecrã do Media Center a ser utilizado 
	MOV		R7, R2						; variavel que guarda a coluna de referência do objeto
	MOV		R8, [R4]					; obtém a largura do objeto
	MOV		R6, [R4+2]					; obtém a altura do objeto
	MOV		R5, R8						; copia o número de colunas a desenhar para R5 que vai servir de contador

apaga_pixels_coluna:					; apaga os pixels do boneco a partir da tabela
	MOV		R3, 0						; coloca a cor do próximo pixel a 0
	CALL	escreve_pixel				; apaga cada pixel do boneco
	ADD		R2, 1						; próxima coluna
	SUB		R5, 1						; menos uma coluna para tratar
	JZ		atualiza_linha_apagar		; terminou todas as colunas da linha, passa para a próxima linha
	JMP		apaga_pixels_coluna			; continua até percorrer toda a largura do objeto

atualiza_linha_apagar:
	ADD		R1, 1						; pŕoxima linha
	SUB		R6, 1						; menos uma linha para apagar
	MOV		R2, R7						; reseta a coluna de inicio
	MOV		R5, R8						; reseta o número de linhas
	JNZ		apaga_pixels_coluna			; continua a apagar o objeto caso ainda existam linhas por apagar

	POP	R8
	POP	R7	
	POP	R6
	POP	R5
	POP	R4
	POP	R3
	POP	R2
	POP R1
	RET

; **********************************************************************
; ESCREVE_PIXEL - Escreve um pixel na linha e coluna indicadas.
; Argumentos:	R1 - linha
;				R2 - coluna
;				R3 - cor do pixel (em formato ARGB de 16 bits)
;
; **********************************************************************
escreve_pixel:
	MOV		[DEFINE_LINHA], R1			; seleciona a linha
	MOV		[DEFINE_COLUNA], R2			; seleciona a coluna
	MOV		[DEFINE_PIXEL], R3			; altera a cor do pixel na linha e coluna já selecionadas
	RET					

; **************************************************************************
; ROT_INT_0 - 	Rotina de atendimento da interrupção 0 (movimento asteroide)
;				Escreve no LOCK que o processo asteroide lê.
;			
; **************************************************************************
rot_int_0:
	MOV	[evento_asteroide], R0	; desbloqueia o processo asteroide
	RFE

; **************************************************************************
; ROT_INT_1 - 	Rotina de atendimento da interrupção 1 (movimento sonda)
;				Escreve no LOCK que o processo sonda lê.
;			
; **************************************************************************
rot_int_1:
	MOV	[evento_sonda], R0	; desbloqueia o processo sonda
	RFE

; *****************************************************************************
; ROT_INT_2 - 	Rotina de atendimento da interrupção 2 (energia da nave)
;				Escreve no LOCK que o processo energia lê
;			
; *****************************************************************************
rot_int_2:
	MOV [evento_energia], R0	; desbloqueia o processo energia
	RFE

; ******************************************************************************
; ROT_INT_3 - 	Rotina de atendimento da interrupção 1 (painel de luzes da nave)
;				Escreve no LOCK que o processo nave lê
;			
; ******************************************************************************
rot_int_3:
	MOV [evento_nave], R0		; desbloqueia o processo nave
	RFE

