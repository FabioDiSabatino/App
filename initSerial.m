function [serialPort] = initSerial(com,baudrate,bufferSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
delete(instrfindall);
s= serial(com);
set(s,"BaudRate",baudrate);
set(s,'InputBufferSize',bufferSize);
set(s,'Terminator','CR');



%Open serial port using properties setted by initSerial function
 fopen(s);

serialPort=s;

end


