function [qk,Pk] = Stage0(w,p_qk,p_Pk,t)
%UNTITLED Summary of this function goes here
% input:
%   -w:    actual angular velocity read at time T by the sensor
%   -p_qk: previous (better) angular state estimation comes out either from
%          stage 1 or stage 2 depending on how many dof has the IMU
%   -p_Pk: previous noise covariance matrix
% 
% output:
%   -qk: the actual system state estimation by using gyro only
%   -Pk: the noise covariance matrix

wx=w(1);
wy=w(2);
wz=w(3);

%Matrix of the angular velocities 
Omega=[0, -wx, -wy, -wz;
       wx,  0,  wz, -wy;
       wy, -wz,  0,  wx;
       wz,  wy, -wx,   0];
   
I=eye(4);

%The initial state set as horizontal position
q0=[1 0 0 0].';

%Initial value for error covariance matrix
P0= 0.5*eye(4);

%Noise covariance matrix considering as constant and independent
Qk=1e-06*eye(4);

%Calculation of the discrete time state transition matrix
Ak=I+1/2*Omega*t;



%-------------------------------start-------------------------------------%

%Check if it's the first iteration
if(p_qk==0)
   %Calculation of the first “a priori” system state estimation
   qk=Ak*q0;
   %Calculation of the first "a priori" noise covariance matrix
   Pk=(Ak*P0*Ak.')+Qk;
else
    %Calculation of the “a priori” system state estimation
    qk=Ak*p_qk;
    %Calculation of the "a priori" noise covariance matrix
    Pk=(Ak*p_Pk*Ak.')+Qk;
end



end

