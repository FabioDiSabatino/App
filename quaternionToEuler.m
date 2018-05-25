function [r,p,y] = quaternionToEuler(q)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
q0=q(1);
q1=q(2);
q2=q(3);
q3=q(4);

%Calculate the roll angle
r=atan2(2*(q2*q3+q0*q1),(q0^2-q1^2-q2^2+q3^2));

%Calculate the pitch angle
p=asin(2*(q0*q2 - q1*q3)/(q0^2+q1^2+q2^2+q3^2));

%Calculate the yaw angle
y=atan2(2*(q1*q2+q0*q3),(q0^2+q1^2-q2^2-q3^2));

end

