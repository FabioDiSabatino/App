function [acc,gyro,rotation] = read(connection)

g=9.80664999999998;

%Read data from buffer till the end of line 
out= fgetl(connection);
    
z1=[0 0 0];
typecast(z1(1),'double');
typecast(z2(2),'double');
typecast(z3(3),'double');


z2=[0 0 0];
typecast(z2(1),'double');
typecast(z2(2),'double');
typecast(z3(3),'double');


r=[0 0 0];
typecast(r(1),'double');
typecast(r(2),'double');
typecast(r(3),'double');

%Split Accelerometer, gyroscope and estimated position by micro data
[z1,z2,r]=splitHcData(out);

%Accelerometer data are expressed in G unit in the inertial frame
z1=z1*g;

acc=z1;
gyro=z2;
rotation=r;







end

