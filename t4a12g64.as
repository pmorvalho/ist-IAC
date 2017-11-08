;----------------------------------------------------------------
;----------------------------Constantes--------------------------
;----------------------------------------------------------------

;Posicao Inicial do SP
SP_Inicial                             EQU     FDFFh

;Constantes de Interrupcao
INT_MASK_ADDR                          EQU     FFFAh
INT_MASK                               EQU     FFFFh

;Contantes para Escrita no ecra
IO_WRITE                                EQU     FFFEh
IO_CONTROL                              EQU       FFFCh


;Contantes
UM                                      EQU        0001h
TWO                                     EQU        0002h
FOUR                                    EQU        0004h
FIVE                                    EQU        0005h
SIX                                     EQU        0006h
EIGHT                                   EQU        0008h
NINE                                    EQU        0009h
FOURTEEN                                EQU        000Eh

;Posicao inicial do Passaro
COLUMN_EARLY_BIRD                       EQU         0014h
LINE_EARLY_BIRD                         EQU         0C00h
    
;Catacter que indica o fim da string
END_TEXT                                EQU         '@'
BLANK_SPACE                             EQU         ' ' 

;Caracter usados para escrita dos obstaculos
OBSTACLE_CHAR                           EQU         'X'


;Caracteres usado para escrever os limites
LIMIT_CHAR                              EQU        '-'

;Numero maximo de linhas e colunas
NUM_MAX_LINE                            EQU         0017h
NUM_MAX_COLUMN                          EQU         004eh
TOTAL_COLUMNS_SCREEN                    EQU         000Ch

;Velocidade do Interruptor
REAL_VELOCITY_INT                       EQU         0FF6h

;Gravidade
REAL_GRAVITY                            EQU         0002h

;Constantes para usar Leds 
LED_WRITE                               EQU         FFF8h
LED_START                               EQU         8000h

;Constantes para o Temporizador
TEMP_CONTROL                            EQU         FFF7h
TEMP_COUNT                              EQU         FFF6h

;Bonus
GRAVITYSHIFT_VELOCITY_INT               EQU         001Ah
GRAVITY_SHIFT                           EQU         0FFDh

;Enderecos para escrever no Display
IO_DISPLAY0                             EQU         FFF0h
IO_DISPLAY1                             EQU         FFF1h
IO_DISPLAY2                             EQU         FFF2h
IO_DISPLAY3                             EQU         FFF3h

;Constante para a Pontuacao Early
EARLY_HIGHSCORE                          EQU         FFF6h 
;a pontuacao e inicializada negativa, pois e decrementada 
;ate ser atingido um valor positivo, altura em que se começa
;a escreve-la no display, sendo que isto corresponde ao 
;passaro passar a primeira coluna

;Mascara usada para criar uma Altura Aleatoria
NIBBLE_MASK                             EQU         000fh

;Constantes do espaco entre as partes superior 
;e inferior de cada coluna
SPACE_VERTICAL_COLUMN_FINAL             EQU         0500h
SPACE_VERTICAL_COLUMN_EARLY             EQU         0800h
Max_Superior_Obstacle_Size              EQU         000Dh
 ;falta metermos para inicializar no reset status

;Constante da velocidade Early das colunas
Cycle_Update_Obs_Value_Early            EQU        0005h

;Endereco para ler o estado dos interruptores
INTERRUPTOR_READ                        EQU        FFF9h


;Constantes para Escrita nos LCDs
LCD_WRITE                               EQU        FFF5h
LCD_CONTROL                             EQU        FFF4h
LCD_START                               EQU        8000h
LCD_CICLO_WRITE_END_1                   EQU        800Fh
LCD_CICLO_WRITE_BEG_1                   EQU        8000h
LCD_CICLO_WRITE_BEG_2                   EQU        8010h
LCD_CICLO_WRITE_END_2                   EQU        801Fh; meio da 
; segunda linha do LCD (usada para escrever "colunas" na 
; segunda linha)


;---------------------------------------------------------------
;--------------------------Variaveis----------------------------
;---------------------------------------------------------------


			             ORIG	8000h
Early_Text_Line12	     STR    'Prepare-se',END_TEXT								
Early_Text_Line14        STR    'Prima o interruptor I1',END_TEXT
ESPACO_CHAR              STR    '  ',END_TEXT 
BIRD_CHAR  		         STR	'o>',END_TEXT                       
Final_Text               STR    'Fim do Jogo',END_TEXT      
Restart_Text             STR    'Para reiniciar clique em I1',END_TEXT
End_Text                 STR    'Para acabar clique em qualquer outra tecla', END_TEXT
Distance_Text            STR    'Distancia:',END_TEXT
Score_Text               STR    'Recorde:',END_TEXT
Obstacles_Text           STR    'Obstaculos Percorridos!',END_TEXT
Pause_Text               STR    'Prima I3 para ir para modo de Pause e I0 para sair',END_TEXT


Bird_Position		    WORD    0000h
Bird_Velocity         WORD    0FF6h
Started                 WORD    0001h
Jumped                WORD    0001h
TimePassed              WORD    0001h
GameOver                WORD    0001h
Paused                  WORD    0001h
Ended                   WORD    0001h
Invert                  WORD    0000h

;--------------------Obstaculos----------------------------
Obstacles               TAB     001ch      
;Vector de 13 obstaculos +1 controlo +
; 13 altura aleatorias + 1 controlo = 28

Obstacle_Break          WORD    0001h
;interval entre as colunas comeca a 1, mas durante
;o jogo e 6

Cycle_Update_Obs        WORD    0000h  
Cycle_Update_Obs_Value  WORD    0005h  
Space_Vertical_Column   WORD    0800h

RandomNumber            WORD    0000h
Score                   WORD    0000h
Current_LED             WORD    0000h
Level                   WORD    0000h
SubLevel                WORD    0001h
Increased               WORD    0000h
LevelLimit              WORD    0001h

Gravity              WORD    0003h
Switch_Velocity WORD    0FF6h

LCDCounter0   WORD    0000h
LCDCounter1   WORD    0000h
LCDCounter2   WORD    0000h
LCDCounter3   WORD    0000h
LCDCounter4   WORD    0000h

DisplayCounter0   WORD    0000h
DisplayCounter1   WORD    0000h
DisplayCounter2   WORD    0000h
DisplayCounter3   WORD    0000h
DisplayCounter4   WORD    0000h

RecordeCounter0   WORD    0000h
RecordeCounter1   WORD    0000h
RecordeCounter2   WORD    0000h
RecordeCounter3   WORD    0000h
RecordeCounter4   WORD    0000h

                        ORIG    FE00h
INT0                    WORD    Jump
INT1                    WORD    ChangeStart
INT2                    WORD    Increase
INT3                    WORD    Pause
INT4                    WORD    Finish
INT5                    WORD    Finish
INT6                    WORD    Finish
INT7                    WORD    Finish
INT8                    WORD    Finish
INT9                    WORD    Finish
INT10                   WORD    Finish
INT11                   WORD    Finish
INT12                   WORD    Finish
INT13                   WORD    Finish
INT14                   WORD    Finish
INT15                   WORD    Time



;-----------------------------------------------------------------------
;---------------------------------Ciclo de Jogo-------------------------
;-----------------------------------------------------------------------

                ORIG    0000h
Inicio:	        MOV	    R7,SP_Inicial 
		        MOV	    SP,R7         ;incializamos o SP
		        MOV	    R7,INT_MASK         
		        MOV	    M[INT_MASK_ADDR],R7 ;ativacao da Mascara de interruptores
                MOV     R6,Cycle_Update_Obs_Value
	            MOV     R5,R0
                CALL	ControlActive        ;activamos o Control
Restart:	    CALL    ResetStats          ;Reset nas variaveis 
                CALL    CleanVector         ;Limpa o vector dos Obstaculos
                CALL    CleanBoard          ;Limpa o Tabuleiro de Jogo
                CALL	EarlyMessage        ;Escreve a Mensagem Inicial
                ENI 
                CALL    StartTime           ;Liga o temporizador
CheckI1:        INC     R5
                CMP	    M[Started],R0
		        BR.NZ	CheckI1     ;Ciclo usado para gerar um numero aleatorio
                MOV     M[RandomNumber],R5                
		        CALL	Start
                INC     M[Started]
CicloJogo:      CMP     M[TimePassed],R0
                BR.NZ   CicloJogo
                CALL    Update
                CALL    VerifyColision       
                DEC     M[Cycle_Update_Obs]
                CMP     M[Cycle_Update_Obs],R0
                BR.NZ   TimeIncrease
                CALL    DealWithObstacles  
                CALL    VerifyColision     
                MOV     R1,M[R6]
                MOV     M[Cycle_Update_Obs],R1
TimeIncrease:   INC     M[TimePassed]
                CALL    StartTime
                CALL    VerifyPause
                CALL    GravityShift
CheckGameover:  CMP     M[GameOver],R0
                BR.NZ   CicloJogo

                CALL    CleanBoard
                CALL    GameOverMessage
                MOV     M[Increased],R0
                MOV     R7,UM
                MOV     M[Jumped],R7
                CALL    UpdateRecord
                PUSH    801Ah
                PUSH    LCD_CICLO_WRITE_END_2
                PUSH    RecordeCounter0
                CALL    UpdateDistance
CheckRestart:   CALL    VerifyEnd
                CMP     M[Ended], R0
                BR.Z    Limpa   
                CMP     M[Started],R0
                BR.NZ   CheckRestart
                INC     M[Started]
                INC     M[GameOver]   
                JMP     Restart
Limpa:          CALL    CleanBoard
End:            BR      End



;-----------------------------------------------------------------
;----------------------------Rotinas------------------------------
;-----------------------------------------------------------------


;---------------------------------------------------
;--------------------Interrupcoes-------------------
;---------------------------------------------------

;Diminiu o nivel
Increase:        INC     M[Increased]
                RTI

;Acaba o jogo
Finish:          MOV     M[Ended], R0
                RTI

ChangeStart:     MOV     M[Started],R0
                RTI

Time:          MOV     M[TimePassed],R0
                RTI

;Faz subir o passaro
Jump:           MOV     M[Jumped],R0
                RTI
                
;Interrupcao da Pausa - Extra
Pause:          MOV     M[Paused],R0
                RTI

;-------------------------------------------------------------------
;----------------------Rotinas inicias e mensagens------------------
;-------------------------------------------------------------------

;---------------------------Start-------------------
;Rotina que inicializa a janela de texto para começar o jogo

;Entradas ---
;Saidas   ---
;Mudancas - Limpa a janela
;           Coloca os Limites
;           Escreve o Passaro
;           Escreve o Primeiro Obstaculo
;           Ativa o LCD, e escreve neste 'Distancia:'
;           e 'Recorde:'
;----------------------------------------------------
Start:          CALL    CleanBoard
                PUSH    BLANK_SPACE
                PUSH    0B00h
                CALL    WriteBounds
                PUSH    BLANK_SPACE
                PUSH    0D00h
                CALL    WriteBounds
                PUSH    LIMIT_CHAR
                PUSH    R0
                CALL    WriteBounds
                PUSH    LIMIT_CHAR
                PUSH    1700h
                CALL    WriteBounds  
                MOV     R1,LINE_EARLY_BIRD
                ADD     R1,COLUMN_EARLY_BIRD
                MOV     M[Bird_Position],R1
                MOV     R2,BIRD_CHAR
                PUSH    R2
                PUSH    R1
                CALL    EscString
                MOV     R1,LCD_START
                MOV     M[LCD_CONTROL],R1
                PUSH    LCD_CICLO_WRITE_BEG_1
                MOV     R2,Distance_Text
                CALL    EscLCD
                PUSH    LCD_CICLO_WRITE_BEG_2
                MOV     R2,Score_Text
                CALL    EscLCD
                CALL    DealWithObstaclesInit
EndStart:       RET

;-----------------------------------StartTime----------------------------------------------
;Rotina que liga o temporizador e lhe da um intervalo de tempo para ativar uma interrupcao

;Entradas ---
;Saidas   ---
;Mudancas ---
;-------------------------------------------------------------------------------------------

StartTime:      PUSH    R1
                MOV     R1,1
                MOV     M[TEMP_CONTROL],R1
                MOV     R1,1
                MOV     M[TEMP_COUNT],R1
                POP     R1
                RET



;-----------------------------------ResetStats----------------------------------------
;Retorna todos as variaveis necessarias aos seus valores inicias 

;Entradas ---
;Saidas   ---
;Mudancas - Em todas as variaveis necessarias
;-------------------------------------------------------------------------------------------

ResetStats:     PUSH    R1
                MOV     R1,EARLY_HIGHSCORE
                MOV     M[Score],R1
                MOV     R1,Cycle_Update_Obs_Value_Early
                MOV     M[Cycle_Update_Obs_Value],R1
                MOV     R1,M[Cycle_Update_Obs_Value]
                MOV     M[Cycle_Update_Obs],R1
                MOV     R1,LED_START
                MOV     M[LED_WRITE],R1
                MOV     M[Level],R0
                MOV     M[SubLevel],R0
                INC     M[SubLevel]
                MOV     R1,M[Switch_Velocity]
                MOV     M[Bird_Velocity],R1
                MOV     R1, UM
                MOV     M[Obstacle_Break],R1
                MOV     R1,SPACE_VERTICAL_COLUMN_EARLY
                MOV     M[Space_Vertical_Column],R1
                MOV     R1,LED_START
                MOV     M[Current_LED],R1
                MOV     M[IO_DISPLAY0],R0
                MOV     M[IO_DISPLAY1],R0
                MOV     M[IO_DISPLAY2],R0
                MOV     M[IO_DISPLAY3],R0
                MOV     M[DisplayCounter0],R0
                MOV     M[DisplayCounter1],R0
                MOV     M[DisplayCounter2],R0
                MOV     M[DisplayCounter3],R0
                MOV     M[DisplayCounter4],R0
                MOV     M[LCDCounter0],R0
                MOV     M[LCDCounter1],R0
                MOV     M[LCDCounter2],R0
                MOV     M[LCDCounter3],R0
                MOV     M[LCDCounter4],R0
                POP     R1
                RET     

;-----------------------------------EarlyMessage-----------------------------
;Imprime a mensagem inicial no ecra 

;Entradas ---
;Saidas   ---
;Mudancas ---
;---------------------------------------------------------------------------

EarlyMessage:   PUSH    R1
                PUSH    R2
                MOV     R1,0B22h
                MOV     R2,Early_Text_Line12
                PUSH    R2
                PUSH    R1
                CALL    EscString ; escreve a primeira string
                MOV     R1,0D1Ch
                MOV     R2,Early_Text_Line14
                PUSH    R2
                PUSH    R1
                CALL    EscString ; escreve a segunda string
                MOV     R1, 0F10h
                MOV     R2, Pause_Text
                PUSH    R2
                PUSH    R1
                CALL    EscString
                POP     R2
                POP     R1
                RET


;-----------------------------------GameOverMessage-------------------------------
;Imprime no ecra a mensagem do fim do jogo

;Entradas ---
;Saidas   ---
;Mudancas ---
;----------------------------------------------------------------------------------

GameOverMessage:PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                MOV     R3,30h
                MOV     R1,0B22h
                MOV     R2, Final_Text
                PUSH    R2
                PUSH    R1
                CALL    EscString
                MOV     R1,0D19h
                MOV     R2,DisplayCounter4
FindZeroCicle:MOV  R4,M[R2]
                CMP     R4,R0
                BR.NZ   WriteScoreCicle
                INC     R1
                DEC     R2
                CMP     R1,0D1Dh
                BR.NZ   FindZeroCicle      
WriteScoreCicle:MOV    R4,M[R2]     
                ADD     R4,R3
                MOV     M[IO_CONTROL],R1
                PUSH    R4
                CALL    EscCar
                INC     R1
                DEC     R2
                CMP     R1,0D1Eh
                BR.NZ   WriteScoreCicle

                MOV     R1, 0D1fh
                MOV     R2, Obstacles_Text
                PUSH    R2
                PUSH    R1
                CALL    EscString
                MOV     R1,0F1bh
                MOV     R2, Restart_Text
                PUSH    R2
                PUSH    R1
                CALL    EscString
                MOV     R1,1115h
                MOV     R2, End_Text
                PUSH    R2
                PUSH    R1
                CALL    EscString
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET


;-----------------------------------ControlActive----------------------------------------
;Activa o control

;Entradas ---
;Saidas   ---
;Mudancas -  control fica activo
;----------------------------------------------------------------------------------

ControlActive:  MOV             R1,FFFFh
                MOV             M[IO_CONTROL],R1
                RET


;----------------------------------------------------------------------
;------------------------------OBSTACULOS------------------------------
;----------------------------------------------------------------------


;-----------------------------------MakeObstacle----------------------------------------
;Rotina que cria um obstaculo, dando-lhe uma posicao e uma altura aletoria 

;Entradas ---
;Saidas   ---
;Mudancas ---
;-------------------------------------------------------------------------------------------

MakeObstacle:      PUSH       R1
                   PUSH       R2
                   PUSH       R3
                   PUSH       R4
                   PUSH       R5
                   MOV        R1, Obstacles ; vector de obstaculos
                   MOV        R3, M[SP+7]   ; posicao do obstaculo no vector
                   MOV        R4, 014eh
                   MOV        R5, FOURTEEN
                   ADD        R1, R3
                   MOV        M[R1], R4
                   ADD        R1, R5
                   PUSH       R0                   
                   CALL       RandomHeight
                   POP        R2
                   MOV        M[R1], R2 ; nova altura aleatoria 

EndMakeObstacles:  POP        R5
                   POP        R4
                   POP        R3
                   POP        R2
                   POP        R1
                   RETN       1


;---------------------------ManagesObstacles-----------------------------
;Trata de escrever os obstaculos no ecra. Obstaculos constituidos 
;pelo argumento que a rotina recebe da pilha

;Entradas - Caracter que vai escrever
;Saidas   ---
;Mudancas ---
;-------------------------------------------------------------------------

ManagesObstacles:           PUSH     R1
                            PUSH     R2
                            PUSH     R4
                            PUSH     R5
                            PUSH     R7
                            MOV      R1, Obstacles   ; vector de obstaculos
                            MOV      R2, M[SP+7]     ; caracter a escrever 
                            MOV      R4, R0
                            MOV      R5, FOURTEEN
                            MOV      R7, R0

ManagesObstaclesCicle:     CMP      M[R1], R0
                           BR.Z     EndManagesObstacles
                           MOV      R7, M[R1]      
                           PUSH     M[R1]        ; posicao a escreve
                           PUSH     R2           ; caracter a escrever
                           MOV      R4, R1
                           ADD      R4, R5
                           PUSH     M[R4]        ; altura aleatoria
                           CALL     WriteVerticalObs ; escreve obstaculo
                           INC      R1
                           BR       ManagesObstaclesCicle

EndManagesObstacles:       POP      R7 
                           POP      R5
                           POP      R4
                           POP      R2
                           POP      R1
                           RETN     1


;----------------------------WriteObstacles------------------------------
;Chama a rotina ManagesObstacles que vai apagar os obstaculos 
;pondo um espaco na sua posicao

;Entradas ---
;Saidas   ---
;Mudancas ---
;-------------------------------------------------------------------------

DeleteObstacles:   PUSH     R1
                   MOV      R1, BLANK_SPACE
                   PUSH     R1
                   CALL     ManagesObstacles
                   POP      R1
                   RET      


;-----------------------------WriteObstacles-----------------------------
;Chama a rotina ManagesObstacles que vai escrever os obstaculos 
;pondo X na sua posicao

;Entradas ---
;Saidas   ---
;Mudancas ---
;-------------------------------------------------------------------------

WriteObstacles:    PUSH     R1
                   MOV      R1, OBSTACLE_CHAR
                   PUSH     R1
                   CALL     ManagesObstacles
                   POP      R1
                   RET    


;-----------------------------UpdateObstacles-------------------------------
;Faz o update dos obstaculos, verifica quantos obstaculos existem em campo, 
;decrementa um na posicao de cada obstaculo, e quando o obstaculo ainda nao 
;foi iniciado, chama a rotina para criar o obstaculo.

;Entradas ---
;Saidas   ---
;Mudancas ---
;---------------------------------------------------------------------------

UpdateObstacles:         PUSH     R1 
                         PUSH     R2
                         PUSH     R3
                         PUSH     R4
                         PUSH     R5
                         MOV      R1, Obstacles
                         MOV      R2, FF00h; -1, em termos de colunas
                         MOV      R3, R0
                         MOV      R4, 0100h
                         MOV      R5, R0 


                         DEC      M[Obstacle_Break] ; decrementa tempo entre obstaculos
UpdateObstaclesCicle:    CMP      M[R1], R0
                         BR.Z     Verifica13
                         MOV      R5, 0101h
                         CMP      M[R1], R5        ; verifica ultima coluna
                         BR.Z     ProduceObstacle
                         MOV      R5,M[R1]
                         SHL      R5, EIGHT
                         ADD      R5, R2
                         SHR      R5, EIGHT
                         ADD      R5, R4
                         MOV      M[R1], R5    ; decrementa coluna
                         INC      R1
                         INC      R3
                         BR       UpdateObstaclesCicle  

Verifica13:              CMP      R3, FOURTEEN  ;verifica o numero de colunas actualizadas
                         BR.Z     EndUpdateObstacles  
ProduceObstacle:         CMP      M[Obstacle_Break], R0
                         BR.NZ    EndUpdateObstacles
                         PUSH     R3
                         CALL     MakeObstacle  ; cria obstaculo
                         CALL     UpdateScore
                         MOV      R5, SIX
                         MOV      M[Obstacle_Break], R5
                         INC      R1
                         INC      R3
                         JMP      UpdateObstaclesCicle

EndUpdateObstacles:      POP        R5
                         POP        R4
                         POP        R3
                         POP        R2
                         POP        R1
                         RET


;---------------------------DealWithObstacles------------------------------
;Faz o update dos obstaculos, apaga-os do ecra, faz o seu update, 
; verifica o nivel do jogo escreve os obstaculos no ecra, e vai actualizar 
;o contador e a distancia.

;Entradas ---
;Saidas   ---
;Mudancas ---
;---------------------------------------------------------------------------

DealWithObstacles:      CALL       DeleteObstacles
DealWithObstaclesInit:  CALL       UpdateObstacles
                        CALL       VerifyLevel
                        CALL       WriteObstacles
                        PUSH       FIVE
                        PUSH       LCDCounter0
                        CALL       Count
                        PUSH       800Ah
                        PUSH       LCD_CICLO_WRITE_END_1
                        PUSH       LCDCounter0
                        CALL       UpdateDistance
                        RET      


;-------------------------------------------------------------------
;-----------------------------Rotinas Gerais------------------------
;-------------------------------------------------------------------

;-----------------------------RandomHeight---------------------------
;Devolve uma altura aleatoria para o obstaculo

;Entradas ---
;Saidas   ---
;Mudancas ---
;--------------------------------------------------------------------

RandomHeight:   PUSH    R4       ;Preciso chamar com um PUSH R0 antes
                PUSH    R5
                MOV     R5,M[RandomNumber]
                TEST    R5,UM
                BR.Z    RandomHeightCont
                XOR     R5,8016h
RandomHeightCont:ROR R5,UM
                MOV     M[RandomNumber],R5
                MOV     R4,Max_Superior_Obstacle_Size  
                DIV     R5,R4
                ADD     R4,TWO
                AND     R4,NIBBLE_MASK
                MOV     M[SP+4],R4
                POP     R5
                POP     R4
                RET

;------------------------------GravityFX------------------------------
;Rotina que trata do afecto da gravidade no Bird

;Entradas - 
;Saidas   ---
;Mudancas - Altera a velocidade do passaro segundo a 
;           aceleracao da gravidade
;--------------------------------------------------------------------
 

GravityFX:      PUSH    R1
                MOV     R1,M[Gravity]
                ADD     M[Bird_Velocity],R1
                POP     R1
                RET

;-----------------------------Colision-------------------------------
;Vai ver se ocorre alguma colisao entre o passaro e algum obstaculo 

;Entradas - Vem pela pilha a posicao da coluna do passaro (bico ou bola) 
;para ver se ha colisao
;Saidas   ---
;Mudancas - Se ocorrer colisao vai activar a flag do GameOver
;----------------------------------------------------------------------


;Rotina que trata da Colision do Bird com as colunas 
Colision:        PUSH    R1
                PUSH    R2
                PUSH    R4
                PUSH    R3
                MOV     R1, Obstacles 
                MOV     R2, R0
                MOV     R4, R0
                MOV     R4, M[SP+6]
ColisionPos:    CMP     M[R1], R0
                BR.Z    EndColision
                MOV     R2, M[R1]
                SHL     R2, EIGHT
                SHR     R2, EIGHT
                CMP     R2, R4     ; compara coluna do obstaculo com a posicao
                BR.Z    VerfColision
                INC     R1
                BR      ColisionPos
VerfColision:   ADD     R1, FOURTEEN
                MOV     R2, M[R1]
                MOV     R4, M[Bird_Position]
                SHR     R4, EIGHT
                CMP     R4, R2   ; verifica se o passaro esta acima da altura
                BR.N    Clashes
                MOV     R3, M[Space_Vertical_Column]
                SHR     R3, EIGHT
                ADD     R2, R3
                CMP     R4, R2  ; verifica se o passaro esta abaixo da meia coluna inferior
                BR.N    EndColision 
Clashes:         MOV     M[GameOver],R0
EndColision:     POP     R3
                POP     R4
                POP     R2
                POP     R1
                RETN    1  
;-----------------------------------Count---------------------------------------
;Faz um incremento decimal aos contadores inseridos, os quais representam as várias
;casas de um numero, tal como a Pontuacao para o Display e a Distancia para o LCD

;Entradas - Na pilha recebemos:
;               O numero de casas que o contador que queremos incrementar tem (R5)
;               O endereço do primeiro contador que queremos incrementar(R3)
;Saidas   ---
;Mudancas - Incrementa o contador pretendido
;----------------------------------------------------------------------------------
Count:          PUSH    R3
                PUSH    R4
                PUSH    R5
                MOV     R3,M[SP+5]
                MOV     R4,NINE
                MOV     R5,M[SP+6]
CountCicle:     CMP     M[R3],R4
                BR.Z    MaxCount
                INC     M[R3]
                BR      EndCount
MaxCount:       MOV  M[R3],R0
                INC     R3
                DEC     R5
                BR.Z    EndCount
                BR      CountCicle
EndCount:       POP     R5
                POP     R4
                POP     R3
                RETN    2


;-------------------------------------------------------------------
;-------------------------------Verificações------------------------
;-------------------------------------------------------------------


;-----------------------------------OutOfBounds---------------------
;Verifica se o passaro nao passou os limites do jogo

;Entradas - Recebe da pilha a posicao do passaro
;Saidas   ---
;Mudancas - caso passe os limites activa a flag do GameOver
;--------------------------------------------------------------------

OutOfBounds:    PUSH   R1
                PUSH   R2
                MOV    R1,M[SP+4]
                SHR    R1,EIGHT
                CMP    R1,R0
                BR.P   Prox
                MOV    M[GameOver],R0
                BR     EndOutOfBounds
Prox:           CMP    R1,NUM_MAX_LINE
                BR.N   EndOutOfBounds
                MOV    M[GameOver],R0
EndOutOfBounds: POP    R2
                POP    R1
                RETN   1


;---------------------------VerifyLevel---------------------------
;Verifica se o nivel foi aumentado ou diminuido, atraves dos 
;interruptores I1 e I2 terem ou nao sido premidos
;Caso tenham sido, a rotina chama as rotinas necessarias para
;provocar alteracoes no jogo dependendo do nivel corrente

;Entradas ---
;Saidas   ---
;Mudancas - As flags do Increased e do Started
;-----------------------------------------------------------------

VerifyLevel:    CMP     M[Increased],R0
                BR.Z    NoRaise
                PUSH    M[Increased]
                CALL    ChangeLevel
                PUSH    UM
                CALL    ChangeLevelEffects
                DEC     M[Increased]
                BR      EndVerifyLevel
NoRaise:        CMP     M[Started],R0           
                BR.NZ   EndVerifyLevel                       
                PUSH    M[Started]
                CALL    ChangeLevel
                PUSH    R0
                CALL    ChangeLevelEffects
                INC     M[Started]
EndVerifyLevel: RET

;-----------------------------------VerifyEnd---------------------------
;Verifica se a interrupcao para acabar o jogo já ocorreu, 
; quando esta ocorrer, caso  ocorra a flag do acabamento do jogo e activada

;Entradas ---
;Saidas   ---
;Mudancas ---
;----------------------------------------------------------------------

VerifyEnd:      PUSH    R4
                MOV     R4, UM
                CMP     M[Paused], R0
                BR.Z    ChangeEnd
                CMP     M[Increased], R4
                BR.Z    ChangeEnd
                BR      EndEnd
ChangeEnd:      MOV     M[Ended],R0
EndEnd:         POP     R4
                RET

;-----------------------------VerifyColision------------------------
;Verifica se ocorre colisao entre as duas posicoes do passaro e os obstaculos 
;para isso chama a rotina Colision

;Entradas ---
;Saidas   ---
;Mudancas - 
;-------------------------------------------------------------------


VerifyColision:  PUSH    R4
                  MOV     R4, COLUMN_EARLY_BIRD  ; posicao da coluna do bico
                  INC     R4
                  PUSH    R4
                  CALL    Colision
                  MOV     R4, COLUMN_EARLY_BIRD ; posicao da coluna do cabeca
                  PUSH    R4
                  CALL    Colision
                  POP     R4
                  RET

;-------------------------------------------------------------------
;--------------------------------Updates----------------------------
;-------------------------------------------------------------------

;--------------------------------Update----------------------------
;Rotina que trata do afecto da gravidade no passaro

;Entradas - 
;Saidas   ---
;Mudancas - Alteracao a velocidade, quer seja pelo interruptor ser 
;           pressionado ou pela aceleracao da gravidade
;           Alteracao da posicao do passaro atraves da chamada do
;           UpdateBird
;-------------------------------------------------------------------

Update:         CMP     M[Jumped],R0
                BR.NZ   NoJump
                MOV     R7,M[Switch_Velocity]           ;LOOK HERE E VE SE É PRECISO NEGAR E DAR SHL, E SE PODEMOS METER LOGO O VALOR RESULTANTE NA
                MOV     M[Bird_Velocity],R7
                CALL    UpdateBird
                INC     M[Jumped]
                BR      EndUpdate
NoJump:         CALL    GravityFX
                CALL    UpdateBird
EndUpdate:      RET



;-----------------------------UpdateBird-----------------------
;Rotina que apaga o passaro da sua posicao currente, calcula a
;nova posicao do passaro e escreve-o nessa nova posicao, caso
;esta nao esteja fora dos limites do jogo. Caso esteja fora, 
;a flag do GameOver e ativada

;Entradas ---
;Saidas   ---
;Mudancas - Atualiza o valor da posicao do passaro e atualiza
;           o passaro no janela de texto
;--------------------------------------------------------------

UpdateBird:     PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4

                MOV     R1,Bird_Position
                MOV     R3,M[R1]
                MOV     R4,M[Bird_Velocity]
                SHR     R4,FOUR
                SHL     R4,EIGHT
                MOV     R2,ESPACO_CHAR
                PUSH    R2
                PUSH    R3
                CALL    EscString
                ADD     M[R1],R4
                MOV     R3,M[R1]
                PUSH    R3
                CALL    OutOfBounds
                CMP     M[GameOver],R0
                BR.Z    EndUpdateBird
                MOV     R2,BIRD_CHAR
                PUSH    R2
                PUSH    R3
                CALL    EscString
EndUpdateBird:  POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

;----------------------UpdateScore--------------------------
;Rotina que incrementa a Pontuacao, e escreve-a no Display

;Entradas ---
;Saidas   ---
;Mudancas - Altera a Pontuacao e o Display
;---------------------------------------------------------------
UpdateScore:    INC     M[Score]
                CMP     M[Score],R0
                BR.NP   EndScore
                PUSH    FOUR
                PUSH    DisplayCounter0
                CALL    Count
                PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                MOV     R2, DisplayCounter0
                MOV     R3, IO_DISPLAY0
                MOV     R4,FOUR
CicloScore:     MOV     R1, M[R2]
                ADD     R1,30h
                MOV     M[R3], R1
                INC     R3
                INC     R2
                DEC     R4
                BR.NZ   CicloScore
                POP     R4
                POP     R3
                POP     R2
                POP     R1
EndScore:       RET
;----------------------------UpdateDistance---------------------------
;Rotina que atualiza a distancia atraves da sua escrita para o LCD

;Entradas - Na pilha obtemos:
;                o limite para o qual queremos escrever(R4)
;                o apontador para aonde queremos escrever(R3)
;                o contador que iremos escrever no LCD(R1)

;Saidas   ---
;Mudancas - Altera o LCD
;----------------------------------------------------------------------

UpdateDistance:PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                MOV     R1,M[SP+6]
                MOV     R3,M[SP+7]
                MOV     R4,M[SP+8]
CicloUpdateDist:MOV     M[LCD_CONTROL],R3
                MOV     R2,M[R1]
                ADD     R2,30h
                MOV     M[LCD_WRITE],R2
                INC     R1
                DEC     R3
                CMP     R3,R4
                BR.NZ   CicloUpdateDist
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RETN    3


;-----------------------------------ChangeLevel-------------------
;Modifica o nivel do jogo

;Entradas - Na pilha, obtemos um valor que controla caso queremos 
;           subir o nivel, caso o valor inserido seja 1,
;           ou descer o nivel, caso o valor inserido seja 0
;Saidas   ---
;Mudancas - Altera o valor do Level e atualiza os LEDs 
;           correspondentes ao nivel
;-----------------------------------------------------------------
ChangeLevel:    PUSH    R1
                PUSH    R2
                PUSH    R3
                MOV     R1,M[SP+5]
                MOV     R2,000Fh
                MOV     R3,M[Current_LED]
                CMP     R1,R0          
                BR.NZ   RaiseLevel      
DecreaseLevel:  CMP     M[Level],R0
                BR.Z    LimiteLvlReach
                SHL     R3,UM
                MOV     M[LED_WRITE],R3
                DEC     M[Level]
                MOV     R2,UM
                MOV     M[LevelLimit],R2
                BR      EndChangeLevel
RaiseLevel:     CMP     M[Level],R2
                BR.Z    LimiteLvlReach
                SHR     R3,UM
                ADD     R3,LED_START
                MOV     M[LED_WRITE],R3
                INC     M[Level]
                MOV     R2,UM
                MOV     M[LevelLimit],R2
                BR      EndChangeLevel
LimiteLvlReach: MOV     M[LevelLimit],R0
EndChangeLevel: MOV     M[Current_LED],R3
                POP     R3
                POP     R2
                POP     R1
                RETN    1


;--------------------------------ChangeLevelEffects--------------------------------
;Provoca a mudanca de velocidade e/ou do espaco entre as partes inferiores e 
;superiores das colunas, respectivamente ao nivel em que se encontram

;Entradas - Pela pilha recebe um valor que provoca a funcao provocar os efeitos do
;            aumento do nivel, caso o valor seja 1, ou provoca os efeitos da
;            diminuicao do nivel, caso o valor seja 0.
;Saidas   ---
;Mudancas - Altera a velocidade das colunas, atraves da mundanca do Cycle_Update_Obs
;            caso o nivel seja incrementado e o subnivel estiver a 4, ou entao 
;            caso o nivel seja decrementado e o subnivel estiver a 1
;         - Altera o espaco entre a parte superior e inferior da coluna atraves da mudanca
;            do Space_Vertical_Column e do Max_Espaco_Vertical_Col
;            caso o nivel seja incrementado e o subnivel for menor do que 4, o Space_Vertical_Column
;            e incrementado,
;            caso o nivel seja decrementado e o subnivel for maior do que 1, o Space_Vertical_Column
;            e decrementado,
;            caso o subnivel ultrapasse 4 ou seja menor do que 1, entao o Space_Vertical_Column
;            volta ao seu valor Early

;----------------------------------------------------------------------------------   

ChangeLevelEffects:PUSH   R1
                PUSH    R2
                MOV     R1,M[SP+4];valor que diz se é increase ou Decrease
                CMP     R1,R0
                JMP.Z    DecreaseEffects
IncreaseEffects:CMP     M[LevelLimit],R0
                JMP.Z   EndChangeLevelEffects
                INC     M[SubLevel]
                MOV     R1,M[SubLevel]
                CMP     R1,FIVE
                BR.NZ   NoIncEffects
                MOV     R1,UM
                MOV     M[SubLevel],R1
                MOV     R1,SPACE_VERTICAL_COLUMN_EARLY
                MOV     M[Space_Vertical_Column],R1
                DEC     M[Cycle_Update_Obs_Value]
                MOV     R1,M[Cycle_Update_Obs_Value]
                MOV     M[Cycle_Update_Obs],R1
                JMP      EndChangeLevelEffects

NoIncEffects:   MOV     R1,M[Space_Vertical_Column]
                SUB     R1,0100h
                MOV     M[Space_Vertical_Column],R1
                BR     EndChangeLevelEffects

DecreaseEffects:CMP     M[LevelLimit],R0
                JMP.Z   EndChangeLevelEffects
                DEC     M[SubLevel]
                MOV     R1,M[SubLevel]
                CMP     R1,R0
                BR.NZ   NoDecEffects
                MOV     R1,FOUR
                MOV     M[SubLevel],R1
                MOV     R1,SPACE_VERTICAL_COLUMN_FINAL
                MOV     M[Space_Vertical_Column],R1
                INC     M[Cycle_Update_Obs_Value]
                MOV     R1,M[Cycle_Update_Obs_Value]
                MOV     M[Cycle_Update_Obs],R1
                BR      EndChangeLevelEffects

NoDecEffects:   MOV     R1,M[Space_Vertical_Column]
                ADD     R1,0100h
                MOV     M[Space_Vertical_Column],R1

EndChangeLevelEffects:POP   R2
                 POP   R1
                RETN    1


;-------------------------------------------------------------------
;-------------------------------Escritas----------------------------
;-------------------------------------------------------------------

;-----------------------------------EscCar----------------------------------------
;Rotina que escreve um caracter

;Entradas - Receve o caracter que vai imprimir no tabuleiro atraves da pilha
;Saidas   ---
;Mudancas - 
;----------------------------------------------------------------------------------
 
EscCar:         PUSH    R1
                MOV     R1, M[SP+3]
                MOV     M[IO_WRITE], R1
                POP     R1
                RETN    1


;-----------------------------------EscString--------------------------------------
;Rotina que escreve uma string na janela de texto

;Entradas - Na pilha obtemos:
;               a posicao aonde queremos comecar a escrever(R1)
;               a string que queremos escrever(R2)
;Saidas   ---
;Mudancas - Altera a janela de texto
;----------------------------------------------------------------------------------

;Rotina que escreve uma string
EscString:      PUSH    R1
                PUSH    R2
                PUSH    R3
                MOV     R2, M[SP+6]
                MOV     R1,M[SP+5]
EscStringCicle: MOV     M[IO_CONTROL],R1
                MOV     R3, M[R2]
                CMP     R3, END_TEXT

                BR.Z    EndEscString
                PUSH    R3
                CALL    EscCar
                INC     R2
                INC     R1
                
                BR      EscStringCicle
EndEscString:   POP     R3
                POP     R2
                POP     R1
                RETN    2

;-----------------------------------WriteVerticalObs----------------------------------------
;Escreve os obstaculos no ecra na vertical

;Entradas - recebe da pilha a posicao da coluna onde vai escrever
;           o caracter que vai escrever, normalmnente, X
;           recebe a altura aleatoria para saltar quando vai deixar o espaco vazio
;Saidas   ---
;Mudancas ---
;-------------------------------------------------------------------------------------------

WriteVerticalObs:   PUSH    R1
                    PUSH    R2
                    PUSH    R3
                    PUSH    R4
                    PUSH    R6
                    MOV     R1, M[SP+9]
                    MOV     R2, M[SP+8]
                    MOV     R3, 0100h
                    MOV     R4, R0
                    MOV     R6,M[SP+7]

WriteVerticalObsCicle:    MOV     M[IO_CONTROL],R1 
                    ADD     R1,R3
                    PUSH    R2
                    CALL    EscCar
                    MOV     R4,R1
                    SHR     R4,EIGHT
                    CMP     R4,R6
                    BR.NZ   WriteVerticalObsCicle
                    CMP     R6,0017h
                    BR.Z    EndWriteVerticalObs
                    MOV     R6,0017h
                    ADD     R1,M[Space_Vertical_Column]
                    BR      WriteVerticalObsCicle

EndWriteVerticalObs:POP     R6
                    POP     R4
                    POP     R3
                    POP     R2
                    POP     R1
                    RETN    3     
   

;-----------------------------------WriteBounds-----------------------------------
;Rotina que escreve os limites do 

;Entradas - caracter do limite que vai escrever
;           posicao da linha onde o vai escrever
;Saidas   ---
;Mudancas - Escreve no ecra os limites do jogo
;----------------------------------------------------------------------------------
WriteBounds:    PUSH    R1
                PUSH    R2
                PUSH    R3
                MOV     R1,M[SP+6]
                MOV     R2,R0
                MOV     R3,M[SP+5]
WriteBoundsCicle:MOV     M[IO_CONTROL],R3
                MOV     M[IO_WRITE],R1
                INC     R2
                INC     R3               
                CMP     R2,NUM_MAX_COLUMN
                BR.NZ   WriteBoundsCicle
                POP     R3
                POP     R2
                POP     R1
EndWriteBounds: RETN    2

;-----------------------------------EscCarLCD-----------------------------------------
;Escreve no LCD o caracter inserido

;Entradas - Através da pilha, obtemos o caracter que desejamos escrever no LCD
;Saidas   ---
;Mudancas - Altera o LCD
;----------------------------------------------------------------------------------
EscCarLCD:      PUSH    R1
                MOV     R1, M[SP+3]
                MOV     M[LCD_WRITE], R1
                POP     R1
                RETN    1
;-----------------------------------EscLCD-----------------------------------------
;Escreve no LCD a string inserida

;Entradas - R2 contem a string que desejamos escrever no LCD
;         - Através da pilha, obtemos a posicao para a qual queremos escrever a string
;Saidas   ---
;Mudancas - Altera o LCD
;----------------------------------------------------------------------------------
EscLCD:         PUSH    R1
                PUSH    R2
                PUSH    R3
                MOV     R1,M[SP+5];Control
CicloEscLCD:    MOV     M[LCD_CONTROL],R1
                MOV     R3,M[R2]
                CMP     R3,END_TEXT

                BR.Z    EndEscLCD
                PUSH    R3
                CALL    EscCarLCD
                INC     R2
                INC     R1
                
                BR      CicloEscLCD
EndEscLCD:      POP     R3
                POP     R2
                POP     R1
                RETN    1 


;-------------------------------------------------------------------
;-------------------------------Limpezas----------------------------
;-------------------------------------------------------------------

;-----------------------------------CleanBoard-----------------------------------
;Limpa o ecra do jogo.
;Entradas ---
;Saidas   ---
;Mudancas - O ecra do jogo fica limpo.
;----------------------------------------------------------------------------------

CleanBoard:     PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                PUSH    R5
                PUSH    R6
                MOV     R1, R0           
                MOV     R2, R0             
                MOV     R3, R0
                MOV     R4, 0100h
                MOV     R5, 004fh 
                MOV     R6, 1800h
CleanBoardCicle:CMP     R2, R5             
                BR.Z    NextLine
                ADD     R3,R1
                ADD     R3,R2
                MOV     M[IO_CONTROL],R3
                PUSH    BLANK_SPACE
                CALL    EscCar
                INC     R2
                MOV     R3,R0
                BR      CleanBoardCicle
NextLine:       CMP     R1,R6
                BR.Z    EndCleanBoard
                MOV     R2,R0
                MOV     R3,R0
                ADD     R1,R4
                BR      CleanBoardCicle
EndCleanBoard:  POP     R6
                POP     R5
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

;-----------------------------------CleanVector----------------------------------------
;Limpa a memoria do vector de obstaculos

;Entradas ---
;Saidas   ---
;Mudancas ---
;-------------------------------------------------------------------------------------------

CleanVector:    PUSH   R1
                PUSH   R2
                MOV    R1, Obstacles
                MOV    R2, R0
CleanVecCicle:  CMP    R2, 001ch
                BR.NN  EndCleanVec
                MOV    M[R1],R0
                INC    R2
                INC    R1
                BR     CleanVecCicle
EndCleanVec:    POP    R2
                POP    R1
                RET   



;--------------------------------------------------------------------------------
;------------------------------------Extras--------------------------------------
;--------------------------------------------------------------------------------


;-----------------------------------VerifyPause------------------------------------------
;Pause no jogo

;Entradas ---
;Saidas   ---
;Mudancas - Poe o jogo num loop infinito ate que seja permida o interruptor de pressao I0
;----------------------------------------------------------------------------------

;Verifica se a a Interrupcao Pause foi efectuada e fica em ciclo ate a Pause acabar
VerifyPause:  CMP     M[Paused],R0
                BR.NZ   EndVerifyPause
                 INC     M[Paused]
VerifyPauseCicle:     CMP     M[Jumped],R0
                BR.NZ   VerifyPauseCicle
                INC     M[Jumped]
EndVerifyPause: RET


;-----------------------------------UpdateRecord----------------------------------------
;Mantem um recorde do jogo até este chegar ao fim

;Entradas ---
;Saidas   ---
;Mudancas - Altera o Recorde do jogo se este for menor que o anterior
;----------------------------------------------------------------------------------

UpdateRecord:   PUSH    R1
                PUSH    R2
                PUSH    R3
                PUSH    R4
                PUSH    R5
                MOV     R1,RecordeCounter4
                MOV     R2,LCDCounter4
                MOV     R5,SIX
CheckRecordCicle:MOV     R3,M[R1]
                MOV     R4,M[R2]
                DEC     R1
                DEC     R2
                DEC     R5
                BR.Z    EndUpdateRecord
                CMP     R3,R4
                BR.NN   CheckRecordCicle
                MOV     R1,RecordeCounter4
                MOV     R2,LCDCounter4
                MOV     R5,SIX
UpdateRecordCicle:MOV     R4,M[R2]
                MOV     M[R1],R4
                DEC     R2
                DEC     R1
                DEC     R5
                BR.NZ   UpdateRecordCicle
                
EndUpdateRecord:POP     R5
                POP     R4
                POP     R3
                POP     R2
                POP     R1
                RET

;-----------------------------------GravityShift-----------------------------------
;Rotina que inverte o jogo, isto e,inverte a gravidade para esta ser para cima, e a
;velocidade do interruptor I0 para esta ser para baixo
;Existem 4 possibilidades do conjunto INTERRUPTOR_READ e da flag Invert
;Caso ambas estejam a 0 ou a 1, entao o jogo esta no modo pretendido, e obtem-se 0
;atraves do XOR entre as duas
;Caso INTERRUPTOR_READ estiver a 1 e a flag Invert a 0, entao queremos inverter o
;jogo, e saltamos para GravityShiftTrue
;Caso INTERRUPTOR_READ estiver a 0 e a flag Invert a 1, entao queremos reverter o 
;jogo para o normal

;Entradas ---
;Saidas   ---
;Mudancas - O valor da gravidade e da velocidade do interruptor I0
;----------------------------------------------------------------------------------


GravityShift:   PUSH    R1
                MOV     R1,M[Invert]
                XOR     R1,M[INTERRUPTOR_READ]
                BR.Z    EndGravityShift
                PUSH    R2
                PUSH    R3
                MOV     R1,M[Invert]
                CMP     R1,R0
                BR.Z    GravityShiftTrue
                MOV     R1,REAL_VELOCITY_INT
                MOV     M[Switch_Velocity],R1
                MOV     R1,REAL_GRAVITY
                MOV     M[Gravity],R1
                DEC     M[Invert]
                POP     R3
                POP     R2
                BR      EndGravityShift
GravityShiftTrue:MOV     R1,GRAVITYSHIFT_VELOCITY_INT
                MOV     M[Switch_Velocity],R1
                MOV     R1,GRAVITY_SHIFT
                MOV     M[Gravity],R1
                INC     M[Invert]
                POP     R3
                POP     R2
EndGravityShift:POP     R1
                RET