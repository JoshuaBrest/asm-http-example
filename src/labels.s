.data
.global labels_startingserver
.global labellength_startingserver
.global labels_socketCreateFailed
.global labellength_socketCreateFailed
.global labels_socketBindFailed
.global labellength_socketBindFailed
.global labels_socketListenFailed
.global labellength_socketListenFailed
.global labels_socketAcceptFailed
.global labellength_socketAcceptFailed
.global labels_serverReady
.global labellength_serverReady
.global labels_waitingForConnections
.global labellength_waitingForConnections
.global labels_sendingData
.global labellength_sendingData
.global labels_serverSocketReply
.global labellength_serverSocketReply

labels_startingserver:
    .asciz "Starting server...\n"
labellength_startingserver = . - labels_startingserver

labels_socketCreateFailed:
    .asciz "Socket creation failed\n"
labellength_socketCreateFailed = . - labels_socketCreateFailed

labels_socketBindFailed:
    .asciz "Socket bind failed\n"
labellength_socketBindFailed = . - labels_socketBindFailed

labels_socketListenFailed:
    .asciz "Socket listen failed\n"
labellength_socketListenFailed = . - labels_socketListenFailed

labels_socketAcceptFailed:
    .asciz "Socket accept failed\n"
labellength_socketAcceptFailed = . - labels_socketAcceptFailed

labels_serverReady:
    .asciz "Server ready at http://127.0.0.1:4520/\n"
labellength_serverReady = . - labels_serverReady

labels_waitingForConnections:
    .asciz "Waiting for connection...\n"
labellength_waitingForConnections = . - labels_waitingForConnections

labels_sendingData:
    .asciz "Sending data...\n"
labellength_sendingData = . - labels_sendingData

labels_serverSocketReply:
    .asciz "HTTP/1.1 200 OK\nContent-Type: text/html\nContent-Length: 52\n\n<!DOCTYPE html><html><body>Hello World</body></html>"
labellength_serverSocketReply = . - labels_serverSocketReply
