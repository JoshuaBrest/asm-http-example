// Syscalls
.equ AUE_WRITE, 4
.equ AUE_EXIT, 1
.equ AUE_SOCKET, 97
.equ AUE_SETSOCKOPT, 105
.equ AUE_BIND, 104
.equ AUE_LISTEN, 106
.equ AUE_ACCEPT, 30
.equ AUE_CLOSE, 6

.macro syscalls_write fd, cbuf, nbyte
    mov X0, \fd // File descriptor
    mov X1, \cbuf // Buffer
    mov X2, \nbyte // Length
    mov X16, #AUE_WRITE // syscall number
    svc 0
.endm

.macro syscalls_exit rval
    mov X0, \rval // Status
    mov X16, #AUE_EXIT // syscall number
    svc 0
.endm

.macro syscalls_socket family, type, protocol
    mov X0, \family // Socket family
    mov X1, \type // Socket type
    mov X2, \protocol // Protocol
    mov X16, #AUE_SOCKET // syscall number
    svc 0
.endm

.macro syscalls_setsockopt s, level, name, val, valsize
    mov X0, \s // Socket file descriptor
    mov X1, \level // Level
    mov X2, \name // Name
    mov X3, \val // Value
    mov X4, \valsize // Length
    mov X16, #AUE_SETSOCKOPT // syscall number
    svc 0
.endm

.macro syscalls_bind s, name, namelen
    mov X0, \s // Socket file descriptor
    mov X1, \name // Address
    mov X2, \namelen // Length
    mov X16, #AUE_BIND // syscall number
    svc 0
.endm

.macro syscalls_listen s, backlog
    mov X0, \s // Socket file descriptor
    mov X1, \backlog // Backlog
    mov X16, #AUE_LISTEN // syscall number
    svc 0
.endm

.macro syscalls_accept s, addr, addrlen
    mov X0, \s // Socket file descriptor
    mov X1, \addr // Address
    mov X2, \addrlen // Length
    mov X16, #AUE_ACCEPT // syscall number
    svc 0
.endm

.macro syscalls_close fd
    mov X0, \fd // File descriptor
    mov X16, #AUE_CLOSE // syscall number
    svc 0
.endm