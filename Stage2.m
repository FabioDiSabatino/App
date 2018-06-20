function [qk2,Pk2] = Stage2(magnet,qk,Pk)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


q0=qk(1);
q1=qk(2);
q2=qk(3);
q3=qk(4);

I=eye(4);
Vk2=eye(3);

Rk2=eye(3);

%Calculation of the Jacobean matrix
Hk2=[2*q3  2*q2 2*q1  2*q0;
     2*q0  -2*q1  -2*q2  -2*q3;
     -2*q1 -2*q0  2*q3,  2*q2];

%Calculation of the Kalman gain 
Kk2= Pk*(Hk2.')*(Hk2*Pk*(Hk2.') + Vk2*Rk2*Vk2.')^(-1);
 
%calculation of h1(qk)
 h2_qk=[ 2*q1*q2 + 2*q0*q3;
         q0^2 - q1^2 - q2^2 - q3^2;
         2*q2*q3 - 2*q0*q1];
     
%Calculation of the correction factor 
qc2= Kk2*(magnet.'-h2_qk);
qc2(2)=0;
qc2(3)=0;

%Calculation of the "a posteriori" state estimation
qk2=qk+qc2;
 

%Calculation of the "a posteriori" error covariance matrix
Pk2=(I - Kk2*Hk2)*Pk;
end

