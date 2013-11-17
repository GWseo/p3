;;=============================================================================
;; 
;;
;;=============================================================================
.CODE


; void _break();
;------------------------------------------------------------------------------
_break PROC
	int 3
	ret
_break ENDP

;;=============================================================================
;; MSR stuff
;;=============================================================================

; out parameter �� ȣ���ϱ�
; 32��Ʈ�� 64 ��Ʈ c �Լ� �ñ׳�ó�� �����ϰ� �Ϸ��� eax �� 64��Ʈ�� ��� ������ �ȵǹǷ�
; out �Ķ���͸� ����ϵ��� C �Լ��� �����. 
; 
; �ƴϸ� edx:eax �� �׳� �����ϰ� �ϴ� asm �Լ��� �����, 
; �װ� �ٽ� 64��Ʈ ������ �����ϰ� �ϴ� asm �Լ�/��ũ�θ� ���� ó���ϰ�, 
; C �Լ��� �׳� 64 ��Ʈ ������ �����ϰ� �ۼ��ϸ� �� (32 ��Ʈ�ڵ忡�� 64 ��Ʈ �����ϴ� �Լ�ó��)
;
; out parameter �� �����Ϸ������� ��� �������� Ȯ���غ� �ʿ� ����

;extern "C" BOOLEAN MsrRead2(IN ULONG32 ecx_value, OUT ULONG32* msr_high, OUT ULONG32* msr_low);
MsrRead2 proc
	push rdx		; save second out param
	
	rdmsr			; MSR[ecx] -> edx:eax
	mov r10d, edx
	pop rdx
	mov dword ptr [rdx], r10d
	
	mov dword ptr [r8], eax
	mov eax, 1
	ret
MsrRead2 endp

; MsrRead (ULONG32 ecx_value (rcx));
;------------------------------------------------------------------------------
MsrRead PROC
;	xor		rax, rax
	rdmsr				; MSR[ecx] --> edx:eax
	shl		rdx, 32
	or		rax, rdx
	ret
MsrRead ENDP

; MsrWrite (ULONG32 ecx_value (rcx), ULONG32 eax_value (rdx), ULONG32 edx_value (r8));
;------------------------------------------------------------------------------
MsrWrite PROC
	mov		rax, rdx
	mov		rdx, r8
	xor		r8, r8
	wrmsr
	mov		rax, r8		; r8 will be set to STATUS_UNSUCCESSFUL if there is a fault
	ret
MsrWrite ENDP




END




