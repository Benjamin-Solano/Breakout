.MODEL SMALL
.STACK 100h

.DATA
    ; Configuración del juego
    ANCHO EQU 80
    ALTO EQU 25
    BLOQUES_FILAS EQU 15
    BLOQUES_COLS EQU 25
    TOTAL_BLOQUES EQU 375    ; 15 * 25
    
    ; Paleta
    paleta_x DB 37          
    paleta_y DB 23          
    paleta_ancho DB 7      
    
    ; Pelota
    pelota_x DB 40          
    pelota_y DB 18          
    pelota_dx DB 1                 
    pelota_dy DB 255        ; -1 
    
    ; Bloques (375 bloques = 15 filas x 25 columnas)
    bloques DB 375 DUP(1)    
    bloques_restantes DW 375
    
    ; Velocidad del juego
    velocidad DW 1000h
    
    ; Mensajes del menú
    titulo1 DB '  ____  ____  _____    _    _  _____  _   _ _____ $'
    titulo2 DB ' | __ )|  _ \| ____|  / \  | |/ / _ \| | | |_   _|$'
    titulo3 DB ' |  _ \| |_) |  _|   / _ \ | '' / | | | | | | | |  $'
    titulo4 DB ' | |_) |  _ <| |___ / ___ \|  <| |_| | |_| | | |  $'
    titulo5 DB ' |____/|_| \_\_____/_/   \_\_|\_\___/ \___/  |_|  $'
    
    menu_opcion1 DB '           1. JUGAR$'
    menu_opcion2 DB '           2. INSTRUCCIONES$'
    menu_opcion3 DB '           3. SALIR$'
    menu_prompt DB '           Selecciona: $'
    
    ; Instrucciones
    inst_titulo DB '           INSTRUCCIONES$'
    inst_linea1 DB '   Usa las flechas para mover la paleta$'
    inst_linea2 DB '   Destruye todos los bloques con la pelota$'
    inst_linea3 DB '   No dejes que la pelota caiga$'
    inst_linea4 DB '   Presiona ESC para salir durante el juego$'
    inst_linea5 DB '   Presiona cualquier tecla para volver...$'
    
    ; Mensajes del juego
    msg_perdiste DB '      PERDISTE! Presiona ENTER para menu$'
    msg_ganaste DB '      GANASTE! Presiona ENTER para menu$'
    
    juego_activo DB 1
    frame_counter DB 0

.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    ; Ocultar cursor
    CALL OCULTAR_CURSOR
    
MOSTRAR_MENU:
    CALL LIMPIAR_PANTALLA
    CALL DIBUJAR_MENU
    
    ; Leer opción
    MOV AH, 00h
    INT 16h
    
    CMP AL, '1'
    JE INICIAR_JUEGO
    CMP AL, '2'
    JE MOSTRAR_INSTRUCCIONES
    CMP AL, '3'
    JE SALIR_PROGRAMA
    
    JMP MOSTRAR_MENU
    
MOSTRAR_INSTRUCCIONES:
    CALL LIMPIAR_PANTALLA
    CALL DIBUJAR_INSTRUCCIONES
    
    ; Esperar tecla
    MOV AH, 00h
    INT 16h
    JMP MOSTRAR_MENU
    
INICIAR_JUEGO:
    CALL REINICIAR_JUEGO
    CALL LIMPIAR_PANTALLA
    
GAME_LOOP:
    MOV AL, juego_activo
    CMP AL, 0
    JE FIN_JUEGO
    
    ; Dibujar escena completa
    CALL DIBUJAR_MARCO
    CALL DIBUJAR_BLOQUES
    CALL DIBUJAR_PALETA
    CALL DIBUJAR_PELOTA
    
    ; Control de velocidad
    CALL DELAY_GAME
    
    ; Leer tecla sin esperar
    MOV AH, 01h
    INT 16h
    JZ NO_TECLA
    
    MOV AH, 00h
    INT 16h
    
    CMP AL, 27          ; ESC
    JE VOLVER_MENU
    CMP AH, 4Bh         ; Izquierda
    JE MOVER_IZQ
    CMP AH, 4Dh         ; Derecha
    JE MOVER_DER
    JMP NO_TECLA
    
VOLVER_MENU:
    JMP MOSTRAR_MENU
    
MOVER_IZQ:
    MOV AL, paleta_x
    CMP AL, 2
    JLE NO_TECLA
    DEC AL
    MOV paleta_x, AL
    JMP NO_TECLA
    
MOVER_DER:
    MOV AL, paleta_x
    MOV BL, paleta_ancho
    ADD AL, BL
    CMP AL, 78
    JGE NO_TECLA
    MOV AL, paleta_x
    INC AL
    MOV paleta_x, AL
    
NO_TECLA:
    ; Actualizar física cada 2 frames
    INC frame_counter
    MOV AL, frame_counter
    AND AL, 01h
    JNZ GAME_LOOP
    
    CALL MOVER_PELOTA
    JMP GAME_LOOP
    
FIN_JUEGO:
    CALL LIMPIAR_PANTALLA
    
    MOV DH, 12
    MOV DL, 15
    CALL MOVER_CURSOR
    
    MOV AX, bloques_restantes
    CMP AX, 0
    JE MOSTRAR_GANASTE_MSG
    
    LEA DX, msg_perdiste
    JMP MOSTRAR_MSG
    
MOSTRAR_GANASTE_MSG:
    LEA DX, msg_ganaste
    
MOSTRAR_MSG:
    MOV AH, 09h
    INT 21h
    
ESPERAR_ENTER:
    MOV AH, 00h
    INT 16h
    CMP AL, 13          ; ENTER
    JNE ESPERAR_ENTER
    
    JMP MOSTRAR_MENU
    
SALIR_PROGRAMA:
    CALL MOSTRAR_CURSOR
    MOV AH, 4Ch
    INT 21h
MAIN ENDP

OCULTAR_CURSOR PROC
    PUSH AX
    PUSH CX
    MOV AH, 01h
    MOV CX, 2000h
    INT 10h
    POP CX
    POP AX
    RET
OCULTAR_CURSOR ENDP

MOSTRAR_CURSOR PROC
    PUSH AX
    PUSH CX
    MOV AH, 01h
    MOV CX, 0607h
    INT 10h
    POP CX
    POP AX
    RET
MOSTRAR_CURSOR ENDP

DIBUJAR_MENU PROC
    PUSH DX
    
    ; Título
    MOV DH, 5
    MOV DL, 10
    CALL MOVER_CURSOR
    LEA DX, titulo1
    MOV AH, 09h
    INT 21h
    
    MOV DH, 6
    MOV DL, 10
    CALL MOVER_CURSOR
    LEA DX, titulo2
    MOV AH, 09h
    INT 21h
    
    MOV DH, 7
    MOV DL, 10
    CALL MOVER_CURSOR
    LEA DX, titulo3
    MOV AH, 09h
    INT 21h
    
    MOV DH, 8
    MOV DL, 10
    CALL MOVER_CURSOR
    LEA DX, titulo4
    MOV AH, 09h
    INT 21h
    
    MOV DH, 9
    MOV DL, 10
    CALL MOVER_CURSOR
    LEA DX, titulo5
    MOV AH, 09h
    INT 21h
    
    ; Opciones
    MOV DH, 13
    MOV DL, 20
    CALL MOVER_CURSOR
    LEA DX, menu_opcion1
    MOV AH, 09h
    INT 21h
    
    MOV DH, 15
    MOV DL, 20
    CALL MOVER_CURSOR
    LEA DX, menu_opcion2
    MOV AH, 09h
    INT 21h
    
    MOV DH, 17
    MOV DL, 20
    CALL MOVER_CURSOR
    LEA DX, menu_opcion3
    MOV AH, 09h
    INT 21h
    
    MOV DH, 20
    MOV DL, 20
    CALL MOVER_CURSOR
    LEA DX, menu_prompt
    MOV AH, 09h
    INT 21h
    
    POP DX
    RET
DIBUJAR_MENU ENDP

DIBUJAR_INSTRUCCIONES PROC
    PUSH DX
    
    MOV DH, 8
    MOV DL, 20
    CALL MOVER_CURSOR
    LEA DX, inst_titulo
    MOV AH, 09h
    INT 21h
    
    MOV DH, 11
    MOV DL, 15
    CALL MOVER_CURSOR
    LEA DX, inst_linea1
    MOV AH, 09h
    INT 21h
    
    MOV DH, 13
    MOV DL, 15
    CALL MOVER_CURSOR
    LEA DX, inst_linea2
    MOV AH, 09h
    INT 21h
    
    MOV DH, 15
    MOV DL, 15
    CALL MOVER_CURSOR
    LEA DX, inst_linea3
    MOV AH, 09h
    INT 21h
    
    MOV DH, 17
    MOV DL, 15
    CALL MOVER_CURSOR
    LEA DX, inst_linea4
    MOV AH, 09h
    INT 21h
    
    MOV DH, 20
    MOV DL, 15
    CALL MOVER_CURSOR
    LEA DX, inst_linea5
    MOV AH, 09h
    INT 21h
    
    POP DX
    RET
DIBUJAR_INSTRUCCIONES ENDP

REINICIAR_JUEGO PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    ; Reiniciar paleta (centrada)
    MOV paleta_x, 37
    MOV paleta_y, 23
    
    ; Reiniciar pelota
    MOV pelota_x, 40
    MOV pelota_y, 18
    MOV pelota_dx, 1
    MOV pelota_dy, 255
    
    ; Reiniciar bloques
    MOV CX, 375
    XOR BX, BX
    
REINICIAR_BLOQUES_LOOP:
    MOV bloques[BX], 1
    INC BX
    LOOP REINICIAR_BLOQUES_LOOP
    
    MOV bloques_restantes, 375
    MOV juego_activo, 1
    MOV frame_counter, 0
    
    POP CX
    POP BX
    POP AX
    RET
REINICIAR_JUEGO ENDP

LIMPIAR_PANTALLA PROC
    PUSH AX
    MOV AH, 00h
    MOV AL, 03h
    INT 10h
    POP AX
    RET
LIMPIAR_PANTALLA ENDP

MOVER_CURSOR PROC
    PUSH AX
    PUSH BX
    MOV AH, 02h
    MOV BH, 0
    INT 10h
    POP BX
    POP AX
    RET
MOVER_CURSOR ENDP

DIBUJAR_MARCO PROC
    PUSH AX
    PUSH CX
    PUSH DX
    
    ; Línea superior
    MOV DH, 0
    MOV DL, 0
    MOV CX, 80
MARCO_SUP:
    CALL MOVER_CURSOR
    MOV AH, 02h
    MOV DL, '-'
    INT 21h
    INC DL
    LOOP MARCO_SUP
    
    POP DX
    POP CX
    POP AX
    RET
DIBUJAR_MARCO ENDP

DIBUJAR_BLOQUES PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    XOR BX, BX          
    MOV DH, 2           
    
FILA_BLOQUES:
    CMP DH, 17          ; 15 filas (2 a 16)
    JGE FIN_DIBUJAR_BLOQUES
    
    MOV DL, 2           
    MOV CL, 0           
    
COLUMNA_BLOQUES:
    CMP CL, 25          ; 25 columnas
    JGE SIGUIENTE_FILA_BLOQUES
    
    MOV AL, bloques[BX]
    CMP AL, 0
    JE SALTAR_BLOQUE
    
    PUSH CX
    CALL MOVER_CURSOR
    MOV AH, 02h
    MOV DL, '#'
    INT 21h
    POP CX
    
SALTAR_BLOQUE:
    INC BX
    INC CL
    ADD DL, 3           ; Espaciado de 3 caracteres
    JMP COLUMNA_BLOQUES
    
SIGUIENTE_FILA_BLOQUES:
    INC DH
    JMP FILA_BLOQUES
    
FIN_DIBUJAR_BLOQUES:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
DIBUJAR_BLOQUES ENDP

DIBUJAR_PALETA PROC
    PUSH AX
    PUSH CX
    PUSH DX
    
    MOV DH, paleta_y
    MOV DL, paleta_x
    XOR CH, CH
    MOV CL, paleta_ancho
    
LOOP_PALETA:
    PUSH CX
    PUSH DX
    CALL MOVER_CURSOR
    MOV AH, 02h
    MOV DL, '='
    INT 21h
    POP DX
    POP CX
    
    INC DL
    LOOP LOOP_PALETA
    
    POP DX
    POP CX
    POP AX
    RET
DIBUJAR_PALETA ENDP

DIBUJAR_PELOTA PROC
    PUSH DX
    MOV DH, pelota_y
    MOV DL, pelota_x
    CALL MOVER_CURSOR
    
    MOV AH, 02h
    MOV DL, 'o'
    INT 21h
    POP DX
    RET
DIBUJAR_PELOTA ENDP

MOVER_PELOTA PROC
    PUSH AX
    PUSH BX
    PUSH CX
    
    ; Mover en X
    MOV AL, pelota_x
    MOV BL, pelota_dx
    ADD AL, BL
    MOV pelota_x, AL
    
    ; Mover en Y
    MOV AL, pelota_y
    MOV BL, pelota_dy
    ADD AL, BL
    MOV pelota_y, AL
    
    ; Colisión paredes laterales
    MOV AL, pelota_x
    CMP AL, 1
    JLE REBOTAR_X
    CMP AL, 78
    JGE REBOTAR_X
    JMP CHECK_Y
    
REBOTAR_X:
    MOV AL, pelota_dx
    NEG AL
    MOV pelota_dx, AL
    ; Ajustar posición
    MOV AL, pelota_x
    MOV BL, pelota_dx
    ADD AL, BL
    MOV pelota_x, AL
    
CHECK_Y:
    ; Colisión techo
    MOV AL, pelota_y
    CMP AL, 1
    JLE REBOTAR_Y_UP
    
    ; Colisión paleta
    MOV AL, pelota_y
    MOV BL, paleta_y
    CMP AL, BL
    JNE CHECK_BLOQUES
    
    MOV AL, pelota_x
    MOV BL, paleta_x
    CMP AL, BL
    JL CHECK_BLOQUES
    
    MOV AL, pelota_x
    MOV BL, paleta_x
    MOV CL, paleta_ancho
    ADD BL, CL
    CMP AL, BL
    JGE CHECK_BLOQUES
    
REBOTAR_Y_UP:
    MOV AL, pelota_dy
    NEG AL
    MOV pelota_dy, AL
    ; Ajustar posición
    MOV AL, pelota_y
    MOV BL, pelota_dy
    ADD AL, BL
    MOV pelota_y, AL
    
CHECK_BLOQUES:
    CALL VERIFICAR_COLISION_BLOQUES
    
    ; Verificar si perdió
    MOV AL, pelota_y
    CMP AL, 24
    JGE PERDER
    
    POP CX
    POP BX
    POP AX
    RET
    
PERDER:
    MOV juego_activo, 0
    POP CX
    POP BX
    POP AX
    RET
MOVER_PELOTA ENDP

VERIFICAR_COLISION_BLOQUES PROC
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    
    ; Verificar si está en rango de bloques
    MOV AL, pelota_y
    CMP AL, 2
    JL FIN_VERIFICAR
    CMP AL, 17
    JGE FIN_VERIFICAR
    
    MOV AL, pelota_x
    CMP AL, 2
    JL FIN_VERIFICAR
    CMP AL, 77
    JGE FIN_VERIFICAR
    
    ; Calcular fila: (y - 2)
    MOV AL, pelota_y
    SUB AL, 2
    MOV BL, 25           ; 25 columnas por fila
    MUL BL
    MOV BX, AX           ; BX = índice base de la fila
    
    ; Calcular columna: (x - 2) / 3
    MOV AL, pelota_x
    SUB AL, 2
    MOV CL, 3
    XOR AH, AH
    DIV CL
    
    ; Verificar que no exceda columnas
    CMP AL, 25
    JAE FIN_VERIFICAR
    
    ; BX = fila * 25 + columna
    XOR AH, AH
    ADD BX, AX
    
    ; Verificar límite del array
    CMP BX, 375
    JAE FIN_VERIFICAR
    
    ; Verificar si el bloque existe
    MOV AL, bloques[BX]
    CMP AL, 0
    JE FIN_VERIFICAR
    
    ; Destruir bloque
    MOV bloques[BX], 0
    DEC bloques_restantes
    
    ; Rebotar verticalmente
    MOV AL, pelota_dy
    NEG AL
    MOV pelota_dy, AL
    
    ; Verificar victoria
    MOV AX, bloques_restantes
    CMP AX, 0
    JE GANAR
    
FIN_VERIFICAR:
    POP DX
    POP CX
    POP BX
    POP AX
    RET
    
GANAR:
    MOV juego_activo, 0
    POP DX
    POP CX
    POP BX
    POP AX
    RET
VERIFICAR_COLISION_BLOQUES ENDP

DELAY_GAME PROC
    PUSH CX
    PUSH DX
    
    MOV CX, 0001h
    
DELAY_OUTER:
    MOV DX, 5000h
DELAY_INNER:
    DEC DX
    JNZ DELAY_INNER
    LOOP DELAY_OUTER
    
    POP DX
    POP CX
    RET
DELAY_GAME ENDP

END MAIN