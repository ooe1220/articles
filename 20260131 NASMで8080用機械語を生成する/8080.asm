; --- MVI ---
%macro MVI 2
%ifidni %1,A
    db 0x3E, %2
%elifidni %1,B
    db 0x06, %2
%elifidni %1,C
    db 0x0E, %2
%elifidni %1,D
    db 0x16, %2
%elifidni %1,E
    db 0x1E, %2
%elifidni %1,H
    db 0x26, %2
%elifidni %1,L
    db 0x2E, %2
%else
    %error "Unsupported MVI register"
%endif
%endmacro


; --- STA addr ---
%macro STA 1
    db 0x32, (%1 & 0xFF), ((%1 >> 8) & 0xFF)
%endmacro

; '8','0','8','0' を書く
MVI A, '8'
STA 6000h
MVI A, 4Fh
STA 6001h

MVI A, '0'
STA 6002h
MVI A, 4Fh
STA 6003h

MVI A, '8'
STA 6004h
MVI A, 4Fh
STA 6005h

MVI A, '0'
STA 6006h
MVI A, 4Fh
STA 6007h
