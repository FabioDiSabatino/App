function [qk1,Pk1] = Stage1(acc,qk,Pk)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

q0=qk(1);
q1=qk(2);
q2=qk(3);
q3=qk(4);

I=eye(4);
Vk1=eye(4);

Hk1=[-2*q2  2*q3 -2*q0  2*q1;
     2*q1  2*q0  2*q3  2*q2;
     2*q0 -2*q1 -2*q2  2*q3];
 
 Kk1= Pk*Hk1.'*(Hk1*Pk*Hk1.' + Vk1*Rk1*Vk1.')^-1;
 
 h1_qk=[ 2*q1*q3 - 2*q0*q2;
         2*q0*q1 + 2*q2*q3;
         q0^2 - q1^2 - q2^2 + q3^2];
     
 qc1= Kk1*(acc-h1_qk);
 qc1(3)=0;
 
 qk1=qk+qc1;
 
 Pk1=(I - Kk1*Hk1)*Pk;
end

