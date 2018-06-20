function [accData,gyroData,magnetoData,rotationData] = split9DOFData(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

data=strsplit(data,'|');



accData=data(1);
accData=strsplit(accData,';');
accData=str2double(accData);


gyroData=data(2);
gyroData=strsplit(gyroData,';');
gyroData=str2double(gyroData);

magnetoData=data(3);
magnetoData=strsplit(magnetoData,';');
magnetoData=str2double(magnetoData);

rotationData=data(4);
rotationData=strsplit(rotationData,';');
rotationData=str2double(rotationData);



end

