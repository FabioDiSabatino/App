function [acc,gyro,magneto,rotation] = read(data,mode)

g=9.80664999999998;


 
z1=[0 0 0];
typecast(z1(1),'double');
typecast(z1(2),'double');
typecast(z1(3),'double');


z2=[0 0 0];
typecast(z2(1),'double');
typecast(z2(2),'double');
typecast(z2(3),'double');

z3=[0 0 0];
typecast(z3(1),'double');
typecast(z3(2),'double');
typecast(z3(3),'double');

r=[0 0 0];
typecast(r(1),'double');
typecast(r(2),'double');
typecast(r(3),'double');

if(mode==1)
    %Split Accelerometer, gyroscope and estimated position by micro data
    [z1,z2,z3,r]=split9DOFData(data);
    

else
     [z1,z2,r]=split6DOFData(data);
end




%Accelerometer data are expressed in G unit in the inertial frame
%z1=z1*g;

acc=z1;

gyro=z2;

gyro(1)=gyro(1)*pi/180;
gyro(2)=gyro(2)*pi/180;
gyro(3)=gyro(3)*pi/180;

magneto=z3;

rotation=r;









end

