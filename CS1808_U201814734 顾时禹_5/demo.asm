.386
.model   flat,stdcall
option   casemap:none
WinMain  proto :DWORD,:DWORD,:DWORD,:DWORD
WndProc  proto :DWORD,:DWORD,:DWORD,:DWORD
Display  proto :DWORD
sprintf	proto C:DWORD,:DWORD,:vararg
FUNC4	proto
sort	proto

include      menuID.INC

include      D:\Masm32\INCLUDE\windows.inc
include      D:\Masm32\INCLUDE\user32.inc
include      D:\Masm32\INCLUDE\kernel32.inc
include      D:\Masm32\INCLUDE\gdi32.inc
include      D:\Masm32\INCLUDE\shell32.inc

includelib   user32.lib
includelib   kernel32.lib
includelib   gdi32.lib
includelib   shell32.lib

good		struct
		gname db 10 dup(0)
		off db 0
		inprice dw 0
		outprice dw 0
		inamount dw 0
		outamount dw 0
		prior dw 0
good		ends

len		struct
	os db 10 dup(0)
	ips db 10 dup(0)
	ops db 10 dup(0)
	ias db 10 dup(0)
	oas db 10 dup(0)
	ps db 10 dup(0)
	nl db 0
	ol db 0
	ipl db 0
	opl db 0
	ial db 0
	oal db 0
	pl db 0
len		ends

.data
ClassName    db       'TryWinClass',0
AppName      db       'Our First Window',0
MenuName     db       'MyMenu',0
DlgName	     db       'MyDialog',0
AboutMsg     db       'I am CS1808 GuShiyu',0
RecoMsg		 db		  'ComputeOver', 0
hInstance    dd       0
CommandLine  dd       0
msg_name     db       'name',0
msg_off db 'Off', 0
msg_inprice  db       'BuyingPrice',0
msg_outprice     db       'SellingPrice',0
msg_inamount  db       'BuyingAmount',0
msg_outamount  db       'SellingAmount',0
msg_prior    db       'Priority',0
menuItem     db       0  ;当前菜单状态, 1=处于list, 0=Clear
GA		good <'PEN', 10, 35, 56, 70, 25, ?>
		good <'BOOK', 9, 12, 30, 25, 5, ?>
		good <'a', 10, 20, 30, 40, 50, ?>
		good <'b', 11, 22, 33, 44, 55, ?>
		good <'c', 111, 222, 333, 444, 555, ?>
N equ 5
GAL len <'10','35','56','70','25','102',3,2,2,2,2,2,3>
	len <'9','12','30','25','5','63',4,1,2,2,2,1,2>
	len <'10','20','30','40','50','165',1,2,2,2,2,2,3>
	len <'11','22','33','44','55','165',1,2,2,2,2,2,3>
	len <'111','222','333','444','555','165',1,3,3,3,3,3,3>

.code
Start:	     invoke GetModuleHandle,NULL
	     mov    hInstance,eax
	     invoke GetCommandLine
	     mov    CommandLine,eax
	     invoke WinMain,hInstance,NULL,CommandLine,SW_SHOWDEFAULT
	     invoke ExitProcess,eax
	     ;;
WinMain      proc   hInst:DWORD,hPrevInst:DWORD,CmdLine:DWORD,CmdShow:DWORD
	     LOCAL  wc:WNDCLASSEX
	     LOCAL  msg:MSG
	     LOCAL  hWnd:HWND
             invoke RtlZeroMemory,addr wc,sizeof wc
	     mov    wc.cbSize,SIZEOF WNDCLASSEX
	     mov    wc.style, CS_HREDRAW or CS_VREDRAW
	     mov    wc.lpfnWndProc, offset WndProc
	     mov    wc.cbClsExtra,NULL
	     mov    wc.cbWndExtra,NULL
	     push   hInst
	     pop    wc.hInstance
	     mov    wc.hbrBackground,COLOR_WINDOW+1
	     mov    wc.lpszMenuName, offset MenuName
	     mov    wc.lpszClassName,offset ClassName
	     invoke LoadIcon,NULL,IDI_APPLICATION
	     mov    wc.hIcon,eax
	     mov    wc.hIconSm,0
	     invoke LoadCursor,NULL,IDC_ARROW
	     mov    wc.hCursor,eax
	     invoke RegisterClassEx, addr wc
	     INVOKE CreateWindowEx,NULL,addr ClassName,addr AppName,\
                    WS_OVERLAPPEDWINDOW,CW_USEDEFAULT,\
                    CW_USEDEFAULT,CW_USEDEFAULT,CW_USEDEFAULT,NULL,NULL,\
                    hInst,NULL
	     mov    hWnd,eax
	     INVOKE ShowWindow,hWnd,SW_SHOWNORMAL
	     INVOKE UpdateWindow,hWnd
	     ;;
MsgLoop:     INVOKE GetMessage,addr msg,NULL,0,0
             cmp    EAX,0
             je     ExitLoop
             INVOKE TranslateMessage,addr msg
             INVOKE DispatchMessage,addr msg
	     jmp    MsgLoop 
ExitLoop:    mov    eax,msg.wParam
	     ret
WinMain      endp

WndProc      proc   hWnd:DWORD,uMsg:DWORD,wParam:DWORD,lParam:DWORD
	     LOCAL  hdc:HDC
	     LOCAL  ps:PAINTSTRUCT
     .IF     uMsg == WM_DESTROY
	     invoke PostQuitMessage,NULL
     .ELSEIF uMsg == WM_KEYDOWN
	    .IF     wParam == VK_F1
             ;;your code
	    .ENDIF
     .ELSEIF uMsg == WM_COMMAND
	    .IF     wParam == IDM_FILE_EXIT
		    invoke SendMessage,hWnd,WM_CLOSE,0,0
	    .ELSEIF wParam == IDM_ACTION_RECO
			invoke FUNC4
			invoke MessageBox,hWnd,addr RecoMsg,addr AppName,0
	    .ELSEIF wParam == IDM_ACTION_LIST
		    mov menuItem, 1
		    invoke InvalidateRect,hWnd,0,1  ;擦除整个客户区
		    invoke UpdateWindow, hWnd
	    .ELSEIF wParam == IDM_HELP_ABOUT
		    invoke MessageBox,hWnd,addr AboutMsg,addr AppName,0
	    .ENDIF
     .ELSEIF uMsg == WM_PAINT
             invoke BeginPaint,hWnd, addr ps
             mov hdc,eax
	     .IF menuItem == 1
		 invoke Display,hdc
	     .ENDIF
	     invoke EndPaint,hWnd,addr ps
     .ELSE
             invoke DefWindowProc,hWnd,uMsg,wParam,lParam
             ret
     .ENDIF
  	     xor    eax,eax
	     ret
WndProc      endp

Display      proc   hdc:HDC
             XX     equ  10
             YY     equ  10
	     XX_GAP equ  100
	     YY_GAP equ  30
			invoke sort
             invoke TextOut,hdc,XX+0*XX_GAP,YY+0*YY_GAP,offset msg_name,4
             invoke TextOut,hdc,XX+1*XX_GAP,YY+0*YY_GAP,offset msg_off,3
             invoke TextOut,hdc,XX+2*XX_GAP,YY+0*YY_GAP,offset msg_inprice,11
             invoke TextOut,hdc,XX+3*XX_GAP,YY+0*YY_GAP,offset msg_outprice,12
             invoke TextOut,hdc,XX+4*XX_GAP,YY+0*YY_GAP,offset msg_inamount,12
             invoke TextOut,hdc,XX+5*XX_GAP,YY+0*YY_GAP,offset msg_outamount,13
			 invoke TextOut,hdc,XX+6*XX_GAP,YY+0*YY_GAP,offset msg_prior,8
			 ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+1*YY_GAP,offset GA[0*21].gname, GAL[0*67].nl
			 invoke TextOut,hdc,XX+1*XX_GAP,YY+1*YY_GAP,offset GAL[0*67].os, GAL[0*67].ol
             invoke TextOut,hdc,XX+2*XX_GAP,YY+1*YY_GAP,offset GAL[0*67].ips, GAL[0*67].ipl
             invoke TextOut,hdc,XX+3*XX_GAP,YY+1*YY_GAP,offset GAL[0*67].ops, GAL[0*67].opl
             invoke TextOut,hdc,XX+4*XX_GAP,YY+1*YY_GAP,offset GAL[0*67].ias, GAL[0*67].ial
             invoke TextOut,hdc,XX+5*XX_GAP,YY+1*YY_GAP,offset GAL[0*67].oas, GAL[0*67].oal
			 invoke TextOut,hdc,XX+6*XX_GAP,YY+1*YY_GAP,offset GAL[0*67].ps, GAL[0*67].pl
			 ;;
			 invoke TextOut,hdc,XX+0*XX_GAP,YY+2*YY_GAP,offset GA[1*21].gname, GAL[1*67].nl
			 invoke TextOut,hdc,XX+1*XX_GAP,YY+2*YY_GAP,offset GAL[1*67].os, GAL[1*67].ol
             invoke TextOut,hdc,XX+2*XX_GAP,YY+2*YY_GAP,offset GAL[1*67].ips, GAL[1*67].ipl
             invoke TextOut,hdc,XX+3*XX_GAP,YY+2*YY_GAP,offset GAL[1*67].ops, GAL[1*67].opl
             invoke TextOut,hdc,XX+4*XX_GAP,YY+2*YY_GAP,offset GAL[1*67].ias, GAL[1*67].ial
             invoke TextOut,hdc,XX+5*XX_GAP,YY+2*YY_GAP,offset GAL[1*67].oas, GAL[1*67].oal
			 invoke TextOut,hdc,XX+6*XX_GAP,YY+2*YY_GAP,offset GAL[1*67].ps, GAL[1*67].pl
			 ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+3*YY_GAP,offset GA[2*21].gname, GAL[2*67].nl
			 invoke TextOut,hdc,XX+1*XX_GAP,YY+3*YY_GAP,offset GAL[2*67].os, GAL[2*67].ol
             invoke TextOut,hdc,XX+2*XX_GAP,YY+3*YY_GAP,offset GAL[2*67].ips, GAL[2*67].ipl
             invoke TextOut,hdc,XX+3*XX_GAP,YY+3*YY_GAP,offset GAL[2*67].ops, GAL[2*67].opl
             invoke TextOut,hdc,XX+4*XX_GAP,YY+3*YY_GAP,offset GAL[2*67].ias, GAL[2*67].ial
             invoke TextOut,hdc,XX+5*XX_GAP,YY+3*YY_GAP,offset GAL[2*67].oas, GAL[2*67].oal
			 invoke TextOut,hdc,XX+6*XX_GAP,YY+3*YY_GAP,offset GAL[2*67].ps, GAL[2*67].pl
			 ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+4*YY_GAP,offset GA[3*21].gname, GAL[3*67].nl
			 invoke TextOut,hdc,XX+1*XX_GAP,YY+4*YY_GAP,offset GAL[3*67].os, GAL[3*67].ol
             invoke TextOut,hdc,XX+2*XX_GAP,YY+4*YY_GAP,offset GAL[3*67].ips, GAL[3*67].ipl
             invoke TextOut,hdc,XX+3*XX_GAP,YY+4*YY_GAP,offset GAL[3*67].ops, GAL[3*67].opl
             invoke TextOut,hdc,XX+4*XX_GAP,YY+4*YY_GAP,offset GAL[3*67].ias, GAL[3*67].ial
             invoke TextOut,hdc,XX+5*XX_GAP,YY+4*YY_GAP,offset GAL[3*67].oas, GAL[3*67].oal
			 invoke TextOut,hdc,XX+6*XX_GAP,YY+4*YY_GAP,offset GAL[3*67].ps, GAL[3*67].pl
			 ;;
             invoke TextOut,hdc,XX+0*XX_GAP,YY+5*YY_GAP,offset GA[4*21].gname, GAL[4*67].nl
			 invoke TextOut,hdc,XX+1*XX_GAP,YY+5*YY_GAP,offset GAL[4*67].os, GAL[4*67].ol
             invoke TextOut,hdc,XX+2*XX_GAP,YY+5*YY_GAP,offset GAL[4*67].ips, GAL[4*67].ipl
             invoke TextOut,hdc,XX+3*XX_GAP,YY+5*YY_GAP,offset GAL[4*67].ops, GAL[4*67].opl
             invoke TextOut,hdc,XX+4*XX_GAP,YY+5*YY_GAP,offset GAL[4*67].ias, GAL[4*67].ial
             invoke TextOut,hdc,XX+5*XX_GAP,YY+5*YY_GAP,offset GAL[4*67].oas, GAL[4*67].oal
			 invoke TextOut,hdc,XX+6*XX_GAP,YY+5*YY_GAP,offset GAL[4*67].ps, GAL[4*67].pl
             ret
Display      endp

FUNC4	PROC	;功能4
		PUSH BP
		MOV BP, -1
COMPUTE_PRIO:
		INC BP
		CMP BP, N
		JE COMPUTE_OVER
		LEA ESI, GA
		MOVZX ECX, BP
		IMUL ECX, 21
		ADD ESI, ECX
		MOV EBX, ESI
		ADD EBX, 13
		MOV AX, [EBX-2]
		MOV BX, [EBX]
		MOVZX EAX, AX
		MOVZX EBX, BX
		MOV EDI, 128
		MUL EDI
		DIV EBX
		MOV ECX, EAX
		MOV EBX, ESI
		ADD EBX, 15
		MOV AX, [EBX+2]
		MOV BX, [EBX]
		MOVZX EAX, AX
		MOVZX EBX, BX
		IMUL EDI
		MOV EDI, 2
		DIV EDI
		MOV EDX, 0
		DIV EBX
		ADD EAX, ECX
		MOV EBX, ESI
		ADD EBX, 19
		MOV [EBX], AX
		JMP COMPUTE_PRIO
COMPUTE_OVER:
		POP BP
		RET
FUNC4	ENDP

sort	proc
		mov edx, 0
l1:		
		mov ecx, 0
		add ecx, edx
		mov ebx, 0
		mov edi, 0
l2:		
		mov esi, ecx
		imul esi, 21
		add esi, 19
		cmp bx, word ptr GA[esi]
		jnb nm
		mov bx, word ptr GA[esi]
		sub esi, 19
		mov edi, ecx
nm:		
		inc cx
		cmp cx, 5
		jne l2
		push ecx
		mov ecx,0
		mov esi, edx
		imul esi, 21
		mov eax, edi
		imul eax, 21
l3:		
		mov bh, byte ptr GA[eax+ecx]
		mov bl, byte ptr GA[esi+ecx]
		mov byte ptr GA[esi+ecx], bh
		mov byte ptr GA[eax+ecx], bl
		inc ecx
		cmp ecx, 21
		jne l3
		mov ecx, 0
		mov esi, edx
		imul esi, 67
		mov eax, edi
		imul eax, 67
l4:		
		
		mov bh, byte ptr GAL[eax+ecx]
		mov bl, byte ptr GAL[esi+ecx]
		mov byte ptr GAL[esi+ecx], bh
		mov byte ptr GAL[eax+ecx], bl
		inc ecx
		cmp ecx, 67
		jne l4
		pop ecx
		inc edx
		cmp edx, 4
		jne l1
		ret
sort	endp
             end  Start
