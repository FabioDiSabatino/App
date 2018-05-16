function [accData,gyroData,rotationData] = splitHcData(data)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
data=string(data);
data=strsplit(data,'|');

accData=data(1);
accData=strsplit(accData,';');
accData=str2double(accData);


gyroData=data(2);
gyroData=strsplit(gyroData,';');
gyroData=str2double(gyroData);

rotationData=data(3);
rotationData=strsplit(rotationData,';');
rotationData=str2double(rotationData);



end

