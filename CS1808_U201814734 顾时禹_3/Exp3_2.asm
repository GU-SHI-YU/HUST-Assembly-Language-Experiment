		;编写者：顾时禹
		;函数名：FUNC1, FUNC2, FUNC3, FUNC4, FUNC8
		
		NAME MAIN
.386
.MODEL FLAT, C

  printf          PROTO  :ptr sbyte, :VARARG
  scanf         PROTO  :ptr sbyte, :VARARG
 includelib  libcmt.lib
 includelib  legacy_stdio_definitions.lib
;DATA	SEGMENT USE16 PARA PUBLIC 'DATA'
CRLF	MACRO						;回车
		invoke printf, offset FMT, addr CRLFT
		ENDM
PRINT	MACRO A						;打印文字
		invoke printf, offset FMT, addr A
		ENDM
READ	MACRO A						;读取输入
		invoke scanf, offset FMT, addr A
		ENDM
SHOWVALUE MACRO A, B
		PRINT A
		MOV AX, B[EBX]
		LEA ESI, VALUE
		CALL F2TO10
		MOV BYTE PTR [ESI], 0DH
		MOV BYTE PTR [ESI+1], 0AH
		MOV BYTE PTR [ESI+2], 0
		PRINT VALUE
		ENDM
CHANGEVALUE MACRO A, B
		LOCAL LL
LL:		PRINT A
		MOV AX, B[EBX]
		LEA ESI, VALUE
		CALL F2TO10
		MOV BYTE PTR [ESI], 0
		PRINT VALUE
		PRINT SEPARATOR
		CALL GETVALUE
		CMP DI, 1
		JE LL
		MOV B[EBX], DX
		ENDM

.DATA
MENUT	DB 'Please Enter a Number(1~9):', 0

INNAMET	DB 'User Name:', 0
WRONGNAMET DB 'Invalid User Name', 0
INNAME	DB 10 DUP(0)
INPWDT	DB 'Password:', 0
WRONGPWDT DB 'Invalid Password', 0
INPWD	DB 10 DUP(0)
LOGINST DB 'Login in', 0
INGOODT DB 'Good Name:', 0
WRONGGOODT DB 'Invalid Good Name', 0
INGOOD	DB 10 DUP(0)
CHANGEGOODT DB 'Good Selected', 0
NOGOODT	DB 'No Goods', 0
SELLGOODT DB 'Good Sold', 0
NOTSELECTEDT DB 'No Goods Selected', 0
UPDATEPRIOT DB 'Priority Updated', 0
NOTBOSST DB 'Authrity Denied', 0
BPRICET	DB 'Buying Price:', 0
SPRICET	DB 'Selling Price:', 0
BAMOUNTT DB 'Buying Amount:', 0
SAMOUNTT DB 'Selling Amount:', 0
VALUE	DB 8 DUP(0)
SEPARATOR DB '->',0
BNAME  	DB 'GUSHIYU', 0			;老板姓名
BPASS  	DB '153426', 0				;密码
AUTH   	DB 0	              		;当前登录状态，0表示顾客状态
GOOD   	DD 0          				;当前浏览商品地址
N		EQU	30
SNAME	DB 'SHOP', 0               	;网店名称，用0结束
GA1   	DB 'PEN', 7 DUP(0), 10  	;商品名称及折扣
		DW 35, 56, 70, 25, ? 	 	;进货价，销售价，进货总数，已售数量，推荐度
GA2   	DB 'BOOK', 6 DUP(0), 9  	;商品名称及折扣
		DW  12, 30, 25, 5, ?      	;推荐度还未计算
GAN   	DB N-2 DUP( 'TempValue' , 0, 8, 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)
									;其他商品默认值
CRLFT	DB 0DH, 0AH, 0
A		DB 'A', 0						;调试用
B		DB 'B', 0
FMT		DB '%s', 0
FMTC	DB '%c', 0
CHAR	DB 0

.CODE
;START:	MOV AX, DATA				;程序开始
		;MOV DS, AX

;MENU:	PRINT MENUT				;主菜单
		;MOV AH, 01H
		;INT 21H
		;CRLF
		;CMP AL, '1'
		;JE CF1
		;CMP AL, '2'
		;JE CF2
		;CMP AL, '3'
		;JE CF3
		;CMP AL, '4'
		;JE CF4
		;CMP AL, '6'
		;JE CF6
		;CMP AL, '8'
		;JE CF8
		;CMP AL, '9'
		;JE OVER
		;JMP MENU
;CF1: 	CALL FUNC1
		;JMP MENU
;CF2:	CALL FUNC2
		;JMP MENU
;CF3:	CALL FUNC3
		;JMP MENU
;CF4:	CALL FUNC4
		;JMP MENU
;CF6: 	CALL FUNC6
		;JMP MENU
;CF8:	CALL FUNC8
		;JMP MENU
		
FUNC1	PROC						;功能1
		;LOCAL CHECK_USER, CHECK_PWD, WRONG_NAME, WRONG_PWD, LOGIN_S
		PRINT INNAMET				
		READ INNAME
		CRLF
		LEA EDI, INNAME
		LEA ESI, BNAME
CHECK_USER:							;逐字节比较用户名
		MOV AL, [EDI]
		CMP AL, [ESI]
		JNE WRONG_NAME
		INC EDI
		INC ESI
		CMP AL, 0
		JNZ CHECK_USER
		PRINT INPWDT
		READ INPWD
		CRLF
		LEA EDI, INPWD
		LEA ESI, BPASS
CHECK_PWD:							;逐字节比较密码
		MOV AL, [EDI]
		CMP AL, [ESI]
		JNE WRONG_PWD
		INC EDI
		INC ESI
		CMP AL, 0
		JNZ CHECK_PWD
		JMP LOGIN_S
WRONG_NAME:
		PRINT WRONGNAMET
		CRLF
		RET
WRONG_PWD:
		PRINT WRONGPWDT
		CRLF
		RET
LOGIN_S:							;登陆成功
		MOV AUTH, 1
		PRINT LOGINST
		CRLF
		RET
FUNC1	ENDP
		
FUNC2	PROC						;功能2
		;LOCAL CHECK_GOOD, CHECK_NAME, WRONG_GOOD, CHANGE_GOOD
		PRINT INGOODT				
		READ INGOOD
		CRLF
		MOV EAX, -1
CHECK_GOOD:							;选择下一个比较商品
		INC EAX
		CMP EAX, 30
		JE WRONG_GOOD
		MOV ECX, EAX
		IMUL ECX, 21
		ADD ECX, OFFSET GA1
		MOV ESI, ECX
		LEA EDI, INGOOD
CHECK_NAME:							;比较商品名
		MOV BL, [EDI]
		CMP BL, [ESI]
		JNE CHECK_GOOD
		INC EDI
		INC ESI
		CMP BL, 0
		JNZ CHECK_NAME
		JMP CHANGE_GOOD
WRONG_GOOD:
		PRINT WRONGGOODT
		CRLF
		RET
CHANGE_GOOD:						;更改选中商品
		MOV EBX, EAX
		IMUL EBX, 21
		ADD EBX, OFFSET GA1
		MOV GOOD, EBX
		PRINT CHANGEGOODT
		CRLF
		SHOWVALUE BPRICET, 11
		SHOWVALUE SPRICET, 13
		SHOWVALUE BAMOUNTT, 15
		SHOWVALUE SAMOUNTT, 17
		RET
FUNC2	ENDP
		
FUNC3	PROC						;功能3
		MOV EBX, GOOD				
		CMP EBX, 0
		JE NO_SELECTED
		MOV AX, 15[EBX]
		MOV DX, 17[EBX]
		CMP AX, DX
		JNE SELL_GOOD
		PRINT NOGOODT
		CRLF
		RET
SELL_GOOD:
		INC DX
		MOV 17[EBX], DX
		PRINT SELLGOODT
		CRLF
		CALL FUNC4
		RET
NO_SELECTED:
		PRINT NOTSELECTEDT
		CRLF
		RET
FUNC3	ENDP
		
		
FUNC4	PROC						;功能4
		;LOCAL COMPUTE_PRIO, COMPUTE_OVER
		PUSH EBP
		MOV EBP, -1					
		PRINT UPDATEPRIOT
		CRLF
COMPUTE_PRIO:
		INC EBP
		CMP EBP, 30
		JE COMPUTE_OVER
		LEA ESI, GA1
		MOV ECX, EBP
		IMUL ECX, 21
		ADD ESI, ECX
		MOV EBX, ESI
		ADD EBX, 13
		MOV AX, [EBX-2]
		MOV BX, [EBX]
		MOVSX EAX, AX
		MOVSX EBX, BX
		MOV EDI, 128
		IMUL EDI
		IDIV EBX
		MOV ECX, EAX
		MOV EBX, ESI
		ADD EBX, 15
		MOV AX, [EBX+2]
		MOV BX, [EBX]
		MOVSX EAX, AX
		MOVSX EBX, BX
		IMUL EDI
		MOV EDI, 2
		IDIV EDI
		MOV EDX, 0
		IDIV EBX
		ADD EAX, ECX
		MOV EBX, ESI
		ADD EBX, 19
		MOV [EBX], AX
		JMP COMPUTE_PRIO
COMPUTE_OVER:
		POP EBP
		RET
FUNC4	ENDP
		

		
FUNC8	PROC						;功能8
		;LOCAL GET_LETTER, IS_NUM, SHOW_OVER
		PUSH BP
		MOV BP, 4					
		MOV BX, CS
GET_LETTER:
		MOV CL, 4;
		ROL BX, CL
		MOV DL, BL
		AND DL, 0FH
		CMP DL, 0AH
		JB IS_NUM
		ADD DL, 07H
IS_NUM:	ADD DL, 30H
		invoke printf, offset FMTC, DL
		DEC BP
		JZ SHOW_OVER
		JMP GET_LETTER
SHOW_OVER:
		CRLF
		POP BP
		RET
FUNC8	ENDP

F2TO10	PROC
		PUSH BX
		PUSH CX
		PUSH DX
		MOV BX, 10
		XOR CX, CX
LOP1:	XOR DX, DX
		DIV BX
		PUSH DX
		INC CX
		OR EAX, EAX
		JNZ LOP1
LOP2:	POP AX
		CMP AL, 10
		JB L1
		ADD AL, 7
L1:		ADD AL, 30H
		MOV [ESI], AL
		INC ESI
		DEC CX
		JNZ LOP2
		POP DX
		POP CX
		POP BX
		RET
F2TO10	ENDP

FUNC6 	PROC
		CMP AUTH, 0
		JE NOT_BOSS
		CMP GOOD, 0
		JE	NOT_SELECTED
		MOV EBX, GOOD
		CHANGEVALUE BPRICET, 11
		CHANGEVALUE SPRICET, 13
		CHANGEVALUE BAMOUNTT, 15
		CHANGEVALUE SAMOUNTT, 17
		RET
NOT_SELECTED:
		PRINT NOTSELECTEDT
		CRLF
		RET
NOT_BOSS:
		PRINT NOTBOSST
		CRLF
		RET
FUNC6	ENDP

GETVALUE PROC
		PUSH AX
		PUSH CX
		XOR DI, DI
		XOR CX, CX
		XOR DL, DL
		PUSH DX
LOOP1:	invoke scanf, offset FMTC, ADDR CHAR
		POP DX
		MOV AL, CHAR
		CMP AL, 0DH
		JE RETURN
		CMP AL, 0AH
		JE RETURN
		CMP AL, '0'
		JB ERR
		CMP AL, '9'
		JA ERR
		SUB AL, '0'
		MOV CL, AL
		MOV AX, DX
		MOV DX, 10
		MUL DX
		ADD AX, CX
		MOV AH, 0
		MOV DX, AX
		PUSH DX
		JMP LOOP1
ERR:	CRLF
		MOV DI, 1
		POP CX
		POP AX
		RET
RETURN: POP CX
		POP AX
		RET
GETVALUE ENDP
		END
		;END START