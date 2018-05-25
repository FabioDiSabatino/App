function serialConnection = initSerial(com,baudrate,bufferSize)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
s= serial(com);
set(s,"BaudRate",baudrate);
set(s,'InputBufferSize',bufferSize);
set(s,'Terminator','CR');



%Open serial port using properties setted by initSerial function

 fopen(s);
s.Status
serialConnection=s;

end


