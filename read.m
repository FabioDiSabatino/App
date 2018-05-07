function [x1,x2,x3] = read(connection)


%Read data from buffer till the end of line 
out= fgetl(connection);
    
%Split Accelerometer and gyroscope data
[x,y]=splitLcData(out);
x1=x(1);
x2=x(2);
x3=x(3);
closeConnection(connection);
end

