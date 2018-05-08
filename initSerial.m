function [serialPort] = initSerial(com,baudrate,bufferSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
s= serial(com);
set(s,"BaudRate",baudrate);
set(s,'InputBufferSize',bufferSize);
set(s,'Terminator','CR');
 s.Status
%Open serial port using properties setted by initSerial function
if(s.Status=='closed')
    fopen(s);
end

serialPort=s;

end


