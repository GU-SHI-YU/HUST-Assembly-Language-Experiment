		;编写者：顾时禹
		;函数名：FUNC1, FUNC2, FUNC3, FUNC4, FUNC8
		
		NAME MAIN
		export FUNC1
		EXTERN F2TO10:NEAR, FUNC6:NEAR
		PUBLIC NOTSELECTEDT, NOTBOSST, BPRICET, SPRICET, BAMOUNTT, SAMOUNTT, VALUE, SEPARATOR, AUTH, GOOD, CRLFT, FUNC1
CRLF	MACRO						;回车
		LEA DX, CRLFT
		MOV AH, 09H
		INT 21H
		ENDM
PRINT	MACRO A						;打印文字
		LEA DX, A
		MOV AH, 09H
		INT 21H
		ENDM
READ	MACRO A						;读取输入
		LEA DX, A
		MOV AH, 0AH
		INT 21H
		ENDM
SHOWVALUE MACRO A, B
		PRINT A
		MOV AX, B[BX]
		LEA SI, VALUE
		CALL F2TO10
		MOV BYTE PTR [SI], 0DH
		MOV BYTE PTR [SI+1], 0AH
		MOV BYTE PTR [SI+2], '$'
		PRINT VALUE
		ENDM

.386
;DATA	SEGMENT USE16 PARA PUBLIC 'DATA'
.data
MENUT	DB 'Please Enter a Number(1~9):$'

INNAMET	DB 'User Name:$'
WRONGNAMET DB 'Invalid User Name$'
INNAME	DB 10
		DB ?
		DB 10 DUP(0)
INPWDT	DB 'Password:$'
WRONGPWDT DB 'Invalid Password$'
INPWD	DB 10
		DB ?
		DB 10 DUP(0)
LOGINST DB 'Login in$'
INGOODT DB 'Good Name:$'
WRONGGOODT DB 'Invalid Good Name$'
INGOOD	DB 10
		DB ?
		DB 10 DUP(0)
CHANGEGOODT DB 'Good Selected$'
NOGOODT	DB 'No Goods$'
SELLGOODT DB 'Good Sold$'
NOTSELECTEDT DB 'No Goods Selected$'
UPDATEPRIOT DB 'Priority Updated$'
NOTBOSST DB 'Authrity Denied$'
BPRICET	DB 'Buying Price:$'
SPRICET	DB 'Selling Price:$'
BAMOUNTT DB 'Buying Amount:$'
SAMOUNTT DB 'Selling Amount:$'
VALUE	DB 8 DUP(0)
SEPARATOR DB '->$'
BNAME  	DB 'GU SHIYU', 0			;老板姓名
BPASS  	DB '153426', 0				;密码
AUTH   	DB 0	              		;当前登录状态，0表示顾客状态
GOOD   	DW 0          				;当前浏览商品地址
N		EQU	30
SNAME	DB 'SHOP', 0               	;网店名称，用0结束
GA1   	DB 'PEN', 7 DUP(0), 10  	;商品名称及折扣
		DW 35, 56, 70, 25, ? 	 	;进货价，销售价，进货总数，已售数量，推荐度
GA2   	DB 'BOOK', 6 DUP(0), 9  	;商品名称及折扣
		DW  12, 30, 25, 5, ?      	;推荐度还未计算
GAN   	DB N-2 DUP( 'TempValue' , 0, 8, 15, 0, 20, 0, 30, 0, 2, 0, ?, ?)
									;其他商品默认值
CRLFT	DB 0DH, 0AH, '$'
A		DB 'A$'						;调试用
B		DB 'B$'

.code
;CODE 	SEGMENT USE16 PARA PUBLIC 'CODE'
		;ASSUME CS:CODE, DS:DATA, SS:STACK		
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
		LEA DI, INNAME+1
		MOV CL, [DI]
		CMP CL, 8
		JNE WRONG_NAME
		LEA DI, INNAME+2
		LEA SI, BNAME
CHECK_USER:							;逐字节比较用户名
		MOV AL, [DI]
		CMP AL, [SI]
		JNE WRONG_NAME
		INC DI
		INC SI
		DEC CL
		JNZ CHECK_USER
		PRINT INPWDT
		READ INPWD
		CRLF
		LEA DI, INPWD+1
		MOV CL, [DI]
		CMP CL, 6
		JNE WRONG_PWD
		LEA DI, INPWD+2
		LEA SI, BPASS
CHECK_PWD:							;逐字节比较密码
		MOV AL, [DI]
		CMP AL, [SI]
		JNE WRONG_PWD
		INC DI
		INC SI
		DEC CL
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
		MOV AX, -1
CHECK_GOOD:							;选择下一个比较商品
		INC AX
		CMP AX, 30
		JE WRONG_GOOD
		MOV CX, AX
		IMUL CX, 21
		ADD CX, OFFSET GA1
		MOV SI, CX
		LEA DI, INGOOD+1
		MOV CL, [DI]
		LEA DI, INGOOD+2
CHECK_NAME:							;比较商品名
		MOV BL, [DI]
		CMP BL, [SI]
		JNE CHECK_GOOD
		INC DI
		INC SI
		DEC CL
		JNZ CHECK_NAME
		MOV BL, [SI]
		CMP BL, 0
		JE CHANGE_GOOD
		JMP CHECK_GOOD
WRONG_GOOD:
		PRINT WRONGGOODT
		CRLF
		RET
CHANGE_GOOD:						;更改选中商品
		MOV BX, AX
		IMUL BX, 21
		ADD BX, OFFSET GA1
		MOV GOOD, BX
		PRINT CHANGEGOODT
		CRLF
		SHOWVALUE BPRICET, 11
		SHOWVALUE SPRICET, 13
		SHOWVALUE BAMOUNTT, 15
		SHOWVALUE SAMOUNTT, 17
		RET
FUNC2	ENDP
		
FUNC3	PROC						;功能3
		MOV BX, GOOD				
		CMP BX, 0
		JE NO_SELECTED
		MOV AX, 15[BX]
		MOV DX, 17[BX]
		CMP AX, DX
		JNE SELL_GOOD
		PRINT NOGOODT
		CRLF
		JMP MENU
SELL_GOOD:
		INC DX
		MOV 17[BX], DX
		PRINT SELLGOODT
		CRLF
		JMP CF4
NO_SELECTED:
		PRINT NOTSELECTEDT
		CRLF
		RET
FUNC3	ENDP
		
		
FUNC4	PROC						;功能4
		;LOCAL COMPUTE_PRIO, COMPUTE_OVER
		MOV BP, -1					
		PRINT UPDATEPRIOT
		CRLF
COMPUTE_PRIO:
		INC BP
		CMP BP, 30
		JE COMPUTE_OVER
		LEA SI, GA1
		MOV CX, BP
		IMUL CX, 21
		ADD SI, CX
		MOV BX, SI
		ADD BX, 13
		MOV AX, [BX-2]
		MOV BX, [BX]
		MOVSX EAX, AX
		MOVSX EBX, BX
		MOV EDI, 128
		IMUL EDI
		IDIV EBX
		MOV ECX, EAX
		MOV BX, SI
		ADD BX, 15
		MOV AX, [BX+2]
		MOV BX, [BX]
		MOVSX EAX, AX
		MOVSX EBX, BX
		IMUL EDI
		MOV EDI, 2
		IDIV EDI
		MOV EDX, 0
		IDIV EBX
		ADD EAX, ECX
		MOV BX, SI
		ADD BX, 19
		MOV [BX], AX
		JMP COMPUTE_PRIO
COMPUTE_OVER:
		RET
FUNC4	ENDP
		

		
FUNC8	PROC						;功能8
		;LOCAL GET_LETTER, IS_NUM, SHOW_OVER
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
		MOV AH, 02H
		INT 21H
		DEC BP
		JZ SHOW_OVER
		JMP GET_LETTER
SHOW_OVER:
		CRLF
		RET
FUNC8	ENDP
		end
		;END START