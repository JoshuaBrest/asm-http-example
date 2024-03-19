// ARM-MacOS assembly
.global _main
.align 4

#include "syscalls.s"

// Web server settings
.equ PORT, 4520

// Constants
.equ AF_INET, 2
.equ SOCK_STREAM, 1
.equ IPPROTO_IP, 0
.equ INADDR_ANY, 0
.equ SOL_SOCKET, 1
.equ SO_REUSEADDR, 2
.equ TCP_NODELAY, 1
.equ SO_LINGER, 128

_main:
    adrp X1, labels_startingserver@page // address of labels_startingserver
    add X1, X1, labels_startingserver@pageoff // address of labels_startingserver
    ldr X2, =labellength_startingserver // length of labels_startingserver
    syscalls_write #1, X1, X2 // write(1, labels_startingserver, labellength_startingserver)

    // Create a socket
    syscalls_socket #AF_INET, #SOCK_STREAM, xzr // socket(AF_INET, SOCK_STREAM, 0)

    // Check the return value equal to 0
    cmp X0, #0
    beq error_socketCreateFailed

    // Save the item for later use
    mov X10, X0 // x8 = socket

    // Set the socket options
    syscalls_setsockopt X10, #SOL_SOCKET, #SO_REUSEADDR, #1, #4 // setsockopt(socket, SOL_SOCKET, SO_REUSEADDR, 1, 4)
    syscalls_setsockopt X10, #IPPROTO_IP, #TCP_NODELAY, #1, #4 // setsockopt(socket, IPPROTO_IP, TCP_NODELAY, 1, 4)
    syscalls_setsockopt X10, #SOL_SOCKET, #SO_LINGER, #0, #4 // setsockopt(socket, SOL_SOCKET, SO_LINGER, 0, 4)


    // Create a sockaddr_in struct
    adrp X0, storage_sockaddr_in@page // address of storage_sockaddr_in
    add X0, X0, storage_sockaddr_in@pageoff // address of storage_sockaddr_in
    mov W1, #AF_INET // sin_family=AF_INET
    strb W1, [X0, 1] // storage_sockaddr_in.sin_family=AF_INET
    mov W1, #PORT // sin_port=PORT
    rev16 W1, W1 // reverse the bytes
    strh W1, [X0, 2] // storage_sockaddr_in.sin_port=PORT
    mov W1, #INADDR_ANY // sin_addr.s_addr=INADDR_ANY
    strb W1, [X0, 4] // storage_sockaddr_in.sin_addr.s_addr=INADDR_ANY

    // Save the item for later use
    mov X9, X0 // x9 = storage_sockaddr_in

    // Bind the socket
    syscalls_bind X10, X9, #16 // bind(socket, storage_sockaddr_in, 16)

    // Check the return value
    cmp X0, #0
    b.lt error_socketBindFailed

    // Bind the socket
    syscalls_listen X10, #10 // listen(socket, 10)

    // Check the return value
    cmp X0, #0
    b.lt error_socketListenFailed

    // Log the success
    adrp X1, labels_serverReady@page // address of labels_serverReady
    add X1, X1, labels_serverReady@pageoff // address of labels_serverReady
    ldr X2, =labellength_serverReady // length of labels_serverReady
    syscalls_write #1, X1, X2 // write(1, labels_serverReady, labellength_serverReady)

    // Loop to handle connections
    b handle_connection

    // exit(0)
    syscalls_exit 0

handle_connection:
    // Log that we are waiting for a connection
    adrp X1, labels_waitingForConnections@page // address of labels_waitingForConnections
    add X1, X1, labels_waitingForConnections@pageoff // address of labels_waitingForConnections
    ldr X2, =labellength_waitingForConnections // length of labels_waitingForConnections
    syscalls_write #1, X1, X2 // write(1, labels_waitingForConnections, labellength_waitingForConnections)

    // Accept the connection
    syscalls_accept X10, xzr, xzr // accept(socket, NULL, NULL)

    // Save the return value for later use
    mov X8, X0 // x8 = connection

    // Check the return value
    cmp W0, #0
    b.lt error_socketAcceptFailed

    // Log that we have accepted a connection
    adrp X1, labels_sendingData@page // address of labels_sendingData
    add X1, X1, labels_sendingData@pageoff // address of labels_sendingData
    ldr X2, =labellength_sendingData // length of labels_sendingData
    syscalls_write #1, X1, X2 // write(1, labels_sendingData, labellength_sendingData)

    // Write the data
    adrp X1, labels_serverSocketReply@page // address of labels_serverSocketReply
    add X1, X1, labels_serverSocketReply@pageoff // address of labels_serverSocketReply
    ldr X2, =labellength_serverSocketReply // length of labels_serverSocketReply
    syscalls_write X8, X1, X2 // write(connection, labels_serverSocketReply, labellength_serverSocketReply)


    // Close the connection
    syscalls_close X8 // close(connection)
    
    // Restart loop
    b handle_connection

error_socketCreateFailed:
    adrp X1, labels_socketCreateFailed@page // address of labels_socketCreateFailed
    add X1, X1, labels_socketCreateFailed@pageoff // address of labels_socketCreateFailed
    ldr X2, =labellength_socketCreateFailed // length of labels_socketCreateFailed
    syscalls_write #1, X1, X2 // write(1, labels_startingserver, labellength_startingserver)

    syscalls_exit 1 // exit(1)

error_socketBindFailed:
    adrp X1, labels_socketBindFailed@page // address of labels_socketBindFailed
    add X1, X1, labels_socketBindFailed@pageoff // address of labels_socketBindFailed
    ldr X2, =labellength_socketBindFailed // length of labels_socketBindFailed
    syscalls_write #1, X1, X2 // write(1, labels_startingserver, labellength_startingserver)

    syscalls_exit 1 // exit(1)

error_socketListenFailed:
    adrp X1, labels_socketListenFailed@page // address of labels_socketListenFailed
    add X1, X1, labels_socketListenFailed@pageoff // address of labels_socketListenFailed
    ldr X2, =labellength_socketListenFailed // length of labels_socketListenFailed
    syscalls_write #1, X1, X2 // write(1, labels_startingserver, labellength_startingserver)

    syscalls_exit 1 // exit(1)

error_socketAcceptFailed:
    adrp X1, labels_socketAcceptFailed@page // address of labels_socketAcceptFailed
    add X1, X1, labels_socketAcceptFailed@pageoff // address of labels_socketAcceptFailed
    ldr X2, =labellength_socketAcceptFailed // length of labels_socketAcceptFailed
    syscalls_write #1, X1, X2 // write(1, labels_startingserver, labellength_startingserver)

    syscalls_exit 1 // exit(1)

.data
.align 2
storage_sockaddr_in:
    .ds 16 // sin_family (short) + sin_port (unsigned short) + sin_addr (struct in_addr) + sin_zero (char[8])
