.MODEL SMALL
.STACK 100H
.DATA
    menu DB "1. Create Account$"
    menu2 DB "2. Deposit Amount$"
    menu3 DB "3. Withdraw Amount$"
    menu4 DB "4. Delete Account$"
    menu5 DB "5. Exit$"

    accPrompt DB 0DH, 0AH,"Enter 4-digit Account Number: $"
    amountPrompt DB 0DH, 0AH,"Enter Amount (up to 8 digits): $"
    accCreated DB 0DH, 0AH, "Account Created Successfully!$"
    amountDeposit DB 0DH, 0AH, "Amount has been Deposited Successfully!$"
    amountWithdrawn DB 0DH, 0AH, "Amount has been Withdrawn Successfully!$"
    insufficient DB 0DH, 0AH,"Insufficient Balance$"
    deletedMessage DB 0DH, 0AH,"Account Deleted Successfully!$"
    invalidOption DB 0DH, 0AH,"Invalid Option!$"
    invalidInput DB 0DH, 0AH,"Invalid Input!$"
    newline DB 0DH, 0AH, '$'
    prompt DB "Enter your choice: $"
    accNumber DB 5 DUP('$') ; Storage for 4-digit account number
    depositAmount DB 9 DUP('$') ; Storage for deposit amount
    withdrawAmount DB 9 DUP('$') ; Storage for withdrawal amount

    balance DW 0 ; Simulated balance storage

.CODE
MAIN PROC
    ; Initialize Data Segment
    MOV AX, @DATA
    MOV DS, AX

START:
    ; Display menu options
    LEA DX, menu
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, menu2
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, menu3
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, menu4
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    LEA DX, menu5
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H

    ; Prompt for user choice
    LEA DX, prompt
    MOV AH, 09H
    INT 21H

    ; Read user choice
    MOV AH, 01H
    INT 21H
    SUB AL, '0'  ; Convert ASCII to integer

    ; Process user choice
    CMP AL, 1
    JE CREATE_ACCOUNT
    CMP AL, 2
    JE DEPOSIT_AMOUNT
    CMP AL, 3
    JE WITHDRAW_AMOUNT
    CMP AL, 4
    JE DELETE_ACCOUNT
    CMP AL, 5
    JE EXIT_PROGRAM

    ; Invalid option
    LEA DX, invalidOption
    MOV AH, 09H
    INT 21H
    JMP START

CREATE_ACCOUNT:
    LEA DX, accPrompt
    MOV AH, 09H
    INT 21H

    ; Read 4-digit account number
    MOV CX, 4          ; Number of digits to read
    LEA DI, accNumber  ; Point to storage location
    XOR BL, BL         ; Reset counter for validation

READ_ACC:
    MOV AH, 01H
    INT 21H
    CMP AL, '0'
    JB INVALID_ACC     ; Ensure input is numeric
    CMP AL, '9'
    JA INVALID_ACC
    MOV [DI], AL       ; Store digit in accNumber
    INC DI             ; Move to next position
    INC BL             ; Increment counter
    LOOP READ_ACC

    CMP BL, 4
    JNE INVALID_ACC    ; Ensure exactly 4 digits were entered
    MOV BYTE PTR [DI], '$' ; Null-terminate the string

    ; Simulate account creation
    LEA DX, accCreated
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    JMP START

INVALID_ACC:
    LEA DX, invalidInput
    MOV AH, 09H
    INT 21H
    JMP CREATE_ACCOUNT

DEPOSIT_AMOUNT:
    LEA DX, accPrompt
    MOV AH, 09H
    INT 21H

    ; Read account number (input simulation)
    CALL READ_ACCOUNT_NUMBER

    LEA DX, amountPrompt
    MOV AH, 09H
    INT 21H

    ; Read deposit amount
    MOV CX, 8          ; Maximum 8 digits
    LEA DI, depositAmount
    XOR BL, BL         ; Reset counter for validation

READ_DEP:
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH        ; Check if Enter key is pressed
    JE VALIDATE_DEP    ; Finish input on Enter
    CMP AL, '0'
    JB INVALID_DEP     ; Ensure input is numeric
    CMP AL, '9'
    JA INVALID_DEP
    MOV [DI], AL       ; Store digit in depositAmount
    INC DI             ; Move to next position
    INC BL             ; Increment counter
    CMP BL, 8
    JGE VALIDATE_DEP   ; Stop input after 8 digits
    JMP READ_DEP

VALIDATE_DEP:
    CMP BL, 0
    JE INVALID_DEP     ; Ensure at least one digit entered
    MOV BYTE PTR [DI], '$' ; Null-terminate the string

    ; Update balance
    MOV AX, 0          ; Reset AX
    LEA SI, depositAmount
SUM_DEP:
    MOV AL, [SI]       ; Load byte from memory at SI into AL
    CMP AL, '$'
    JE END_DEP_SUM
    SUB AL, '0'
    MOV CX, 10
    MUL CX
    ADD AX, DX
    INC SI             ; Move to the next character
    JMP SUM_DEP
END_DEP_SUM:
    ADD [balance], AX

    ; Simulate deposit success
    LEA DX, amountDeposit
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    JMP START

INVALID_DEP:
    LEA DX, invalidInput
    MOV AH, 09H
    INT 21H
    JMP DEPOSIT_AMOUNT

WITHDRAW_AMOUNT:
    LEA DX, accPrompt
    MOV AH, 09H
    INT 21H

    ; Read account number (input simulation)
    CALL READ_ACCOUNT_NUMBER

    LEA DX, amountPrompt
    MOV AH, 09H
    INT 21H

    ; Read withdrawal amount
    MOV CX, 8          ; Maximum 8 digits
    LEA DI, withdrawAmount
    XOR BL, BL         ; Reset counter for validation

READ_WITH:
    MOV AH, 01H
    INT 21H
    CMP AL, 0DH        ; Check if Enter key is pressed
    JE VALIDATE_WITH   ; Finish input on Enter
    CMP AL, '0'
    JB INVALID_WITH    ; Ensure input is numeric
    CMP AL, '9'
    JA INVALID_WITH
    MOV [DI], AL       ; Store digit in withdrawAmount
    INC DI             ; Move to next position
    INC BL             ; Increment counter
    CMP BL, 8
    JGE VALIDATE_WITH  ; Stop input after 8 digits
    JMP READ_WITH

VALIDATE_WITH:
    CMP BL, 0
    JE INVALID_WITH    ; Ensure at least one digit entered
    MOV BYTE PTR [DI], '$' ; Null-terminate the string

    ; Convert withdrawal amount to numeric
    MOV AX, 0          ; Reset AX
    LEA SI, withdrawAmount
SUM_WITH:
    MOV AL, [SI]       ; Load byte from memory at SI into AL
    CMP AL, '$'
    JE END_WITH_SUM
    SUB AL, '0'
    MOV CX, 10
    MUL CX
    ADD AX, DX
    INC SI             ; Move to the next character
    JMP SUM_WITH
END_WITH_SUM:

    ; Check balance
    CMP [balance], AX
    JB INSUFFICIENT_BAL
    SUB [balance], AX

    ; Simulate withdrawal success
    LEA DX, amountWithdrawn
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    JMP START

INSUFFICIENT_BAL:
    LEA DX, insufficient
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    JMP START

INVALID_WITH:
    LEA DX, invalidInput
    MOV AH, 09H
    INT 21H
    JMP WITHDRAW_AMOUNT

DELETE_ACCOUNT:
    LEA DX, accPrompt
    MOV AH, 09H
    INT 21H

    ; Read account number (input simulation)
    CALL READ_ACCOUNT_NUMBER

    ; Simulate account deletion
    MOV [balance], 0
    LEA DX, deletedMessage
    MOV AH, 09H
    INT 21H
    LEA DX, newline
    MOV AH, 09H
    INT 21H
    JMP START

EXIT_PROGRAM:
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP

READ_ACCOUNT_NUMBER PROC
    MOV CX, 4          ; Number of digits to read
    LEA DI, accNumber  ; Point to storage location
    XOR BL, BL         ; Reset counter for validation

READ_ACC_LOOP:
    MOV AH, 01H
    INT 21H
    CMP AL, '0'
    JB INVALID_ACC     ; Ensure input is numeric
    CMP AL, '9'
    JA INVALID_ACC
    MOV [DI], AL       ; Store digit in accNumber
    INC DI             ; Move to next position
    INC BL             ; Increment counter
    LOOP READ_ACC_LOOP

    CMP BL, 4
    JNE INVALID_ACC    ; Ensure exactly 4 digits were entered
    MOV BYTE PTR [DI], '$' ; Null-terminate the string
    RET
READ_ACCOUNT_NUMBER ENDP

END MAIN